import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/content_item.dart';
import '../services/app_state.dart';
import '../presentation/widgets/common/format_badge.dart';
import 'tv_focusable.dart';

class HeroBanner extends StatelessWidget {
  final ContentItem item;
  final VoidCallback onPlay;
  final VoidCallback onMoreInfo;
  final bool isTV;

  const HeroBanner({
    super.key,
    required this.item,
    required this.onPlay,
    required this.onMoreInfo,
    this.isTV = true,
  });

  @override
  Widget build(BuildContext context) {
    final height = isTV ? 480.0 : 360.0;
    final appState = AppState();
    final inWatchlist = appState.isInWatchlist(item.id);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          // Cinematic Backdrop
          Positioned.fill(
            child: Image.network(
              item.backdropUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1B0B2E), Color(0xFF090A10)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                );
              },
            ),
          ),

          // Double Vignette Gradients (horizontal for TV text readability, vertical for seamless list blend)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.horizontalHeroGradient,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.heroGradient,
              ),
            ),
          ),

          // Content Information & Actions
          Positioned(
            left: isTV ? 48 : 20,
            bottom: isTV ? 40 : 20,
            right: isTV ? 300 : 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Series / Movie Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryPurple, AppTheme.accentCyan],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.isMovie ? 'FEATURED MOVIE' : 'EXCLUSIVE SERIES',
                    style: GoogleFonts.outfit(
                      fontSize: isTV ? 11 : 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Main Title
                Text(
                  item.title,
                  style: GoogleFonts.outfit(
                    fontSize: isTV ? 46 : 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        color: Colors.black,
                        blurRadius: 18,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Metadata Badges Row
                Wrap(
                  spacing: 10,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '${item.year}',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _buildDot(),
                    Text(
                      item.genres.take(2).join(', '),
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _buildDot(),
                    Text(
                      item.duration,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (item.is4K) const FormatBadge.fourK(),
                    if (item.isDolbyVision) const FormatBadge.dolbyVision(),
                    FormatBadge.imdb(item.rating),
                  ],
                ),
                const SizedBox(height: 12),

                // Synopsis
                Text(
                  item.description,
                  maxLines: isTV ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: isTV ? 15 : 13,
                    height: 1.4,
                    color: AppTheme.textSecondary,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Action Buttons Row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Play Now CTA
                    TVFocusable(
                      onPressed: onPlay,
                      borderRadius: BorderRadius.circular(10),
                      scaleFactor: 1.08,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTV ? 26 : 20,
                          vertical: isTV ? 13 : 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9333EA), Color(0xFFC084FC)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryPurple.withValues(alpha: 0.5),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.play_arrow_rounded,
                                color: Colors.white, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'Play Now',
                              style: GoogleFonts.outfit(
                                fontSize: isTV ? 16 : 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // More Info Button
                    TVFocusable(
                      onPressed: onMoreInfo,
                      borderRadius: BorderRadius.circular(10),
                      scaleFactor: 1.08,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTV ? 22 : 16,
                          vertical: isTV ? 13 : 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.info_outline,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'More Info',
                              style: GoogleFonts.outfit(
                                fontSize: isTV ? 16 : 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Quick Watchlist Button
                    TVFocusable(
                      onPressed: () => appState.toggleWatchlist(item.id),
                      borderRadius: BorderRadius.circular(10),
                      scaleFactor: 1.08,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: inWatchlist
                              ? AppTheme.primaryPurple.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: inWatchlist
                                ? AppTheme.primaryViolet
                                : Colors.white24,
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          inWatchlist ? Icons.check : Icons.add,
                          color: inWatchlist ? AppTheme.accentCyan : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: AppTheme.textMuted,
        shape: BoxShape.circle,
      ),
    );
  }
}
