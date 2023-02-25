import 'dart:async';
import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:meta/meta.dart';

@visibleForTesting
const kGameModesInterface = 'com.feralinteractive.GameMode';

@visibleForTesting
const kGameModesPath = '/com/feralinteractive/GameMode';

class GameModeService {
  GameModeService([@visibleForTesting DBusRemoteObject? object])
      : _object = object ?? _createObject();

  static DBusRemoteObject _createObject() {
    return DBusRemoteObject(
      DBusClient.session(),
      name: kGameModesInterface,
      path: DBusObjectPath(kGameModesPath),
    );
  }

  Future<void> init() async {}

  Future<void> dispose() async {
    await _propertyListener?.cancel();
    await _object.client.close();
    _propertyListener = null;
  }

  final DBusRemoteObject _object;
  StreamSubscription<DBusPropertiesChangedSignal>? _propertyListener;
}
