import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class YoutubeEmbed extends StatefulWidget {
  final String videoId;
  const YoutubeEmbed({super.key, required this.videoId});

  @override
  State<YoutubeEmbed> createState() => _YoutubeEmbedState();
}

class _YoutubeEmbedState extends State<YoutubeEmbed> {
  static final Set<String> _registered = {};
  late String _viewType;

  @override
  void initState() {
    super.initState();
    _register();
  }

  @override
  void didUpdateWidget(covariant YoutubeEmbed old) {
    super.didUpdateWidget(old);
    if (old.videoId != widget.videoId) setState(_register);
  }

  void _register() {
    final id = widget.videoId;
    _viewType = 'yt-$id';
    if (_registered.contains(_viewType)) return;
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int _) {
      final iframe = web.HTMLIFrameElement()
        ..src = 'https://www.youtube-nocookie.com/embed/$id?rel=0&modestbranding=1'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true;
      iframe.allow =
          'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share';
      return iframe;
    });
    _registered.add(_viewType);
  }

  @override
  Widget build(BuildContext context) =>
      HtmlElementView(key: ValueKey(_viewType), viewType: _viewType);
}
