import 'package:fluent_ui/fluent_ui.dart';

import 'package:yoyo_settings/widgets/page.dart';

class WiredPage extends StatefulWidget {
  const WiredPage({Key? key}) : super(key: key);

  @override
  State<WiredPage> createState() => _WiredPageState();
}

class _WiredPageState extends State<WiredPage> with PageMixin {
  bool selected = true;
  String? comboboxValue;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));

    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Wired network'),
      ),
      children: const [],
    );
  }
}
