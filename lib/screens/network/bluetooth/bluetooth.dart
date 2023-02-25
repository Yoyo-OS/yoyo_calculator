import 'dart:async';

import 'package:bluez/bluez.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ficons;
import 'package:provider/provider.dart';

import 'package:yoyo_settings/widgets/page.dart';

import 'bluetooth_device_row.dart';
import 'bluetooth_model.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({Key? key}) : super(key: key);

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> with PageMixin {
  String? comboboxValue;
  var blueZClient = BlueZClient();
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    return ChangeNotifierProvider<BluetoothModel>(
      create: (_) => BluetoothModel(blueZClient),
      child: const BluetoothWidget(),
    );
  }
}

class BluetoothWidget extends StatefulWidget {
  const BluetoothWidget({super.key});

  @override
  State<BluetoothWidget> createState() => _BluetoothWidgetState();
}

class _BluetoothWidgetState extends State<BluetoothWidget> {
  bool selected = true;
  @override
  void initState() {
    final model = context.read<BluetoothModel>();
    model.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BluetoothModel>();
    final bluetoothExpanderKey =
        GlobalKey<ExpanderState>(debugLabel: 'Bluetooth ExpanderKey key');
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Bluetooth'),
      ),
      children: [
        Expander(
          key: bluetoothExpanderKey,
          initiallyExpanded: model.powered,
          onStateChanged: (v) {
            if (v) {
              model.setPowered(true);
            }
          },
          header: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10.0,
            children: const [
              Icon(ficons.FluentIcons.wifi_1_24_regular, size: 22.0),
              Text(
                "Bluetooth",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          trailing: Row(children: [
            TextButton(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                model.discovering
                    ? const SizedBox(
                        width: 10,
                        height: 10,
                        child: ProgressRing(),
                      )
                    : const SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  model.discovering ? "Stop discovery" : "Start discovery",
                ),
              ]),
              onPressed: model.powered
                  ? () => model.discovering
                      ? runZoned(() {
                          model.stopDiscovery();
                        })
                      : runZoned(() {
                          model.startDiscovery();
                        })
                  : null,
            ),
            ToggleSwitch(
              checked: model.powered,
              onChanged: (v) {
                model.setPowered(v);
                if (!v) {
                  bluetoothExpanderKey.currentState?.setState(() {
                    false;
                  });
                }
              },
            ),
          ]),
          content: ListView.builder(
            shrinkWrap: true,
            itemCount: model.devices.length,
            itemBuilder: (context, index) {
              if (model.devices[index].name.isNotEmpty) {
                return BluetoothDeviceRow.create(
                  context,
                  model.devices[index],
                  () async => model.removeDevice(model.devices[index]),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        )
      ],
    );
  }
}
