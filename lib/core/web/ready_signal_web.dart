import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Tells the HTML loader in index.html that the first real content is ready.
void signalPortfolioReady() {
  web.window.dispatchEvent(web.Event('portfolio-ready'));
}

/// Completes when the HTML intro has finished and faded out. If there is no
/// loader (or it never reports), completes after a short timeout so the page
/// is never held back.
Future<void> introFinished() {
  if (web.document.getElementById('app-loader') == null) {
    return Future<void>.value();
  }
  final done = Completer<void>();
  void onDone(web.Event _) {
    if (!done.isCompleted) done.complete();
  }

  web.window.addEventListener('intro-done', onDone.toJS);
  return done.future.timeout(const Duration(seconds: 15), onTimeout: () {});
}
