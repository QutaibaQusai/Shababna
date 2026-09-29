import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/chatbot_repository.dart';

sealed class FaqMatch {
  const FaqMatch();
}

class FaqSingleMatch extends FaqMatch {
  const FaqSingleMatch(this.question);

  final FaqQuestion question;
}

class FaqSeveralMatches extends FaqMatch {
  const FaqSeveralMatches(this.candidates);

  final List<FaqQuestionRef> candidates;
}

class FaqNoMatch extends FaqMatch {
  const FaqNoMatch();
}

class FaqAnswerFinder {
  FaqAnswerFinder(this._repository);

  static const minQueryLength = 2;
  static const _searchLimit = 5;
  static const _maxCandidates = 4;
  static const _maxKeywords = 3;
  static const _minKeywordLength = 3;

  static final _punctuation = RegExp(r'[^\p{L}\p{N}\s]', unicode: true);
  static final _whitespace = RegExp(r'\s+');

  static const _fillerWords = {
    'a', 'an', 'the', 'to', 'of', 'for', 'in', 'on', 'at', 'and', 'or', 'is', 'are', 'am',
    'be', 'was', 'were', 'do', 'does', 'did', 'i', 'me', 'my', 'you', 'your', 'we', 'our',
    'can', 'could', 'would', 'should', 'will', 'please', 'pls', 'how', 'what', 'when',
    'where', 'why', 'which', 'who', 'tell', 'about', 'with', 'from', 'this', 'that', 'it',
    'its', 'hi', 'hello', 'hey', 'thanks', 'thank', 'know', 'want', 'need', 'get', 'give',
    'show', 'explain', 'info', 'information', 'any', 'some', 'there', 'much', 'many',
    'في', 'من', 'عن', 'علي', 'الي', 'هل', 'ما', 'ماذا', 'كيف', 'متي', 'اين', 'لماذا', 'لو',
    'سمحت', 'فضلك', 'انا', 'ممكن', 'يمكن', 'يمكنني', 'اريد', 'عندي', 'هو', 'هي', 'هذا',
    'هذه', 'ذلك', 'التي', 'الذي', 'و', 'يا', 'مرحبا', 'شكرا', 'ابغي', 'بدي', 'اي', 'كم',
  };

  final ChatbotRepository _repository;

  Future<Either<Failure, FaqMatch>> find(String text) async {
    final query = _normalize(text);
    if (query.length < minQueryLength) return const Right(FaqNoMatch());

    final fullResult = await _search(query);
    if (fullResult.isLeft()) return _asFailure(fullResult);
    final fullHits = _hits(fullResult);
    if (fullHits.isNotEmpty) return _resolve(fullHits, hasClearWinner: fullHits.length == 1);

    final keywords = _keywords(query);
    if (keywords.isEmpty) return const Right(FaqNoMatch());

    final keywordQuery = keywords.join(' ');
    if (keywordQuery != query) {
      final keywordResult = await _search(keywordQuery);
      if (keywordResult.isLeft()) return _asFailure(keywordResult);
      final keywordHits = _hits(keywordResult);
      if (keywordHits.isNotEmpty) {
        return _resolve(keywordHits, hasClearWinner: keywordHits.length == 1);
      }
    }

    if (keywords.length < 2) return const Right(FaqNoMatch());
    return _rankByKeyword(keywords.take(_maxKeywords).toList());
  }

  Future<Either<Failure, FaqMatch>> _rankByKeyword(List<String> keywords) async {
    final scores = <String, int>{};
    final refs = <String, FaqQuestionRef>{};

    for (final keyword in keywords) {
      final result = await _search(keyword);
      if (result.isLeft()) return _asFailure(result);
      for (final hit in _hits(result)) {
        refs.putIfAbsent(hit.id, () => hit);
        scores.update(hit.id, (score) => score + 1, ifAbsent: () => 1);
      }
    }

    if (refs.isEmpty) return const Right(FaqNoMatch());

    final ranked = refs.values.toList()
      ..sort((a, b) => scores[b.id]!.compareTo(scores[a.id]!));
    final topScore = scores[ranked.first.id]!;
    final isClearWinner = ranked.length == 1 || topScore > scores[ranked[1].id]!;
    return _resolve(ranked, hasClearWinner: isClearWinner);
  }

  Future<Either<Failure, FaqMatch>> _resolve(
    List<FaqQuestionRef> hits, {
    required bool hasClearWinner,
  }) async {
    if (!hasClearWinner) {
      return Right(FaqSeveralMatches(hits.take(_maxCandidates).toList()));
    }
    final result = await _repository.getQuestion(hits.first);
    return result.map(FaqSingleMatch.new);
  }

  Future<Either<Failure, List<FaqQuestionRef>>> _search(String query) {
    return _repository.searchQuestions(query, limit: _searchLimit);
  }

  List<FaqQuestionRef> _hits(Either<Failure, List<FaqQuestionRef>> result) {
    return result.getOrElse(() => const []);
  }

  Either<Failure, FaqMatch> _asFailure(Either<Failure, List<FaqQuestionRef>> result) {
    return result.fold((failure) => Left(failure), (_) => const Right(FaqNoMatch()));
  }

  List<String> _keywords(String query) {
    return query
        .split(' ')
        .where((word) => word.length >= _minKeywordLength && !_fillerWords.contains(word))
        .toSet()
        .toList();
  }

  String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp('[أإآ]'), 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll(_punctuation, ' ')
        .replaceAll(_whitespace, ' ')
        .trim();
  }
}
