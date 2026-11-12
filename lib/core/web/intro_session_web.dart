import 'package:web/web.dart' as web;

const _key = 'introSeen';

/// True once the intro has played in this browser tab, so a reload replays
/// only its last beat.
bool readIntroSeen() {
  try {
    return web.window.sessionStorage.getItem(_key) == '1';
  } catch (_) {
    return false;
  }
}

void writeIntroSeen() {
  try {
    web.window.sessionStorage.setItem(_key, '1');
  } catch (_) {}
}
