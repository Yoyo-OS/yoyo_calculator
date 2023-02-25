import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ficons;
import 'package:provider/provider.dart';
import 'package:yoyo_settings/services/power_profile_service.dart';
import 'power_profile_model.dart';
import 'power_profile_x.dart';

class PowerProfileSection extends StatefulWidget {
  const PowerProfileSection({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<PowerProfileModel>(
      create: (_) => PowerProfileModel(PowerProfileService()),
      child: const PowerProfileSection(),
    );
  }

  @override
  State<PowerProfileSection> createState() => _PowerProfileSectionState();
}

class _PowerProfileSectionState extends State<PowerProfileSection> {
  @override
  void initState() {
    super.initState();
    context.read<PowerProfileModel>().init();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PowerProfileModel>();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Text(
        "Power Profile",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 6.0),
      Card(
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
            Wrap(
              spacing: 10.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [
                Icon(ficons.FluentIcons.rocket_24_regular, size: 22.0),
                Text(
                  "Power Mode",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            ComboBox<PowerProfile>(
                value: model.profile,
                items: PowerProfile.values.map<ComboBoxItem<PowerProfile>>((e) {
                  return ComboBoxItem<PowerProfile>(
                    child: Text(e.localize()),
                    value: e,
                  );
                }).toList(),
                onChanged: (v) {
                  model.setProfile(v);
                }),
          ])),
      const SizedBox(height: 12.0),
    ]);
  }
}
