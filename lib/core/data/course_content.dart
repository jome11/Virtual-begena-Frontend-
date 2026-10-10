class ContentBlock {
  final String type; // 'p' | 'li' | 'table'
  final String text;
  final int level;
  final List<List<String>> rows;
  const ContentBlock({
    required this.type,
    this.text = '',
    this.level = 0,
    this.rows = const [],
  });

  factory ContentBlock.fromJson(Map<String, dynamic> j) => ContentBlock(
        type: j['type'] as String,
        text: j['text'] as String? ?? '',
        level: (j['level'] as num?)?.toInt() ?? 0,
        rows: [
          for (final r in (j['rows'] as List? ?? const []))
            [for (final c in r as List) c as String],
        ],
      );

  int get words => text.isNotEmpty
      ? text.split(' ').length
      : rows.expand((r) => r).join(' ').split(' ').length;
}

class ContentSection {
  final String? heading;
  final List<ContentBlock> blocks;
  final bool extra;
  const ContentSection(this.heading, this.blocks, {this.extra = false});
  int get words => blocks.fold(0, (a, b) => a + b.words);
}

class CourseContent {
  static Future<List<ContentSection>?> chapter(int n) async => null;
}
