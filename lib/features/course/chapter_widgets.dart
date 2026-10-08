import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/qenet.dart';
import '../../core/constants/tuning_data.dart';
import '../../core/data/curriculum.dart';
import '../../core/theme/brand_palette.dart';

BoxDecoration panelDecoration(BuildContext context) {
  final brand = context.brand;
  return BoxDecoration(
    color: brand.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: brand.beige),
  );
}

class _Chip extends StatelessWidget {
  final String label;
  final String value;
  final bool filled;
  const _Chip({required this.label, required this.value, required this.filled});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? brand.amber : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: filled ? brand.amber : brand.beige, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: filled ? Colors.white70 : brand.inkMuted)),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: filled ? Colors.white : brand.ink)),
        ],
      ),
    );
  }
}

class PartsExplorer extends StatelessWidget {
  const PartsExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('የበገና አካል ክፍሎችና ምሳሌያቸው', 'Parts of the begena and their symbolism'),
            style: TextStyle(color: brand.ink, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        for (final p in bodyParts)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: panelDecoration(context),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(p.$1,
                    style: TextStyle(color: brand.ink, fontWeight: FontWeight.w700)),
                subtitle: Text(p.$2,
                    style: TextStyle(color: brand.inkMuted, fontSize: 12)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedAlignment: Alignment.centerLeft,
                children: [
                  Text(p.$3, style: TextStyle(color: brand.ink, height: 1.6)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class FingerChart extends StatelessWidget {
  const FingerChart({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final notes = qenetTuning[Qenet.selamta]!['C']!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('የጣት ስያሜና አቀማመጥ', 'Finger names and strings'),
            style: TextStyle(color: brand.ink, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        for (final f in fingerTable)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: panelDecoration(context),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: brand.amber,
                  child: Text('${f.$1}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(tr(f.$2, f.$3),
                      style: TextStyle(color: brand.ink, fontWeight: FontWeight.w700)),
                ),
                _Chip(label: tr('ዋና አውታር', 'Main'), value: '${f.$4}', filled: true),
                const SizedBox(width: 8),
                _Chip(label: tr('ማረፊያ', 'Rest'), value: '${f.$5}', filled: false),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Text(
            tr('በሰላምታ ቅኝት (ሲ) እያንዳንዱ ዋና አውታር የሚሰጠው ድምጽ',
                'Note of each main string in Selamta (key of C)'),
            style: TextStyle(color: brand.inkMuted, fontSize: 13)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in activeStrings)
              _Chip(label: '${tr('አውታር', 'String')} $s', value: notes[s]!, filled: true),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => context.go('/free-play'),
          icon: const Icon(Icons.front_hand_rounded),
          label: Text(tr('በነጻ ጨዋታ ይሞክሩ', 'Try it in Free Play')),
        ),
      ],
    );
  }
}

class QenetExplorer extends StatefulWidget {
  const QenetExplorer({super.key});

  @override
  State<QenetExplorer> createState() => _QenetExplorerState();
}

class _QenetExplorerState extends State<QenetExplorer> {
  int _i = 0;

  Widget _kv(BuildContext context, String k, String v) {
    final brand = context.brand;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(k, style: TextStyle(color: brand.inkMuted, fontSize: 12)),
          const SizedBox(height: 2),
          Text(v, style: TextStyle(color: brand.ink, height: 1.5)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final s = scales[_i];
    final tuning = s.qenet == null ? null : qenetTuning[s.qenet]!['C']!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('የኢትዮጵያ ቅኝቶች', 'The qenet'),
            style: TextStyle(color: brand.ink, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < scales.length; i++)
              ChoiceChip(
                label: Text(tr(scales[i].name, scales[i].nameEn)),
                selected: i == _i,
                showCheckmark: false,
                selectedColor: brand.amber,
                labelStyle: TextStyle(
                    color: i == _i ? Colors.white : brand.ink,
                    fontWeight: FontWeight.w600),
                onSelected: (_) => setState(() => _i = i),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: panelDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final n in s.notes.split(' '))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: brand.amber.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(n,
                          style: TextStyle(
                              color: brand.amber,
                              fontWeight: FontWeight.w800,
                              fontSize: 16)),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              _kv(context, tr('የድምጽ ርቀት (ቶን)', 'Steps (tones)'), s.steps),
              _kv(context, tr('እንዴት ይገኛል', 'How it is derived'), s.how),
              if (s.song.isNotEmpty)
                _kv(context, tr('ስያሜው የተወሰደበት ዜማ', 'Named after the song'), s.song),
              if (tuning != null) ...[
                Text(tr('በበገና አውታሮች ላይ (ሲ)', 'On the begena strings (key of C)'),
                    style: TextStyle(color: brand.inkMuted, fontSize: 12)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final e in tuning.entries)
                      _Chip(
                          label: '${tr('አውታር', 'String')} ${e.key}',
                          value: e.value,
                          filled: true),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              if (s.qenet != null)
                FilledButton.icon(
                  onPressed: () => context.go('/exercise?qenet=${s.qenet!.name}'),
                  icon: const Icon(Icons.bolt_rounded),
                  label: Text(tr('ይህን ቅኝት ይለማመዱ', 'Practice this qenet')),
                )
              else
                Text(tr('የልምምድ ሞድ በቅርቡ ይታከላል', 'Practice mode coming soon'),
                    style: TextStyle(
                        color: brand.inkMuted, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ],
    );
  }
}
