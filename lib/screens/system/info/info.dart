import 'package:filesize/filesize.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ficons;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:udisks/udisks.dart';

import 'info_model.dart';
import 'package:yoyo_settings/services/hostname_service.dart';
import 'package:yoyo_settings/widgets/page.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> with PageMixin {
  bool selected = true;
  String? comboboxValue;
  var hostnameService = HostnameService();
  var uDisksClient = UDisksClient();
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));

    return ChangeNotifierProvider<InfoModel>(
      create: (_) => InfoModel(
        hostnameService: hostnameService,
        uDisksClient: uDisksClient,
      ),
      child: const InfoWidget(),
    );
  }
}

class InfoWidget extends StatefulWidget {
  const InfoWidget({super.key});

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  @override
  void initState() {
    super.initState();

    final model = context.read<InfoModel>();
    model.init();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<InfoModel>();
    return ScaffoldPage.scrollable(
      header: PageHeader(title: Text(model.osName)),
      children: [
        ComputerWidget(),
        const SizedBox(height: 12.0),
        const HardwareWidget(),
        const SizedBox(height: 12.0),
        const SettingWidget(),
      ],
    );
  }
}

class ComputerWidget extends StatelessWidget {
  ComputerWidget({super.key});
  final controller = FlyoutController();
  final attachKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final model = context.watch<InfoModel>();
    final _controller = TextEditingController();

    return Card(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Text(
            model.hostname,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          FlyoutTarget(
            key: attachKey,
            controller: controller,
            child: Button(
              child: const Text("Rename the computer"),
              onPressed: () async {
                controller.showFlyout(
                  barrierDismissible: true,
                  dismissOnPointerMoveAway: false,
                  dismissWithEsc: true,
                  builder: (context) {
                    return FlyoutContent(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200,
                            child: TextBox(
                              maxLength: 20,
                              controller: _controller,
                              header: 'Enter your hostname:',
                              placeholder: 'Hostname',
                              expands: false,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Button(
                            child: const Text('Rename'),
                            onPressed: () {
                              model.setHostname(_controller.value.text);
                              Flyout.maybeOf(context)?.close();
                              displayInfoBar(context,
                                  builder: (context, close) {
                                return InfoBar(
                                  title: const Text('We did it!'),
                                  content: const Text(
                                      'The Hostname has been changed successfully'),
                                  action: IconButton(
                                    icon: const Icon(FluentIcons.clear),
                                    onPressed: close,
                                  ),
                                  severity: InfoBarSeverity.success,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class HardwareWidget extends StatelessWidget {
  const HardwareWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<InfoModel>();
    return Expander(
        initiallyExpanded: true,
        header: Wrap(
          spacing: 10.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: const [
            Icon(ficons.FluentIcons.developer_board_24_regular, size: 22.0),
            Text(
              "Hardware",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        content:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Wrap(alignment: WrapAlignment.spaceBetween, children: [
            const Text(
              "Processor",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('${model.processorName} x ${model.processorCount}'),
          ]),
          const SizedBox(height: 10.0),
          Wrap(alignment: WrapAlignment.spaceBetween, children: [
            const Text(
              "Memory",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('${model.memory} Gb'),
          ]),
          const SizedBox(height: 10.0),
          Wrap(alignment: WrapAlignment.spaceBetween, children: [
            const Text(
              "Graphics",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(model.graphics ?? 'No GPU info found'),
          ]),
          const SizedBox(height: 10.0),
          Wrap(alignment: WrapAlignment.spaceBetween, children: [
            const Text(
              "Disk Capacity",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
                model.diskCapacity != null ? filesize(model.diskCapacity) : ''),
          ]),
        ]),
        trailing: Button(
            child: Row(
              children: const [
                Icon(ficons.FluentIcons.copy_24_regular),
                SizedBox(width: 6.0),
                Text("Copy")
              ],
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(
                  text:
                      'Processor:${model.processorName} x ${model.processorCount}\nMemory:${model.memory} Gb\nGraphics:' +
                          (model.graphics ?? 'No GPU info found') +
                          '\nDisk Capacity:' +
                          (model.diskCapacity != null
                              ? filesize(model.diskCapacity)
                              : '')));
              displayInfoBar(context, builder: (context, close) {
                return InfoBar(
                  title: const Text('We did it!'),
                  content: const Text(
                      'Information has been copied to the clipboard'),
                  action: IconButton(
                    icon: const Icon(FluentIcons.clear),
                    onPressed: close,
                  ),
                  severity: InfoBarSeverity.success,
                );
              });
            }));
  }
}

class SettingWidget extends StatelessWidget {
  const SettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<InfoModel>();
    return Expander(
        initiallyExpanded: true,
        header: Wrap(
          spacing: 10.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: const [
            Icon(ficons.FluentIcons.info_24_regular, size: 22.0),
            Text(
              "System",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        content:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Wrap(alignment: WrapAlignment.spaceBetween, children: [
            const Text(
              "OS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('${model.osName} ${model.osVersion} (${model.osType}-bit)'),
          ]),
          const SizedBox(height: 10.0),
          Wrap(alignment: WrapAlignment.spaceBetween, children: [
            const Text(
              "Kernel version",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(model.kernelVersion),
          ]),
          const SizedBox(height: 10.0),
          Wrap(alignment: WrapAlignment.spaceBetween, children: [
            const Text(
              "Windowing System",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(model.windowServer),
          ]),
        ]),
        trailing: Button(
            child: Row(
              children: const [
                Icon(ficons.FluentIcons.copy_24_regular),
                SizedBox(width: 6.0),
                Text("Copy")
              ],
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(
                  text:
                      'OS:${model.osName} ${model.osVersion} (${model.osType}-bit)\nKernel version:${model.kernelVersion}\nWindowing System:${model.windowServer}'));
              displayInfoBar(context, builder: (context, close) {
                return InfoBar(
                  title: const Text('We did it!'),
                  content: const Text(
                      'Information has been copied to the clipboard'),
                  action: IconButton(
                    icon: const Icon(FluentIcons.clear),
                    onPressed: close,
                  ),
                  severity: InfoBarSeverity.success,
                );
              });
            }));
  }
}
