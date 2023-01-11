import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/link.dart';

import '../widgets/changelog.dart';
import '../widgets/material_equivalents.dart';
import '../widgets/page.dart';
import '../widgets/sponsor.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with PageMixin {
  bool selected = true;
  String? comboboxValue;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final theme = FluentTheme.of(context);

    return ScaffoldPage.scrollable(
      header: PageHeader(
        title: const Text('Fluent UI Demo'),
      ),
      children: [],
    );
  }
}

class SponsorButton extends StatelessWidget {
  const SponsorButton({
    Key? key,
    required this.imageUrl,
    required this.username,
  }) : super(key: key);

  final String imageUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
          ),
          shape: BoxShape.circle,
        ),
      ),
      Text(username),
    ]);
  }
}
