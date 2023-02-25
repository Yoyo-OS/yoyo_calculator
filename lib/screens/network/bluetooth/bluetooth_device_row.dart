import 'package:bluez/bluez.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_settings/theme.dart';
import 'bluetooth_device_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ficons;

class BluetoothDeviceRow extends StatefulWidget {
  const BluetoothDeviceRow({Key? key, required this.removeDevice})
      : super(key: key);

  final AsyncCallback removeDevice;

  static Widget create(
    BuildContext context,
    BlueZDevice device,
    AsyncCallback removeDevice,
  ) {
    return ChangeNotifierProvider(
      create: (_) => BluetoothDeviceModel(device),
      child: BluetoothDeviceRow(
        removeDevice: removeDevice,
      ),
    );
  }

  @override
  State<BluetoothDeviceRow> createState() => _BluetoothDeviceRowState();
}

class _BluetoothDeviceRowState extends State<BluetoothDeviceRow> {
  late String status;

  @override
  void initState() {
    final model = context.read<BluetoothDeviceModel>();
    model.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BluetoothDeviceModel>();
    return GestureDetector(
      onTap: () => showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ChangeNotifierProvider.value(
          value: model,
          child: _BluetoothDeviceDialog(
            removeDevice: widget.removeDevice,
          ),
        ),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4, top: 4),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Icon(BluetoothDeviceModel.bluetoothIcons[model.icon]),
              Text(model.name),
            ]),
            Text(
              model.connected ? "Connected" : "Disconnect",
              // style: TextStyle(
              //   color:
              //       appTheme.of(context).colorScheme.onSurface.withOpacity(0.7),
              // ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _BluetoothDeviceDialog extends StatelessWidget {
  const _BluetoothDeviceDialog({Key? key, required this.removeDevice})
      : super(key: key);

  final AsyncCallback removeDevice;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BluetoothDeviceModel>();
    final appTheme = context.watch<AppTheme>();
    return ContentDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: Text(model.name)),
          //Icon(iconName.isEmpty ? YaruIcons.question : yaruIcons[model.icon]),
        ],
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          model.connected ? const Text("Connected") : const Text("Disconnect"),
          ToggleSwitch(
            checked: model.connected,
            onChanged: (connectRequested) async {
              connectRequested
                  ? await model.connect()
                  : await model.disconnect();
            },
          ),
        ]),
        const SizedBox(height: 10.0),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Paired"),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(model.paired ? "Yes" : "No"),
          ),
        ]),
        const SizedBox(height: 10.0),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Address"),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(model.address),
          ),
        ]),
        const SizedBox(height: 10.0),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Type"),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(model.icon.isEmpty ? "Unknown" : model.icon),
          ),
        ]),
        if (model.errorMessage.isNotEmpty)
          Text(
            model.errorMessage,
            style: TextStyle(color: appTheme.of(context).errorColor),
          )
      ]),
      actions: [
        Button(
          child: const Text('Open device settings'),
          onPressed: () {
            Navigator.pop(context, 'User deleted file');
            // Delete file here
          },
        ),
        FilledButton(
          child: const Text('Remove device'),
          onPressed: () async {
            if (model.connected) {
              await model.disconnect().onError(
                    (error, stackTrace) =>
                        model.errorMessage = error.toString(),
                  );
            }
            await removeDevice().onError(
              (error, stackTrace) => model.errorMessage = error.toString(),
            );
            Navigator.pop(context, 'User canceled dialog');
          },
        ),
      ],
    );
  }
}
