import 'package:yoyo_settings/widgets/deferred_widget.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ficons;
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

import 'screens/home.dart';
import 'screens/settings.dart';

import 'routes/network.dart' deferred as networks;
import 'routes/system.dart' deferred as system;

import 'theme.dart';

const String appTitle = 'Settings';

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemTheme.accentColor.load();
  await flutter_acrylic.Window.initialize();
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.setMinimumSize(const Size(350, 600));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });

  runApp(const MyApp());
  Future.wait([
    DeferredWidget.preload(networks.loadLibrary),
    DeferredWidget.preload(system.loadLibrary),
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp(
          title: appTitle,
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          color: appTheme.color,
          // ignore: deprecated_member_use
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            fastAnimationDuration: Duration.zero,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          // ignore: deprecated_member_use
          theme: ThemeData(
            accentColor: appTheme.color,
            fastAnimationDuration: Duration.zero,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          locale: appTheme.locale,
          builder: (context, child) {
            return Directionality(
              textDirection: appTheme.textDirection,
              child: NavigationPaneTheme(
                data: NavigationPaneThemeData(
                  backgroundColor: appTheme.windowEffect !=
                          flutter_acrylic.WindowEffect.disabled
                      ? Colors.transparent
                      : null,
                ),
                child: child!,
              ),
            );
          },
          initialRoute: '/',
          routes: {'/': (context) => const MyHomePage()},
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  bool value = false;

  int index = 0;

  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();

  final List<NavigationPaneItem> originalItems = [
    PaneItem(
      icon: const Icon(ficons.FluentIcons.home_24_regular),
      title: const Text('Home'),
      body: const HomePage(),
    ),
    // NetWork
    PaneItemHeader(
      header: const Text('NetWork'),
    ),
    PaneItem(
      icon: const Icon(ficons.FluentIcons.wifi_1_24_regular),
      title: const Text('Wireless'),
      body: DeferredWidget(
        networks.loadLibrary,
        () => networks.WifiPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(ficons.FluentIcons.globe_desktop_24_regular),
      title: const Text('Wired'),
      body: DeferredWidget(
        networks.loadLibrary,
        () => networks.WiredPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(ficons.FluentIcons.bluetooth_24_regular),
      title: const Text('Bluetooth'),
      body: DeferredWidget(
        networks.loadLibrary,
        () => networks.BluetoothPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(ficons.FluentIcons.shield_keyhole_24_regular),
      title: const Text('Proxy'),
      body: DeferredWidget(
        networks.loadLibrary,
        () => networks.ProxyPage(),
      ),
    ),
    // System
    PaneItemHeader(
      header: const Text('System'),
    ),
    PaneItem(
      icon: const Icon(ficons.FluentIcons.rocket_24_regular),
      title: const Text('Power'),
      body: DeferredWidget(
        system.loadLibrary,
        () => system.PowerPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(ficons.FluentIcons.info_24_regular),
      title: const Text('About'),
      body: DeferredWidget(
        system.loadLibrary,
        () => system.InfoPage(),
      ),
    ),
  ];
  final List<NavigationPaneItem> footerItems = [
    PaneItemSeparator(),
    PaneItem(
      icon: const Icon(FluentIcons.settings),
      title: const Text('Settings'),
      body: Settings(),
    ),
    // ignore: todo
    // TODO: mobile widgets, Scrollbar, BottomNavigationBar, RatingBar
  ];

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: () {
          return const DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(appTitle),
            ),
          );
        }(),
        actions: Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
          WindowButtons(),
        ]),
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (i) {
          setState(() => index = i);
        },
        displayMode: appTheme.displayMode,
        indicator: () {
          switch (appTheme.indicator) {
            case NavigationIndicators.end:
              return const EndNavigationIndicator();
            case NavigationIndicators.sticky:
            default:
              return const StickyNavigationIndicator(
                duration: Duration(milliseconds: 200),
              );
          }
        }(),
        items: originalItems,
        autoSuggestBox: AutoSuggestBox(
          key: searchKey,
          controller: searchController,
          items: originalItems.whereType<PaneItem>().map((item) {
            assert(item.title is Text);
            final text = (item.title as Text).data!;

            return AutoSuggestBoxItem(
              label: text,
              value: text,
              onSelected: () async {
                final itemIndex = NavigationPane(
                  items: originalItems,
                ).effectiveIndexOf(item);

                setState(() => index = itemIndex);
                await Future.delayed(const Duration(milliseconds: 17));
                searchController.clear();
              },
            );
          }).toList(),
          placeholder: 'Search',
        ),
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        footerItems: footerItems,
      ),
      onOpenSearch: () {
        searchFocusNode.requestFocus();
      },
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final ThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
