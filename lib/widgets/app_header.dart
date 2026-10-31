import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../core/localization/app_strings.dart';
import '../viewmodels/app_providers.dart';
import 'nexaplay_logo.dart';
import 'tv_focusable.dart';

enum AppTab { home, movies, series, liveTv, kids, myList, downloads }

class AppHeader extends ConsumerWidget {
  final AppTab currentTab;
  final Function(AppTab) onTabSelected;
  final VoidCallback onSearchPressed;
  final VoidCallback onProfilePressed;
  final VoidCallback onSettingsPressed;
  final VoidCallback onVipPressed;
  final VoidCallback? onAiVoicePressed;
  final bool isTV;

  const AppHeader({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    required this.onSearchPressed,
    required this.onProfilePressed,
    required this.onSettingsPressed,
    required this.onVipPressed,
    this.onAiVoicePressed,
    this.isTV = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(trProvider);
    final currentLang = ref.watch(localeProvider).language;
    final profile = ref.watch(profileViewModelProvider).currentProfile;
    final isVip = ref.watch(vipProvider).isVip;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTV ? 48 : 16,
        vertical: isTV ? 18 : 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.background.withValues(alpha: 0.98),
            AppTheme.background.withValues(alpha: 0.65),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          // Brand Logo
          TVFocusable(
            onPressed: () => onTabSelected(AppTab.home),
            scaleFactor: 1.05,
            child: const NexaPlayLogo(size: 36, fontSize: 22),
          ),

          if (isTV) ...[
            const SizedBox(width: 28),
            // Navigation Links for TV
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildNavButton(tr('home'), AppTab.home),
                    _buildNavButton(tr('movies'), AppTab.movies),
                    _buildNavButton(tr('series'), AppTab.series),
                    _buildNavButton(tr('live_tv'), AppTab.liveTv, isLive: true),
                    _buildNavButton(tr('kids'), AppTab.kids),
                    _buildNavButton(tr('my_list'), AppTab.myList),
                    _buildNavButton(tr('downloads'), AppTab.downloads),
                  ],
                ),
              ),
            ),
          ] else ...[
            const Spacer(),
          ],

          // AI Cinephile Mood & Voice Matcher
          if (onAiVoicePressed != null) ...[
            TVFocusable(
              onPressed: onAiVoicePressed,
              borderRadius: BorderRadius.circular(16),
              scaleFactor: 1.08,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.white, size: 15),
                    const SizedBox(width: 4),
                    Text(
                      'AI MATCH',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],

          // VIP Gold Pass Button
          TVFocusable(
            onPressed: onVipPressed,
            borderRadius: BorderRadius.circular(16),
            scaleFactor: 1.08,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFFF5C518), Color(0xFFD97706)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF5C518).withValues(alpha: 0.35),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.workspace_premium,
                      color: Colors.black, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    isVip ? 'GOLD VIP' : 'GO VIP',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Language Switcher (EN / हिन्दी)
          TVFocusable(
            onPressed: () =>
                ref.read(localeProvider).toggleLanguage(),
            borderRadius: BorderRadius.circular(16),
            scaleFactor: 1.1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppTheme.surfaceLight,
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Text(
                currentLang == AppLanguage.english ? '🇮🇳 हिन्दी' : '🌐 EN',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Search
          TVFocusable(
            onPressed: onSearchPressed,
            borderRadius: BorderRadius.circular(24),
            scaleFactor: 1.15,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surfaceLight.withValues(alpha: 0.6),
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 10),

          // Profile Avatar
          TVFocusable(
            onPressed: onProfilePressed,
            borderRadius: BorderRadius.circular(24),
            scaleFactor: 1.15,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(int.parse(profile.avatarColor)),
                    AppTheme.primaryPink,
                  ],
                ),
                border: Border.all(color: Colors.white70, width: 1.5),
              ),
              child: Center(
                child: Text(
                  profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Settings Gear
          TVFocusable(
            onPressed: onSettingsPressed,
            borderRadius: BorderRadius.circular(24),
            scaleFactor: 1.15,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surfaceLight.withValues(alpha: 0.6),
              ),
              child: const Icon(Icons.settings_outlined,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String title, AppTab tab, {bool isLive = false}) {
    final isSelected = currentTab == tab;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TVFocusable(
        onPressed: () => onTabSelected(tab),
        borderRadius: BorderRadius.circular(20),
        scaleFactor: 1.1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected
                ? AppTheme.primaryPurple.withValues(alpha: 0.8)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLive) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.netflixRed,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
