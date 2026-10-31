import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/profile.dart';
import '../viewmodels/app_providers.dart';
import '../widgets/nexaplay_logo.dart';
import '../widgets/tv_focusable.dart';
import '../presentation/widgets/overlays/parental_pin_dialog.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final VoidCallback onProfileChosen;

  const ProfileScreen({super.key, required this.onProfileChosen});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isManaging = false;

  void _chooseProfile(UserProfile profile) {
    final currentProfile = ref.read(profileViewModelProvider).currentProfile;

    // If currently on Kids profile and trying to switch to Adult profile, enforce PIN gate
    if (currentProfile.isKids && !profile.isKids) {
      showDialog(
        context: context,
        builder: (ctx) => ParentalPinDialog(
          isTV: MediaQuery.of(context).size.width > 700,
          onVerified: (success) {
            if (success) {
              ref.read(profileViewModelProvider).selectProfile(profile);
              widget.onProfileChosen();
            }
          },
        ),
      );
      return;
    }

    ref.read(profileViewModelProvider).selectProfile(profile);
    widget.onProfileChosen();
  }

  void _showAddProfileDialog() {
    final nameController = TextEditingController();
    bool isKids = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Add New Profile',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Profile Name (e.g. Aryan)',
                  labelStyle: const TextStyle(color: AppTheme.textSecondary),
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.primaryViolet,
                title: Text(
                  'Kids Profile (Safe Content Only)',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                value: isKids,
                onChanged: (val) {
                  setDialogState(() => isKids = val ?? false);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
            ),
            TVFocusable(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  final newProfile = UserProfile(
                    id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameController.text.trim(),
                    avatarColor: isKids ? '0xFF06B6D4' : '0xFF8B5CF6',
                    avatarIcon: isKids ? 'child_care' : 'person',
                    isKids: isKids,
                  );
                  ref.read(profileViewModelProvider).addProfile(newProfile);
                  Navigator.pop(ctx);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppTheme.brandGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Create Profile',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTV = size.width > 700;
    final tr = ref.watch(trProvider);
    final profileVm = ref.watch(profileViewModelProvider);
    final profiles = profileVm.profiles;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Ambient Radial Light
          Positioned(
            top: -150,
            left: size.width * 0.3,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryPurple.withValues(alpha: 0.22),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Central Profile Selector
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const NexaPlayLogo(size: 40, fontSize: 24),
                  const SizedBox(height: 28),
                  Text(
                    tr('who_is_watching'),
                    style: GoogleFonts.outfit(
                      fontSize: isTV ? 38 : 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Profiles Row / Wrap
                  Wrap(
                    spacing: isTV ? 32 : 18,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      ...profiles.map((p) => _buildProfileCard(p, isTV)),
                      _buildAddProfileCard(isTV),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Manage Profiles Button
                  TVFocusable(
                    onPressed: () => setState(() => _isManaging = !_isManaging),
                    borderRadius: BorderRadius.circular(8),
                    scaleFactor: 1.08,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isManaging
                              ? AppTheme.primaryViolet
                              : Colors.white24,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: _isManaging
                            ? AppTheme.primaryPurple.withValues(alpha: 0.2)
                            : Colors.transparent,
                      ),
                      child: Text(
                        _isManaging ? 'Done Managing' : tr('manage_profiles'),
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _isManaging ? Colors.white : AppTheme.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(UserProfile profile, bool isTV) {
    final avatarSize = isTV ? 110.0 : 85.0;
    final color = Color(int.parse(profile.avatarColor));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TVFocusable(
          onPressed: () => _chooseProfile(profile),
          borderRadius: BorderRadius.circular(16),
          scaleFactor: 1.12,
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    profile.isKids ? Icons.child_care : Icons.person,
                    size: avatarSize * 0.55,
                    color: Colors.white,
                  ),
                ),
                if (profile.isKids)
                  Positioned(
                    bottom: 6,
                    left: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'KIDS',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.accentCyan,
                        ),
                      ),
                    ),
                  ),
                if (_isManaging && ref.read(profileViewModelProvider).profiles.length > 1)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(profileViewModelProvider).deleteProfile(profile.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          profile.name,
          style: GoogleFonts.outfit(
            fontSize: isTV ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAddProfileCard(bool isTV) {
    final avatarSize = isTV ? 110.0 : 85.0;
    final tr = ref.watch(trProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TVFocusable(
          onPressed: _showAddProfileDialog,
          borderRadius: BorderRadius.circular(16),
          scaleFactor: 1.12,
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppTheme.surfaceLight,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: const Center(
              child: Icon(Icons.add, size: 38, color: Colors.white70),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          tr('add_profile'),
          style: GoogleFonts.outfit(
            fontSize: isTV ? 16 : 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
