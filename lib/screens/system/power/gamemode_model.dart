import 'dart:async';

import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:yoyo_settings/services/gamemode_service.dart';

export 'package:yoyo_settings/services/gamemode_service.dart' show GameMode;

class GameModeModel extends SafeChangeNotifier {
  GameModeModel(this._service);

  final GameModeService _service;

  void init() {
    _service.init().then((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  //void setProfile(GameMode? profile) => _service.setProfile(profile);
}
