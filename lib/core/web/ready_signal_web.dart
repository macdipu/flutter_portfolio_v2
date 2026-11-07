import 'package:web/web.dart' as web;

/// Tells the HTML loader in index.html that the first real content is ready.
void signalPortfolioReady() {
  web.window.dispatchEvent(web.Event('portfolio-ready'));
}
