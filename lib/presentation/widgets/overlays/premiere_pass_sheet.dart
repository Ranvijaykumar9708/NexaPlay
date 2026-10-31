import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../models/content_item.dart';
import '../../../widgets/tv_focusable.dart';

class PremierePassSheet extends StatelessWidget {
  final ContentItem item;
  final VoidCallback onUnlocked;
  final bool isTV;

  const PremierePassSheet({
    super.key,
    required this.item,
    required this.onUnlocked,
    this.isTV = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: isTV ? 520 : 360),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF2E1C03), Color(0xFF100A02)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: AppTheme.imdbGold, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppTheme.imdbGold.withValues(alpha: 0.3),
              blurRadius: 30,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ticket Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.imdbGold,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'EARLY THEATRICAL PREMIERE',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Direct from Theaters into your Living Room',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),

              // Golden Ticket Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Rental Window',
                            style: GoogleFonts.outfit(
                                fontSize: 13, color: AppTheme.textMuted)),
                        Text('48 Hours from First Play',
                            style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                    const Divider(color: Colors.white12, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Streaming Format',
                            style: GoogleFonts.outfit(
                                fontSize: 13, color: AppTheme.textMuted)),
                        Text('4K Dolby Vision + Atmos',
                            style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentCyan)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Rental Price Button
              TVFocusable(
                autoFocus: true,
                onPressed: () {
                  Navigator.pop(context);
                  onUnlocked();
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
                  ),
                  child: Center(
                    child: Text(
                      'Rent Now for ₹299 (Golden Ticket)',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Watch Trailer Free',
                    style: GoogleFonts.outfit(color: Colors.white60)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
