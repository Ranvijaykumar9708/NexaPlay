import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

enum BadgeType {
  fourK,
  dolbyVision,
  dolbyAtmos,
  hdr,
  imdb,
  top10,
  live,
  custom,
}

class FormatBadge extends StatelessWidget {
  final BadgeType type;
  final String? customText;
  final double? ratingValue;

  const FormatBadge.fourK({super.key})
      : type = BadgeType.fourK,
        customText = '4K UHD',
        ratingValue = null;

  const FormatBadge.dolbyVision({super.key})
      : type = BadgeType.dolbyVision,
        customText = 'VISION',
        ratingValue = null;

  const FormatBadge.dolbyAtmos({super.key})
      : type = BadgeType.dolbyAtmos,
        customText = 'ATMOS 7.1',
        ratingValue = null;

  const FormatBadge.hdr({super.key})
      : type = BadgeType.hdr,
        customText = 'HDR10+',
        ratingValue = null;

  const FormatBadge.top10({super.key})
      : type = BadgeType.top10,
        customText = 'TOP 10',
        ratingValue = null;

  const FormatBadge.live({super.key})
      : type = BadgeType.live,
        customText = 'LIVE',
        ratingValue = null;

  const FormatBadge.imdb(double rating, {super.key})
      : type = BadgeType.imdb,
        customText = null,
        ratingValue = rating;

  const FormatBadge.custom(String text, {super.key})
      : type = BadgeType.custom,
        customText = text,
        ratingValue = null;

  @override
  Widget build(BuildContext context) {
    if (type == BadgeType.imdb) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppTheme.imdbGold,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'IMDb',
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              (ratingValue ?? 0.0).toStringAsFixed(1),
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    if (type == BadgeType.top10 || type == BadgeType.live) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppTheme.netflixRed,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          customText ?? '',
          style: GoogleFonts.outfit(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      );
    }

    // Default 4K / Dolby / Custom styling
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white24, width: 0.8),
      ),
      child: Text(
        customText ?? '',
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: type == BadgeType.fourK || type == BadgeType.dolbyVision
              ? AppTheme.accentCyan
              : Colors.white70,
        ),
      ),
    );
  }
}
