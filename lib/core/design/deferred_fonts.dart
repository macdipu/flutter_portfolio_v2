import 'package:flutter/services.dart';

import 'tokens.dart';

/// Fonts the intro does not need, loaded in the background.
///
/// Fonts declared under `flutter: fonts:` are downloaded before Flutter web
/// draws its first frame. The reading face (Newsreader, ~950 KB) is only
/// needed once the page shows, so it is a plain asset loaded here instead;
/// text already laid out re-flows when it arrives.
abstract class DeferredFonts {
  static Future<void>? _load;

  /// The load started by [load], or nothing if it was never started.
  static Future<void> get pending => _load ?? Future<void>.value();

  static Future<void> load() => _load ??= () async {
        try {
          await (FontLoader(AppType.read)
                ..addFont(rootBundle.load('assets/fonts/Newsreader.ttf'))
                ..addFont(rootBundle.load('assets/fonts/Newsreader-Italic.ttf')))
              .load();
        } catch (_) {
          // The fallback face is fine; never block the page on a font.
        }
      }();
}
