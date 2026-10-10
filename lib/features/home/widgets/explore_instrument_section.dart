import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/begena_viewer_service.dart';
import '../../../core/services/js/begena_view_registrar.dart';
import '../../../core/theme/brand_palette.dart';
import '../../../shared/widgets/begena_viewer_stage.dart';

class ExploreInstrumentSection extends StatefulWidget {
  const ExploreInstrumentSection({super.key});

  @override
  State<ExploreInstrumentSection> createState() => _ExploreInstrumentSectionState();
}

class _ExploreInstrumentSectionState extends State<ExploreInstrumentSection> {
  final _service = BegenaViewerService();

  @override
  void initState() {
    super.initState();
    _service.mount(containerId: BegenaViewRegistrar.stageViewId);
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final am = lang == Language.am;
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1100),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  brand.surface.withValues(alpha: 0.9),
                  brand.beige.withValues(alpha: 0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: brand.beige),
            ),
            child: Column(
              children: [
                Text(
                  am ? 'መሣሪያውን ይመልከቱ' : 'Meet the instrument',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: brand.ink,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  am
                      ? 'ያሽከርክሩት፣ ያሳድጉት፣ እና አንድ ክፍል ይንኩ።'
                      : 'Rotate, zoom, and tap a part to learn what it is.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: brand.inkMuted, fontSize: 14.5),
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _service,
                  builder: (context, _) {
                    return LayoutBuilder(
                      builder: (context, c) {
                        final narrow = c.maxWidth < 820;
                        final stage = _Stage(service: _service);
                        final panel = _TextPanel(service: _service, am: am);
                        if (narrow) {
                          return Column(
                            children: [
                              stage,
                              const SizedBox(height: 20),
                              panel,
                            ],
                          );
                        }
                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(flex: 6, child: stage),
                              const SizedBox(width: 24),
                              Expanded(flex: 5, child: panel),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Stage extends StatelessWidget {
  final BegenaViewerService service;
  const _Stage({required this.service});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: brand.beige.withValues(alpha: 0.4),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Must always be mounted — see BegenaViewerStage's doc comment.
                  const BegenaViewerStage(),
                  if (!service.ready && service.error == null)
                    Container(
                      color: brand.surface,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: brand.amber,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Loading 3D model…',
                              style: TextStyle(color: brand.inkMuted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (service.error != null)
                    Container(
                      color: brand.surface,
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'Could not load the 3D model.\n${service.error}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: brand.inkMuted, fontSize: 13),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            _ToolbarButton(label: 'Front', onTap: () => service.setView('front')),
            _ToolbarButton(label: 'Side', onTap: () => service.setView('side')),
            _ToolbarButton(label: 'Back', onTap: () => service.setView('back')),
            _ToolbarButton(label: 'Reset', onTap: () => service.setView('home')),
          ],
        ),
      ],
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ToolbarButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: brand.ink,
        side: BorderSide(color: brand.amber.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}

class _TextPanel extends StatelessWidget {
  final BegenaViewerService service;
  final bool am;
  const _TextPanel({required this.service, required this.am});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final data = service.partsData;

    if (data == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: brand.surface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          am ? 'በመጫን ላይ…' : 'Loading…',
          style: TextStyle(color: brand.inkMuted),
        ),
      );
    }

    final parts = (data['parts'] as List).cast<Map<String, dynamic>>();
    final selected = service.selectedId == null
        ? null
        : parts.firstWhere(
            (p) => p['id'] == service.selectedId,
            orElse: () => <String, dynamic>{},
          );
    final notOnModelNote = data['notOnModelNote'] as String? ?? '';
    final intro = data['intro'] as Map<String, dynamic>?;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: brand.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: brand.beige),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected part's text, or the intro if nothing is selected yet.
          if (selected != null && selected.isNotEmpty)
            _PartDetail(part: selected, notOnModelNote: notOnModelNote, brand: brand)
          else if (intro != null)
            _IntroDetail(intro: intro, brand: brand),
          const SizedBox(height: 18),
          Divider(color: brand.beige),
          const SizedBox(height: 10),
          Text(
            am ? 'ሁሉም ክፍሎች' : 'All parts',
            style: TextStyle(color: brand.ink, fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in parts)
                ChoiceChip(
                  label: Text('${p['name']}${p['alt'] != null ? ' ${p['alt']}' : ''}'),
                  selected: p['id'] == service.selectedId,
                  showCheckmark: false,
                  selectedColor: brand.amber,
                  backgroundColor: brand.background,
                  labelStyle: TextStyle(
                    color: p['id'] == service.selectedId ? brand.background : brand.ink,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  onSelected: (_) => service.select(p['id'] as String),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IntroDetail extends StatelessWidget {
  final Map<String, dynamic> intro;
  final dynamic brand;
  const _IntroDetail({required this.intro, required this.brand});

  @override
  Widget build(BuildContext context) {
    final title = intro['title'] as String? ?? '';
    final blocks = (intro['blocks'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            color: brand.ink,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        for (final b in blocks) _Block(block: b, brand: brand),
      ],
    );
  }
}

class _PartDetail extends StatelessWidget {
  final Map<String, dynamic> part;
  final String notOnModelNote;
  final dynamic brand;
  const _PartDetail({required this.part, required this.notOnModelNote, required this.brand});

  @override
  Widget build(BuildContext context) {
    final name = part['name'] as String? ?? '';
    final alt = part['alt'] as String?;
    final onModel = part['onModel'] as bool? ?? true;
    final blocks = (part['blocks'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: name,
                style: GoogleFonts.playfairDisplay(
                  color: brand.ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (alt != null)
                TextSpan(
                  text: ' $alt',
                  style: TextStyle(color: brand.inkMuted, fontSize: 15),
                ),
            ],
          ),
        ),
        if (!onModel) ...[
          const SizedBox(height: 6),
          Text(
            notOnModelNote,
            style: TextStyle(color: brand.amber, fontSize: 12.5, fontStyle: FontStyle.italic),
          ),
        ],
        const SizedBox(height: 10),
        for (final b in blocks) _Block(block: b, brand: brand),
      ],
    );
  }
}

class _Block extends StatelessWidget {
  final Map<String, dynamic> block;
  final dynamic brand;
  const _Block({required this.block, required this.brand});

  @override
  Widget build(BuildContext context) {
    final label = block['label'] as String? ?? '';
    final text = block['text'] as String?;
    final list = (block['list'] as List?)?.cast<String>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Text(
              label,
              style: TextStyle(color: brand.amber, fontWeight: FontWeight.w700, fontSize: 13.5),
            ),
          if (text != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(text, style: TextStyle(color: brand.ink, fontSize: 14.5, height: 1.5)),
            ),
          if (list != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final item in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '•  $item',
                        style: TextStyle(color: brand.ink, fontSize: 14.5, height: 1.5),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
