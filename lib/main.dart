import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:vocaber/generated/l10n.dart';
import 'package:vocaber/models/appconfig.dart';

import 'models/dailystat.dart';
import 'models/profile.dart';
import 'models/word.dart';
import 'screens/definition_screen.dart';
import 'screens/flashcard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/tutorial_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux || Platform.isMacOS) {
    final homeDir = Platform.environment['HOME']!;
    final xdgDataHome =
        Platform.environment['XDG_DATA_HOME'] ??
        p.join(homeDir, '.local', 'share');
    final appDir = Directory(p.join(xdgDataHome, 'vocaber'));

    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
    }

    Hive.init(appDir.path);
  } else {
    await Hive.initFlutter();
  }
  Hive.registerAdapter(WordAdapter());
  Hive.registerAdapter(DailyStatAdapter());
  await Hive.openBox<Word>('words');
  await Hive.openBox<DailyStat>('dailyStats');
  await Hive.openBox('profile');
  await AppConfig().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // supportedLocales: const [Locale('fr')],
      supportedLocales: const [Locale('en'), Locale('fr')],
      home: const Launcher(),
    );
  }
}

class Launcher extends StatefulWidget {
  const Launcher({super.key});

  @override
  State<Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  bool _showTutorial = false;
  bool _profileComplete = false;
  bool _appConfigInitialized = false;

  String? username;
  String? profileImageUrl;
  String? preferredLanguage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunch();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_appConfigInitialized) {
      AppConfig().localize(context);
      _appConfigInitialized = true;
    }
  }

  void _checkFirstLaunch() {
    username = Profile.getUsername();
    profileImageUrl = Profile.getProfileImageUrl();
    preferredLanguage = Profile.getPreferredLanguage();

    if (username == null || profileImageUrl == null) {
      setState(() {
        _showTutorial = true;
        _profileComplete = false;
      });
    } else {
      setState(() {
        _showTutorial = false;
        _profileComplete = true;
      });
    }
  }

  void _onFinishTutorial() {
    setState(() {
      _showTutorial = false;
      _profileComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showTutorial) {
      return TutorialScreen(onFinish: _onFinishTutorial);
    }
    if (_profileComplete) {
      return Home();
    }
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    DefinitionScreen(),
    FlashcardScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.search),
            label: AppLocalizations.of(context)!.navDefine,
          ),
          NavigationDestination(
            icon: Icon(Icons.school),
            label: AppLocalizations.of(context)!.navReview,
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: AppLocalizations.of(context)!.navProfile,
          ),
        ],
      ),
    );
  }
}
