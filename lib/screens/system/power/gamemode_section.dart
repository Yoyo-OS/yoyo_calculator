import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ficons;
import 'package:provider/provider.dart';
import 'package:yoyo_settings/services/gamemode_service.dart';
import 'gamemode_model.dart';

class GameModeSection extends StatefulWidget {
  const GameModeSection({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<GameModeModel>(
      create: (_) => GameModeModel(GameModeService()),
      child: const GameModeSection(),
    );
  }

  @override
  State<GameModeSection> createState() => _GameModeSectionState();
}

class _GameModeSectionState extends State<GameModeSection> {
  @override
  void initState() {
    super.initState();
    context.read<GameModeModel>().init();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<GameModeModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Game Mode",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6.0),
        Card(
            child: Wrap(alignment: WrapAlignment.spaceBetween, children: [
          Wrap(
            spacing: 10.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              Icon(ficons.FluentIcons.games_24_regular, size: 22.0),
              Text(
                "Game Mode",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          ToggleSwitch(
            checked: true,
            onChanged: (v) {},
          ),
        ])),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
