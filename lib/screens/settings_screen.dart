import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';
import '../widgets/tv_focusable.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final VoidCallback onBack;
  final bool isTV;

  const SettingsScreen({
    super.key,
    required this.onLogout,
    required this.onBack,
    this.isTV = true,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedCategoryIndex = 2; // Default to "Audio & Subtitles" matching screenshot

  final List<Map<String, dynamic>> _categories = [
    {'title': 'Account', 'icon': Icons.person_outline},
    {'title': 'Playback', 'icon': Icons.play_circle_outline},
    {'title': 'Audio & Subtitles', 'icon': Icons.closed_caption_outlined},
    {'title': 'Parental Control', 'icon': Icons.lock_outline},
    {'title': 'App Settings', 'icon': Icons.tune_outlined},
    {'title': 'Help & Support', 'icon': Icons.help_outline},
  ];

  @override
  Widget build(BuildContext context) {
    final isTV = widget.isTV;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Navigation Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTV ? 48 : 20,
                vertical: 16,
              ),
              child: Row(
                children: [
                  TVFocusable(
                    onPressed: widget.onBack,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white12,
                      ),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Settings & Preferences',
                    style: GoogleFonts.outfit(
                      fontSize: isTV ? 26 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white10),

            // Dual Pane Body
            Expanded(
              child: isTV ? _buildDualPaneTV() : _buildMobileSettings(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDualPaneTV() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Sidebar Navigation
        SizedBox(
          width: 300,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
            itemCount: _categories.length + 1,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              if (index == _categories.length) {
                // Logout Item
                return TVFocusable(
                  onPressed: widget.onLogout,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.logout,
                            color: Colors.redAccent, size: 20),
                        const SizedBox(width: 14),
                        Text(
                          'Sign Out',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final cat = _categories[index];
              final isSelected = _selectedCategoryIndex == index;

              return TVFocusable(
                onPressed: () =>
                    setState(() => _selectedCategoryIndex = index),
                borderRadius: BorderRadius.circular(10),
                scaleFactor: 1.05,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryPurple.withValues(alpha: 0.8)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        cat['icon'] as IconData,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        cat['title'] as String,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const VerticalDivider(color: Colors.white10),

        // Right Detail Pane
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
            child: _buildCategoryDetail(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryDetail(),
          const SizedBox(height: 36),
          TVFocusable(
            onPressed: widget.onLogout,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Text(
                  'Sign Out of NexaPlay',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDetail() {
    final appState = AppState();

    switch (_selectedCategoryIndex) {
      case 0: // Account
        final profile = appState.currentProfile;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account Information',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildSettingCard(
              title: 'Active Profile',
              subtitle: '${profile?.name} (${profile?.isKids == true ? 'Kids' : 'Adult'})',
              icon: Icons.person,
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              title: 'Subscription Plan',
              subtitle: 'NexaPlay Premium 4K UHD (Active)',
              icon: Icons.stars,
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              title: 'Linked Devices',
              subtitle: 'Android TV, Living Room Apple TV, iPhone 15',
              icon: Icons.devices,
            ),
          ],
        );

      case 1: // Playback
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Playback Quality',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...['Auto (Best available)', '720p HD', '1080p Full HD', '4K Ultra HD'].map((q) {
              final val = q.split(' ')[0];
              final isSelected = appState.videoQuality == val;
              return TVFocusable(
                onPressed: () => appState.setVideoQuality(val),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryPurple.withValues(alpha: 0.25)
                        : AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryViolet : Colors.white12,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? AppTheme.accentCyan : Colors.white38,
                      ),
                      const SizedBox(width: 14),
                      Text(q,
                          style: GoogleFonts.outfit(
                              fontSize: 15,
                              color: isSelected ? Colors.white : AppTheme.textSecondary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeThumbColor: AppTheme.primaryViolet,
              title: Text('Autoplay Next Episode',
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600)),
              subtitle: Text('Automatically stream the next episode of a series',
                  style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.textMuted)),
              value: appState.autoplayNext,
              onChanged: (val) => appState.setAutoplayNext(val),
            ),
          ],
        );

      case 2: // Audio & Subtitles (Matching screenshot 14)
        final audioLangs = ['English', 'Hindi', 'Tamil', 'Telugu', 'Spanish'];
        final subLangs = ['Off', 'English', 'Hindi'];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Audio Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Audio Language',
                      style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 14),
                  ...audioLangs.map((lang) {
                    final isSelected = appState.audioLanguage == lang;
                    return TVFocusable(
                      onPressed: () => appState.setAudioLanguage(lang),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryPurple.withValues(alpha: 0.25)
                              : AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryViolet : Colors.white12,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(lang,
                                style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.white : AppTheme.textSecondary)),
                            if (isSelected)
                              const Icon(Icons.check, color: AppTheme.accentCyan, size: 18),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: 32),

            // Subtitle Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subtitles',
                      style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 14),
                  ...subLangs.map((sub) {
                    final isSelected = appState.subtitleLanguage == sub;
                    return TVFocusable(
                      onPressed: () => appState.setSubtitleLanguage(sub),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryPurple.withValues(alpha: 0.25)
                              : AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryViolet : Colors.white12,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(sub,
                                style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.white : AppTheme.textSecondary)),
                            if (isSelected)
                              const Icon(Icons.check, color: AppTheme.accentCyan, size: 18),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        );

      case 3: // Parental Control
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Parental Controls & PIN Protection',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildSettingCard(
              title: 'Kids Profile Protection',
              subtitle: 'Restricts content to U/A 13+ and age-appropriate media only.',
              icon: Icons.shield_outlined,
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              title: 'Parent Gate PIN',
              subtitle: 'PIN is set to **** (Enabled)',
              icon: Icons.pin_outlined,
            ),
          ],
        );

      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NexaPlay Information',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildSettingCard(
              title: 'Build Version',
              subtitle: 'v1.0.0 (Production Release • Android TV & Mobile)',
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              title: 'Smart TV Optimization',
              subtitle: 'Hardware acceleration enabled, 4K HDR enabled',
              icon: Icons.speed,
            ),
          ],
        );
    }
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryViolet, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.outfit(
                        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
