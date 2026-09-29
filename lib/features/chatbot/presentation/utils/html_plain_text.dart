abstract final class HtmlPlainText {
  static final _lineBreaks = RegExp(r'<br\s*/?>|</p>|</li>', caseSensitive: false);
  static final _listItems = RegExp(r'<li[^>]*>', caseSensitive: false);
  static final _tags = RegExp(r'<[^>]*>');
  static final _spaces = RegExp(r'[ \t]+');
  static final _extraLines = RegExp(r'\n{3,}');

  static const _entities = {
    '&nbsp;': ' ',
    '&amp;': '&',
    '&quot;': '"',
    '&#39;': "'",
    '&apos;': "'",
    '&lt;': '<',
    '&gt;': '>',
  };

  static String from(String html) {
    var text = html
        .replaceAll(_listItems, '• ')
        .replaceAll(_lineBreaks, '\n')
        .replaceAll(_tags, '');
    _entities.forEach((entity, value) => text = text.replaceAll(entity, value));
    return text
        .replaceAll(_spaces, ' ')
        .split('\n')
        .map((line) => line.trim())
        .join('\n')
        .replaceAll(_extraLines, '\n\n')
        .trim();
  }
}
