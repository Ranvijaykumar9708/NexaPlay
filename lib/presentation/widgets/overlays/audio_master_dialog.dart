import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/audio_master_viewmodel.dart';
import '../../../widgets/tv_focusable.dart';

class AudioMasterDialog extends ConsumerWidget {
  final bool isTV;

  const AudioMasterDialog({
    super.key,
    this.isTV = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterVm = ref.watch(audioMasterProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: isTV ? 520 : 360),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surface.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPurple.withValues(alpha: 0.3),
              blurRadius: 24,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tune_rounded,
                          color: AppTheme.accentCyan, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        'Studio Master & Playback Controls',
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  TVFocusable(
                    onPressed: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(16),
                    child: const Icon(Icons.close, color: Colors.white60, size: 20),
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 24),

              // 1. IMAX Enhanced Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppTheme.accentCyan,
                title: Text(
                  'IMAX Enhanced (1.90:1 View)',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Expands movie to full screen without black letterbox bars',
                  style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textMuted),
                ),
                value: masterVm.isImaxEnhanced,
                onChanged: (_) => masterVm.toggleImax(),
              ),
              const Divider(color: Colors.white10),

              // 2. Clear Dialogue Booster
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppTheme.primaryViolet,
                title: Text(
                  'Clear Dialogue Booster (Night Mode)',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Suppresses explosive sounds and clarifies Hindi dialogues',
                  style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textMuted),
                ),
                value: masterVm.isDialogueBoosterOn,
                onChanged: (_) => masterVm.toggleDialogueBooster(),
              ),
              const Divider(color: Colors.white10),

              // 3. Playback Speed Selector
              const SizedBox(height: 8),
              Text(
                'Playback Speed',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
                  final isSelected = masterVm.playbackSpeed == speed;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: TVFocusable(
                        onPressed: () => masterVm.setPlaybackSpeed(speed),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryViolet
                                : AppTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.white12,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${speed}x',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // 4. Smart TV Sleep Timer
              Text(
                'Smart TV Sleep Timer',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Off', '15m', '30m', '45m', '60m', 'End of Episode'].map((timer) {
                  final isSelected = masterVm.sleepTimerText == timer;
                  return TVFocusable(
                    onPressed: () => masterVm.setSleepTimer(timer),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.accentCyan
                            : AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.white12,
                        ),
                      ),
                      child: Text(
                        timer,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.black : Colors.white70,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
