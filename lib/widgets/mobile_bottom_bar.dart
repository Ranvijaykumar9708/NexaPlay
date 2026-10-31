import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'app_header.dart';

class MobileBottomBar extends StatelessWidget {
  final AppTab currentTab;
  final Function(AppTab) onTabSelected;

  const MobileBottomBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(Icons.home_rounded, 'Home', AppTab.home),
              _buildItem(Icons.live_tv_rounded, 'Live TV', AppTab.liveTv),
              _buildItem(Icons.movie_filter_outlined, 'Movies', AppTab.movies),
              _buildItem(Icons.download_for_offline_outlined, 'Downloads', AppTab.downloads),
              _buildItem(Icons.bookmark_border_rounded, 'My List', AppTab.myList),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, AppTab tab) {
    final isSelected = currentTab == tab;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabSelected(tab),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? AppTheme.primaryViolet : AppTheme.textMuted,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
