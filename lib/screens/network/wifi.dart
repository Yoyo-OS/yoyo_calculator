import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ficons;

import 'package:yoyo_settings/widgets/page.dart';

class WifiPage extends StatefulWidget {
  const WifiPage({Key? key}) : super(key: key);

  @override
  State<WifiPage> createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> with PageMixin {
  bool selected = true;
  String? comboboxValue;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));

    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Wireless network'),
      ),
      children: [
        Card(
            child: Wrap(alignment: WrapAlignment.spaceBetween, children: [
          Wrap(
            spacing: 10.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              Icon(ficons.FluentIcons.wifi_1_24_regular, size: 22.0),
              Text(
                "Wifi",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          ToggleSwitch(
            checked: selected,
            onChanged: (v) => setState(() => selected = v),
          ),
        ]))
      ],
    );
  }
}
