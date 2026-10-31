import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../viewmodels/app_providers.dart';
import 'tv_focusable.dart';

class VipPassSheet extends ConsumerWidget {
  final VoidCallback onClose;
  final bool isTV;

  const VipPassSheet({
    super.key,
    required this.onClose,
    this.isTV = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(trProvider);
    final vipState = ref.watch(vipProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isTV ? 40 : 16),
      child: Container(
        constraints: BoxConstraints(maxWidth: isTV ? 680 : double.infinity),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF200B3B), Color(0xFF0C0A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(
            color: const Color(0xFFF5C518).withValues(alpha: 0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF5C518).withValues(alpha: 0.25),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // VIP Crown & Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.imdbGold.withValues(alpha: 0.2),
                        ),
                        child: const Icon(Icons.workspace_premium,
                            color: AppTheme.imdbGold, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NEXAPLAY GOLD VIP',
                            style: GoogleFonts.outfit(
                              fontSize: isTV ? 22 : 18,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.imdbGold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            tr('app_tagline'),
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TVFocusable(
                    onPressed: onClose,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white12,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 28),

              // Benefits Grid
              _buildBenefitRow(
                Icons.hd,
                '4K Ultra HD + Dolby Vision',
                'Experience true cinematic brilliance with breathtaking color and contrast.',
              ),
              const SizedBox(height: 14),
              _buildBenefitRow(
                Icons.surround_sound,
                'Dolby Atmos 7.1 Spatial Audio',
                'Next-level multidimensional sound engineered for TV soundbars and earphones.',
              ),
              const SizedBox(height: 14),
              _buildBenefitRow(
                Icons.tv,
                '4 Screens Simultaneously',
                'Watch across Android TV, Google TV, Mobile, and Web simultaneously.',
              ),
              const SizedBox(height: 14),
              _buildBenefitRow(
                Icons.block,
                '100% Ad-Free Streaming + Early Access',
                'Enjoy uncompromised cinema with zero commercial interruptions.',
              ),
              const SizedBox(height: 24),

              // Plan Cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        children: [
                          Text('Monthly',
                              style: GoogleFonts.outfit(
                                  fontSize: 14, color: AppTheme.textSecondary)),
                          const SizedBox(height: 4),
                          Text('₹149',
                              style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const SizedBox(height: 2),
                          Text('per month',
                              style: GoogleFonts.outfit(
                                  fontSize: 11, color: AppTheme.textMuted)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B1578), Color(0xFF6B21A8)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppTheme.imdbGold, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.imdbGold,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'BEST VALUE - SAVE 45%',
                              style: GoogleFonts.outfit(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('Annual 4K Pass',
                              style: GoogleFonts.outfit(
                                  fontSize: 14, color: Colors.white70)),
                          Text('₹999',
                              style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.imdbGold)),
                          Text('billed annually',
                              style: GoogleFonts.outfit(
                                  fontSize: 11, color: Colors.white60)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // CTA Button
              TVFocusable(
                autoFocus: true,
                onPressed: () {
                  ref.read(vipProvider.notifier).upgradeToUltra();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🎉 NexaPlay Gold VIP Activated! 4K Dolby Atmos Enabled.'),
                      backgroundColor: Color(0xFF6B21A8),
                    ),
                  );
                  onClose();
                },
                borderRadius: BorderRadius.circular(12),
                scaleFactor: 1.05,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF5C518), Color(0xFFD97706)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF5C518).withValues(alpha: 0.5),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      vipState.isVip ? 'Renew / Manage VIP Pass' : 'Subscribe to NexaPlay Gold (₹999/yr)',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.accentCyan, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
