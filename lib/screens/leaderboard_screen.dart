// lib/screens/leaderboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../utils/game_state.dart';
import '../models/level_model.dart';
import '../widgets/cyber_background.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<LeaderboardEntry>? _entries;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries =
        await context.read<GameState>().loadLeaderboard();
    setState(() => _entries = entries);
  }

  @override
  Widget build(BuildContext context) {
    final game = context.read<GameState>();

    return Stack(
      fit: StackFit.expand,
      children: [
        const CyberBackground(),
        Container(color: const Color(0xFF121212).withValues(alpha: 0.68)),

        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Title
              Column(
                children: [
                  const Text(
                    '🏆  LEADERBOARD',
                    style: TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                      letterSpacing: 4,
                      shadows: [
                        Shadow(color: Color(0xFFFFD700), blurRadius: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'TOP 10 OPERATOR — SEMUA WAKTU',
                    style: TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.3),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ).animate().fadeIn().slideY(begin: -0.2),

              const SizedBox(height: 20),

              // Table header
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.3)),
                  color: const Color(0xFFFFD700).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    _header('#', 30),
                    _header('OPERATOR', 120),
                    _header('SCORE', 80),
                    _header('LVL', 50),
                    _header('TIME', 70),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Entries
              Expanded(
                child: _entries == null
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00ff41),
                        ),
                      )
                    : _entries!.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'BELUM ADA DATA',
                                  style: TextStyle(
                                    fontFamily: 'Courier New',
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.3),
                                    letterSpacing: 3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Selesaikan game untuk masuk leaderboard!',
                                  style: TextStyle(
                                    fontFamily: 'Courier New',
                                    fontSize: 11,
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            itemCount: _entries!.length,
                            itemBuilder: (ctx, i) =>
                                _EntryRow(entry: _entries![i], rank: i + 1)
                                    .animate()
                                    .fadeIn(
                                        delay: Duration(milliseconds: i * 80)),
                          ),
              ),

              // Back button
              Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () => game.goToMenu(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: const Color(0xFF00b4d8), width: 1.5),
                      color: const Color(0xFF00b4d8).withValues(alpha: 0.08),
                    ),
                    child: const Text(
                      '← KEMBALI KE MENU',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 14,
                        color: Color(0xFF00b4d8),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Courier New',
          fontSize: 10,
          color: Color(0xFFFFD700),
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;

  const _EntryRow({required this.entry, required this.rank});

  @override
  Widget build(BuildContext context) {
    final isTop3 = rank <= 3;
    final rankColor = rank == 1
        ? const Color(0xFFFFD700)
        : rank == 2
            ? const Color(0xFFC0C0C0)
            : rank == 3
                ? const Color(0xFFCD7F32)
                : Colors.white.withValues(alpha: 0.5);

    final totalMin = entry.totalTimeSeconds ~/ 60;
    final totalSec = entry.totalTimeSeconds % 60;
    final timeStr =
        '${totalMin.toString().padLeft(2, '0')}:${totalSec.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isTop3
              ? rankColor.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.08),
        ),
        color: isTop3
            ? rankColor.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.02),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '#$rank',
              style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: rankColor,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              entry.playerName.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: 13,
                color: isTop3 ? rankColor : Colors.white,
                fontWeight:
                    isTop3 ? FontWeight.bold : FontWeight.normal,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              '${entry.totalScore}',
              style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00ff41),
                shadows: isTop3
                    ? const [
                        Shadow(
                            color: Color(0xFF00ff41), blurRadius: 8)
                      ]
                    : null,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              '${entry.levelsCompleted}/15',
              style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              timeStr,
              style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
