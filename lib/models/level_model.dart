// lib/models/level_model.dart
class LevelCommand {
  final String command;
  final String hint;
  final List<String> keywords; // keywords untuk fuzzy match (case-insensitive)
  final String outputSuccess;
  final String outputFail;

  const LevelCommand({
    required this.command,
    required this.hint,
    required this.keywords,
    required this.outputSuccess,
    required this.outputFail,
  });
}

class GameLevel {
  final int id;
  final String name;
  final String category;
  final String targetIP;
  final String objective;
  final String briefingText;
  final String storyText;
  final List<LevelCommand> commands;
  final int baseScore;

  const GameLevel({
    required this.id,
    required this.name,
    required this.category,
    required this.targetIP,
    required this.objective,
    required this.briefingText,
    this.storyText = '',
    required this.commands,
    this.baseScore = 1000,
  });
}

class LeaderboardEntry {
  final String playerName;
  final int totalScore;
  final int levelsCompleted;
  final DateTime timestamp;
  final int totalTimeSeconds;

  LeaderboardEntry({
    required this.playerName,
    required this.totalScore,
    required this.levelsCompleted,
    required this.timestamp,
    required this.totalTimeSeconds,
  });

  Map<String, dynamic> toJson() => {
        'playerName': playerName,
        'totalScore': totalScore,
        'levelsCompleted': levelsCompleted,
        'timestamp': timestamp.toIso8601String(),
        'totalTimeSeconds': totalTimeSeconds,
      };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        playerName: json['playerName'] as String,
        totalScore: json['totalScore'] as int,
        levelsCompleted: json['levelsCompleted'] as int,
        timestamp: DateTime.parse(json['timestamp'] as String),
        totalTimeSeconds: json['totalTimeSeconds'] as int,
      );
}
