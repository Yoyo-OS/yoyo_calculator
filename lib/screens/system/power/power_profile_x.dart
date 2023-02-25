import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ficons;
import 'package:flutter/widgets.dart';
import 'package:yoyo_settings/services/power_profile_service.dart';

extension PowerProfileX on PowerProfile {
  String localize() {
    switch (this) {
      case PowerProfile.performance:
        return "Performance";
      case PowerProfile.balanced:
        return "Balanced";
      case PowerProfile.powerSaver:
        return "PowerSaver";
    }
  }

  String localizeDescription() {
    switch (this) {
      case PowerProfile.performance:
        return "High performance and power usage";
      case PowerProfile.balanced:
        return "Standard performance and power usage";
      case PowerProfile.powerSaver:
        return "Reduced performance and power usage";
    }
  }

  IconData getIcon() {
    switch (this) {
      case PowerProfile.performance:
        return ficons.FluentIcons.rocket_24_regular;
      case PowerProfile.balanced:
        return ficons.FluentIcons.vehicle_car_24_regular;
      case PowerProfile.powerSaver:
        return ficons.FluentIcons.vehicle_bicycle_24_regular;
    }
  }
}
