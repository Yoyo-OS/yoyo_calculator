import 'dart:ffi';
import 'dart:io';

import 'package:linux_system_info/linux_system_info.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:yoyo_settings/services/hostname_service.dart';
import 'package:udisks/udisks.dart';

const kUbuntuLogoPath = '/usr/share/plymouth/ubuntu-logo.png';

class InfoModel extends SafeChangeNotifier {
  InfoModel({
    required HostnameService hostnameService,
    required UDisksClient uDisksClient,
    List<Cpu>? cpus,
    SystemInfo? systemInfo,
    MemInfo? memInfo,
    GnomeInfo? gnomeInfo,
  })  : _hostnameService = hostnameService,
        _uDisksClient = uDisksClient,
        _cpus = cpus ?? CpuInfo.getProcessors(),
        _systemInfo = systemInfo ?? SystemInfo(),
        _memInfo = memInfo ?? MemInfo(),
        _gnomeInfo = gnomeInfo ?? GnomeInfo();

  final HostnameService _hostnameService;
  final UDisksClient _uDisksClient;
  final List<Cpu> _cpus;
  final SystemInfo _systemInfo;
  final MemInfo _memInfo;
  final GnomeInfo _gnomeInfo;

  String? _gpuName = '';
  int? _diskCapacity;

  Future<void> init() async {
    await _hostnameService.init();

    await GpuInfo.load().then((gpus) {
      _gpuName = gpus.isNotEmpty ? gpus.first.model : null;
    });

    await _uDisksClient.connect().then((value) {
      _diskCapacity =
          _uDisksClient.drives.fold<int>(0, (sum, drive) => sum + drive.size);
    });

    notifyListeners();
  }

  String get hostname => _hostnameService.hostname;
  String get staticHostname => _hostnameService.staticHostname;

  void setHostname(String hostname) {
    _hostnameService.setHostname(hostname).then((_) => notifyListeners());
  }

  String get osName => _systemInfo.os_name;
  String get osVersion => _systemInfo.os_version;
  int get osType => sizeOf<IntPtr>() * 8;
  String get kernelVersion => _systemInfo.kernel_version;

  String get processorName => _cpus[0].model_name;
  int get processorCount => _cpus.length + 1;
  int get memory => _memInfo.mem_total_gb;
  String? get graphics => _gpuName;
  int? get diskCapacity => _diskCapacity;

  String get gnomeVersion => _gnomeInfo.version;
  String get windowServer => Platform.environment['XDG_SESSION_TYPE'] ?? '';
}
