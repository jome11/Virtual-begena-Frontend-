import 'dart:convert';
import 'package:flutter/services.dart';
import '../constants/app_strings.dart';

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
  static final Map<String, Map<int, List<ContentSection>>> _cache = {};

  static Future<List<ContentSection>?> chapter(int n) async {
    final en = languageNotifier.value == Language.en;
    final key = en ? 'en' : 'am';
    try {
      _cache[key] ??= await _load(en);
    } catch (_) {
      return null;
    }
    return _cache[key]![n];
  }

  static Future<Map<int, List<ContentSection>>> _load(bool en) async {
    return _parse(
      await rootBundle.loadString(
        en ? 'assets/course/chapters_en.json' : 'assets/course/chapters.json',
      ),
      extra: false,
    );
  }

  static Map<int, List<ContentSection>> _parse(String raw, {required bool extra}) {
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return {
      for (final c in data['chapters'] as List)
        (c['number'] as num).toInt(): [
          for (final s in c['sections'] as List)
            ContentSection(
              s['heading'] as String?,
              [
                for (final b in s['blocks'] as List)
                  ContentBlock.fromJson(b as Map<String, dynamic>),
              ],
              extra: extra,
            ),
        ],
    };
  }
}
