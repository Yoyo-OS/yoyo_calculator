import 'dart:async';

import 'package:bluez/bluez.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ficons;

class BluetoothDeviceModel extends SafeChangeNotifier {
  final BlueZDevice _device;
  StreamSubscription? _deviceSubscription;
  late bool connected;
  late String name;
  late int appearance;
  late int deviceClass;
  late String alias;
  late bool blocked;
  late String address;
  late bool paired;
  late String errorMessage;
  late bool connecting;
  late BlueZAdapter adapter;
  late BlueZAddressType addressType;
  late String icon;
  late bool legacyPairing;
  late bool wakeAllowed;
  late int txPower;
  late List<BlueZGattService> gattServices;

  static Map<String, IconData> bluetoothIcons = <String, IconData>{
    'ac-adapter': ficons.FluentIcons.power_24_regular,
    'audio-card': ficons.FluentIcons.bluetooth_20_filled,
    'audio-headphones': ficons.FluentIcons.headphones_24_regular,
    'audio-headset': ficons.FluentIcons.bluetooth_20_filled,
    'audio-input-microphone': ficons.FluentIcons.slide_microphone_24_regular,
    'audio-speakers': ficons.FluentIcons.speaker_bluetooth_24_regular,
    'auth-fingerprint': ficons.FluentIcons.bluetooth_20_filled,
    'battery': ficons.FluentIcons.bluetooth_20_filled,
    'camera-photo': ficons.FluentIcons.camera_24_regular,
    'camera-video': ficons.FluentIcons.camera_24_regular,
    'computer': ficons.FluentIcons.bluetooth_20_filled,
    'drive-harddisk': ficons.FluentIcons.bluetooth_20_filled,
    'drive-harddisk-solidstate': ficons.FluentIcons.bluetooth_20_filled,
    'drive-harddisk-usb': ficons.FluentIcons.bluetooth_20_filled,
    'drive-multidisk': ficons.FluentIcons.bluetooth_20_filled,
    'drive-optical': ficons.FluentIcons.bluetooth_20_filled,
    'drive-removable-media': ficons.FluentIcons.bluetooth_20_filled,
    'input-dialpad': ficons.FluentIcons.dialpad_24_regular,
    'input-gaming': ficons.FluentIcons.games_24_regular,
    'input-keyboard': ficons.FluentIcons.keyboard_24_regular,
    'input-mouse': ficons.FluentIcons.keyboard_mouse_16_regular,
    'input-touchpad': ficons.FluentIcons.bluetooth_20_filled,
    'input-tablet': ficons.FluentIcons.phone_tablet_24_regular,
    'media-flash': ficons.FluentIcons.bluetooth_20_filled,
    'media-floppy': ficons.FluentIcons.bluetooth_20_filled,
    'media-optical': ficons.FluentIcons.bluetooth_20_filled,
    'media-removable': ficons.FluentIcons.bluetooth_20_filled,
    'media-tape': ficons.FluentIcons.bluetooth_20_filled,
    'multimedia-player': ficons.FluentIcons.bluetooth_20_filled,
    'network-wired': ficons.FluentIcons.bluetooth_20_filled,
    'network-wireless': ficons.FluentIcons.bluetooth_20_filled,
    'pda': ficons.FluentIcons.bluetooth_20_filled,
    'phone': ficons.FluentIcons.phone_24_regular,
    'printer': ficons.FluentIcons.print_24_regular,
    'printer-network': ficons.FluentIcons.print_24_regular,
    'video-display': ficons.FluentIcons.bluetooth_20_filled,
    'preferences-desktop-keyboard': ficons.FluentIcons.bluetooth_20_filled,
    'touchpad-disabled': ficons.FluentIcons.bluetooth_20_filled,
    'thunderbolt': ficons.FluentIcons.bluetooth_20_filled,
  };
  BluetoothDeviceModel(this._device) {
    updateFromClient();
    errorMessage = '';
  }

  void init() {
    _deviceSubscription = _device.propertiesChanged.listen((event) {
      updateFromClient();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _deviceSubscription?.cancel();
    super.dispose();
  }

  void updateFromClient() {
    connected = _device.connected;
    name = _device.name;
    appearance = _device.appearance;
    alias = _device.alias;
    blocked = _device.blocked;
    address = _device.address;
    paired = _device.paired;
    adapter = _device.adapter;
    addressType = _device.addressType;
    icon = _device.icon;
    legacyPairing = _device.legacyPairing;
    wakeAllowed = _device.wakeAllowed;
    txPower = _device.txPower;
    gattServices = _device.gattServices;
  }

  Future<void> connect() async {
    errorMessage = '';
    if (!_device.paired) {
      await _device.pair().catchError((ioError) {
        errorMessage = ioError.toString();
      });
      notifyListeners();
    }

    await _device.connect().catchError((ioError) {
      errorMessage = ioError.toString();
    });
    paired = _device.paired;
    connected = _device.connected;
    notifyListeners();
  }

  Future<void> disconnect() async {
    errorMessage = '';
    await _device.disconnect().catchError((ioError) {
      errorMessage = ioError.toString();
    });
    connected = _device.connected;
    notifyListeners();
  }
}
