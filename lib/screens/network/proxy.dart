import 'package:fluent_ui/fluent_ui.dart';

import 'package:yoyo_settings/widgets/page.dart';

class ProxyPage extends StatefulWidget {
  const ProxyPage({Key? key}) : super(key: key);

  @override
  State<ProxyPage> createState() => _ProxyPageState();
}

class _ProxyPageState extends State<ProxyPage> with PageMixin {
  bool selected = true;
  String? comboboxValue;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));

    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Proxy network'),
      ),
      children: const [],
    );
  }
}
