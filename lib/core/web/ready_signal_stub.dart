/// No-op outside the browser.
void signalPortfolioReady() {}

/// Outside the browser there is no loader, so the page is ready at once.
Future<void> introFinished() async {}
