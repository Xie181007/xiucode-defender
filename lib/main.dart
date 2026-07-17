// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'utils/game_state.dart';
import 'screens/menu_screen.dart';
import 'screens/briefing_screen.dart';
import 'screens/playing_screen.dart';
import 'screens/success_screen.dart';
import 'screens/gameover_screen.dart';
import 'screens/leaderboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock orientation to portrait for mobile
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Full immersive mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameState(),
      child: const XiuCodeDefenderApp(),
    ),
  );
}

class XiuCodeDefenderApp extends StatelessWidget {
  const XiuCodeDefenderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XiuCode Defender',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00ff41),
          secondary: Color(0xFF00b4d8),
          error: Color(0xFFFF2222),
          surface: Color(0xFF1a1a1a),
        ),
        fontFamily: 'Courier New',
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF1a1a1a),
          contentTextStyle: TextStyle(fontFamily: 'Courier New'),
        ),
      ),
      home: const GameRoot(),
    );
  }
}

class GameRoot extends StatelessWidget {
  const GameRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _buildScreen(game),
      ),
    );
  }

  Widget _buildScreen(GameState game) {
    switch (game.screen) {
      case GameScreen.menu:
        return const MenuScreen(key: ValueKey('menu'));
      case GameScreen.briefing:
        return const BriefingScreen(key: ValueKey('briefing'));
      case GameScreen.playing:
        return const PlayingScreen(key: ValueKey('playing'));
      case GameScreen.success:
        return const SuccessScreen(key: ValueKey('success'));
      case GameScreen.gameOver:
        return const GameOverScreen(key: ValueKey('gameover'));
      case GameScreen.leaderboard:
        return const LeaderboardScreen(key: ValueKey('leaderboard'));
    }
  }
}
