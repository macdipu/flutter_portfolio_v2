import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in a new browser tab. Returns false if it could not launch.
Future<bool> openUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  try {
    return await launchUrl(uri, webOnlyWindowName: '_blank');
  } catch (_) {
    return false;
  }
}

Future<void> copyText(String text) =>
    Clipboard.setData(ClipboardData(text: text));
