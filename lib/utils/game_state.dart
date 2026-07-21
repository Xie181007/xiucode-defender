// lib/utils/game_state.dart
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/level_model.dart';
import '../data/levels_data.dart';

enum GameScreen { menu, briefing, playing, success, gameOver, leaderboard }
enum XiuState { normal, success, fail }
class GameState extends ChangeNotifier {
  // ─── State ───
  GameScreen _screen = GameScreen.menu;
  XiuState _xiuState = XiuState.normal;
  String _username = 'xiudeveloper';

  int _currentLevelIndex = 0;
  int _currentCommandIndex = 0;
  int _secondsRemaining = 300; // 5 minutes
  int _totalScore = 0;
  int _levelScore = 0;
  int _wrongCount = 0;
  int _totalSecondsUsed = 0;
  bool _isTimerRunning = false;
  bool _screenShake = false;
  bool _redFlash = false;

  List<TerminalLine> _terminalLines = [];

  GameState() {
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? 'xiudeveloper';
    notifyListeners();
  }

  // ─── Getters ───
  GameScreen get screen => _screen;
  XiuState get xiuState => _xiuState;
  String get username => _username;

  void setUsername(String value) {
    if (value.trim().isNotEmpty) {
      _username = value.trim();
      _saveUsername(_username);
      notifyListeners();
    }
  }

  Future<void> _saveUsername(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
  }
  int get currentLevelIndex => _currentLevelIndex;
  int get secondsRemaining => _secondsRemaining;
  int get totalScore => _totalScore;
  int get levelScore => _levelScore;
  int get wrongCount => _wrongCount;
  bool get isTimerRunning => _isTimerRunning;
  bool get screenShake => _screenShake;
  bool get redFlash => _redFlash;
  List<TerminalLine> get terminalLines => List.unmodifiable(_terminalLines);
  GameLevel get currentLevel => gameLevels[_currentLevelIndex];
  LevelCommand get currentCommand =>
      currentLevel.commands[_currentCommandIndex];
  int get totalLevels => gameLevels.length;
  int get commandsInLevel => currentLevel.commands.length;
  int get currentCommandIndex => _currentCommandIndex;
  bool get isTimeDanger => _secondsRemaining <= 60;
  bool get isTimeCritical => _secondsRemaining <= 30;

  // ─── Navigation ───
  void goToMenu() {
    _screen = GameScreen.menu;
    _xiuState = XiuState.normal;
    notifyListeners();
  }

  void goToLeaderboard() {
    _screen = GameScreen.leaderboard;
    notifyListeners();
  }

  void startGame() {
    _currentLevelIndex = 0;
    _totalScore = 0;
    _totalSecondsUsed = 0;
    _startLevel();
  }

  void _startLevel() {
    _currentCommandIndex = 0;
    _secondsRemaining = 300;
    _levelScore = 0;
    _wrongCount = 0;
    _terminalLines = [];
    _xiuState = XiuState.normal;
    _screen = GameScreen.briefing;
    notifyListeners();
  }

  void startExploitation() {
    _screen = GameScreen.playing;
    _isTimerRunning = true;
    _addLine('', LineType.system);
    _addLine('root@xiu-defender:/var/log# uname -a', LineType.input);
    _addLine('Linux xiu-defender 5.15.0-kali1-amd64 #1 SMP Debian 5.15.15-2kali1 x86_64 GNU/Linux', LineType.system);
    _addLine('', LineType.system);
    _addLine('root@xiu-defender:/var/log# id', LineType.input);
    _addLine('uid=0(root) gid=0(root) groups=0(root)', LineType.system);
    _addLine('', LineType.system);
    _addLine('root@xiu-defender:~# ls /opt/xiucorp/bin/', LineType.input);
    _addLine('nmap  hydra  sqlmap  john  metasploit  xiucore', LineType.system);
    _addLine('', LineType.system);
    _addLine('[ xiucore ] Establishing encrypted tunnel to XiuCorp SOC...', LineType.system);
    _addLine('[ xiucore ] Tunnel established. Secure channel: ACTIVE', LineType.system);
    _addLine('[ xiucore ] Operator authenticated. Clearance: LEVEL-${_currentLevelIndex + 1}', LineType.system);
    _addLine('', LineType.system);
    _addLine('> TARGET: ${currentLevel.targetIP}', LineType.hint);
    _addLine('> OBJECTIVE: ${currentLevel.objective}', LineType.hint);
    _addLine('', LineType.system);
    _addLine('> HINT: ${currentCommand.hint}', LineType.hint);
    _addLine('', LineType.system);
    notifyListeners();
  }

  void injectInboxMessage() {
    if (_screen != GameScreen.playing) return;
    if (currentLevel.storyText.isEmpty) return;
    _addLine('', LineType.system);
    _addLine('------------------------------------------------------------', LineType.system);
    _addLine(' INCOMING TRANSMISSION // CLASSIFIED // PRIORITY: URGENT', LineType.inbox);
    _addLine(' FROM: XIU Artificial Intelligence // XiuCorp SOC Division', LineType.inbox);
    _addLine('------------------------------------------------------------', LineType.system);
    _addLine('', LineType.system);
    _addLine(currentLevel.storyText, LineType.inbox);
    _addLine('', LineType.system);
    _addLine('------------------------------------------------------------', LineType.system);
    _addLine(' END OF TRANSMISSION', LineType.inbox);
    _addLine('------------------------------------------------------------', LineType.system);
    _addLine('', LineType.system);
    notifyListeners();
  }

  // ─── Timer ───
  void tickTimer() {
    if (!_isTimerRunning || _secondsRemaining <= 0) return;
    _secondsRemaining--;

    if (_secondsRemaining <= 0) {
      _isTimerRunning = false;
      _triggerGameOver();
    } else {
      // trigger panic state at 60 seconds
      if (_secondsRemaining == 60) {
        _xiuState = XiuState.fail;
        _triggerRedFlash();
      }
      notifyListeners();
    }
  }

  void applyTimePenalty() {
    _secondsRemaining = (_secondsRemaining - 10).clamp(0, 300);
    _levelScore = (_levelScore - 100).clamp(-9999, 99999);
    _wrongCount++;
    _xiuState = XiuState.fail;
    _triggerScreenShake();
    _triggerRedFlash();

    if (_secondsRemaining <= 0) {
      _isTimerRunning = false;
      _triggerGameOver();
    }
    notifyListeners();
  }

  // ─── Command Input ───
  bool submitCommand(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return false;

    // Add player input line
    _addLine('$_username@xiucode:\$ $trimmed', LineType.input);

    // Validate command
    if (_matchesCommand(trimmed, currentCommand)) {
      _onCommandSuccess(trimmed);
      return true;
    } else {
      _onCommandFail(trimmed);
      return false;
    }
  }

  bool _matchesCommand(String input, LevelCommand cmd) {
    final lowerInput = input.toLowerCase();
    // All keywords must be present (case-insensitive)
    return cmd.keywords.every(
      (kw) => lowerInput.contains(kw.toLowerCase()),
    );
  }

  void _onCommandSuccess(String input) {
    _addLine(currentCommand.outputSuccess, LineType.success);
    _addLine('', LineType.system);
    _xiuState = XiuState.normal;

    _currentCommandIndex++;

    if (_currentCommandIndex >= currentLevel.commands.length) {
      // Level complete
      _isTimerRunning = false;
      final timeBonus = _secondsRemaining * 10;
      _levelScore += currentLevel.baseScore + timeBonus;
      _totalScore += _levelScore;
      _totalSecondsUsed += (300 - _secondsRemaining);
      _xiuState = XiuState.success;
      _screen = GameScreen.success;
    } else {
      // Next command in same level
      _addLine('> NEXT: ${currentCommand.hint}', LineType.hint);
    }
    notifyListeners();
  }

  void _onCommandFail(String input) {
    _addLine(currentCommand.outputFail, LineType.error);
    _addLine('', LineType.system);
    applyTimePenalty();
  }

  void _triggerGameOver() {
    _xiuState = XiuState.fail;
    _screen = GameScreen.gameOver;
    notifyListeners();
  }

  // ─── Level Progression ───
  void nextLevel() {
    if (_currentLevelIndex < gameLevels.length - 1) {
      _currentLevelIndex++;
      _startLevel();
    } else {
      // All 15 levels done!
      _screen = GameScreen.leaderboard;
      notifyListeners();
    }
  }

  void retryLevel() {
    _startLevel();
  }

  // ─── Visual Effects ───
  void _triggerScreenShake() {
    _screenShake = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      _screenShake = false;
      notifyListeners();
    });
  }

  void _triggerRedFlash() {
    _redFlash = true;
    Future.delayed(const Duration(milliseconds: 400), () {
      _redFlash = false;
      notifyListeners();
    });
  }

  // ─── Terminal Lines ───
  void _addLine(String text, LineType type) {
    _terminalLines.add(TerminalLine(text: text, type: type));
    // Keep last 200 lines max
    if (_terminalLines.length > 200) {
      _terminalLines.removeAt(0);
    }
  }

  // ─── Leaderboard ───
  Future<void> saveScore(String playerName) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList('leaderboard') ?? [];
    final entry = LeaderboardEntry(
      playerName: playerName,
      totalScore: _totalScore,
      levelsCompleted: _currentLevelIndex + 1,
      timestamp: DateTime.now(),
      totalTimeSeconds: _totalSecondsUsed,
    );
    existing.add(jsonEncode(entry.toJson()));
    // Keep top 50
    if (existing.length > 50) existing.removeAt(0);
    await prefs.setStringList('leaderboard', existing);
  }

  Future<List<LeaderboardEntry>> loadLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('leaderboard') ?? [];
    final entries = raw
        .map((s) => LeaderboardEntry.fromJson(jsonDecode(s)))
        .toList();
    entries.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    return entries.take(10).toList();
  }
}

// ─── Terminal Line Model ───
enum LineType { system, input, success, error, hint, inbox }

class TerminalLine {
  final String text;
  final LineType type;
  TerminalLine({required this.text, required this.type});
}
