import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/content_item.dart';
import '../services/app_state.dart';
import '../presentation/widgets/common/format_badge.dart';
import 'tv_focusable.dart';

class MovieCard extends StatelessWidget {
  final ContentItem item;
  final VoidCallback onTap;
  final double width;
  final double height;
  final bool showProgress;
  final bool isFeaturedLandscape;

  const MovieCard({
    super.key,
    required this.item,
    required this.onTap,
    this.width = 160,
    this.height = 240,
    this.showProgress = false,
    this.isFeaturedLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final progressRecord = appState.getPlaybackProgress(item.id);

    return TVFocusable(
      onPressed: onTap,
      scaleFactor: 1.08,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: isFeaturedLandscape ? width * 1.55 : width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Poster / Backdrop Image with Graceful Gradient Fallback
            Positioned.fill(
              child: Image.network(
                isFeaturedLandscape ? item.backdropUrl : item.posterUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.surfaceLight,
                          AppTheme.primaryPurple.withValues(alpha: 0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.movie_creation_outlined,
                              color: Colors.white54, size: 36),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppTheme.surfaceLight,
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(AppTheme.primaryPurple),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Subtle Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Top Badges (4K / Top 10)
            Positioned(
              top: 8,
              left: 8,
              child: Row(
                children: [
                  if (item.isTrending) const FormatBadge.top10(),
                  if (item.isTrending && item.is4K) const SizedBox(width: 4),
                  if (item.is4K) const FormatBadge.fourK(),
                ],
              ),
            ),

            // Bottom Content Information
            Positioned(
              left: 8,
              right: 8,
              bottom: (showProgress && progressRecord != null) ? 14 : 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppTheme.imdbGold, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        item.rating.toStringAsFixed(1),
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.imdbGold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.duration,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Continue Watching Progress Bar
            if (showProgress && progressRecord != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            progressRecord.timeLeftFormatted,
                            style: GoogleFonts.outfit(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accentCyan,
                            ),
                          ),
                          const Icon(Icons.play_circle_fill,
                              color: Colors.white, size: 12),
                        ],
                      ),
                    ),
                    Container(
                      height: 3.5,
                      width: double.infinity,
                      color: Colors.white12,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progressRecord.progressRatio,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.primaryPurple, AppTheme.accentCyan],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
