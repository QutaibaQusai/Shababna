import 'package:equatable/equatable.dart';

import '../../domain/repositories/chatbot_repository.dart';
import 'assistant_message.dart';

enum ChatbotTopicsStatus { loading, ready, failure }

class ChatbotState extends Equatable {
  const ChatbotState({
    this.topicsStatus = ChatbotTopicsStatus.loading,
    this.topics = const [],
    this.messages = const [],
    this.suggestions = const [],
    this.isBotTyping = false,
  });

  final ChatbotTopicsStatus topicsStatus;
  final List<ChatbotTopic> topics;
  final List<AssistantMessage> messages;
  final List<AssistantSuggestion> suggestions;
  final bool isBotTyping;

  bool get hasConversation => messages.isNotEmpty;

  ChatbotTopic? topicById(String id) {
    for (final topic in topics) {
      if (topic.id == id) return topic;
    }
    return null;
  }

  ChatbotState copyWith({
    ChatbotTopicsStatus? topicsStatus,
    List<ChatbotTopic>? topics,
    List<AssistantMessage>? messages,
    List<AssistantSuggestion>? suggestions,
    bool? isBotTyping,
  }) {
    return ChatbotState(
      topicsStatus: topicsStatus ?? this.topicsStatus,
      topics: topics ?? this.topics,
      messages: messages ?? this.messages,
      suggestions: suggestions ?? this.suggestions,
      isBotTyping: isBotTyping ?? this.isBotTyping,
    );
  }

  @override
  List<Object?> get props => [topicsStatus, topics, messages, suggestions, isBotTyping];
}
