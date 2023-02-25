import 'package:fluent_ui/fluent_ui.dart';

import 'package:yoyo_settings/widgets/page.dart';
import 'power_profile_section.dart';
import 'gamemode_section.dart';

class PowerPage extends StatefulWidget {
  const PowerPage({Key? key}) : super(key: key);

  @override
  State<PowerPage> createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage> with PageMixin {
  bool selected = true;
  String? comboboxValue;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Power'),
      ),
      children: [
        PowerProfileSection.create(context),
        GameModeSection.create(context),
      ],
    );
  }
}
