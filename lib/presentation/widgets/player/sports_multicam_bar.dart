import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/audio_master_viewmodel.dart';
import '../../../widgets/tv_focusable.dart';

class SportsMulticamBar extends ConsumerWidget {
  final bool isTV;

  const SportsMulticamBar({
    super.key,
    this.isTV = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterVm = ref.watch(audioMasterProvider);

    final angles = [
      {'name': 'Main Broadcast', 'icon': Icons.tv, 'angle': SportsCamAngle.mainFeed},
      {'name': 'Stump Cam', 'icon': Icons.sports_cricket, 'angle': SportsCamAngle.stumpCam},
      {'name': 'Tactical Bird-Eye', 'icon': Icons.visibility, 'angle': SportsCamAngle.tacticalBirdEye},
      {'name': 'Star Player Cam', 'icon': Icons.star, 'angle': SportsCamAngle.superstarCam},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.netflixRed,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'CAM',
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ...angles.map((item) {
            final isSelected = masterVm.currentCamAngle == item['angle'];
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: TVFocusable(
                onPressed: () {
                  masterVm.setCamAngle(item['angle'] as SportsCamAngle);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accentCyan
                        : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        size: 14,
                        color: isSelected ? Colors.black : Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['name'] as String,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.black : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
