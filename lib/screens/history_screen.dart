import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/content_item.dart';
import '../services/app_state.dart';
import '../widgets/movie_card.dart';
import '../widgets/tv_focusable.dart';

class HistoryScreen extends StatefulWidget {
  final Function(ContentItem) onResume;
  final bool isTV;

  const HistoryScreen({
    super.key,
    required this.onResume,
    this.isTV = true,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final items = appState.continueWatchingItems;
    final accessible = appState.accessibleContent;
    final isTV = widget.isTV;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isTV ? 48 : 20,
        vertical: 24,
      ),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Continue Watching',
                style: GoogleFonts.outfit(
                  fontSize: isTV ? 30 : 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              if (items.isNotEmpty)
                TVFocusable(
                  onPressed: () {
                    for (final item in List.from(items)) {
                      appState.removeContinueWatching(item.id);
                    }
                    setState(() {});
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Clear History',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          if (items.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: Text(
                'No content in progress. Start watching any movie or show!',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                ),
              ),
            )
          else
            SizedBox(
              height: isTV ? 210 : 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return MovieCard(
                    item: item,
                    onTap: () => widget.onResume(item),
                    width: isTV ? 280 : 200,
                    height: isTV ? 190 : 140,
                    showProgress: true,
                    isFeaturedLandscape: true,
                  );
                },
              ),
            ),
          const SizedBox(height: 36),

          Text(
            'Recently Watched',
            style: GoogleFonts.outfit(
              fontSize: isTV ? 24 : 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: accessible.take(4).length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.white10),
            itemBuilder: (context, index) {
              final item = accessible[index];
              return TVFocusable(
                onPressed: () => widget.onResume(item),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          item.backdropUrl,
                          width: isTV ? 120 : 80,
                          height: isTV ? 68 : 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: GoogleFonts.outfit(
                                fontSize: isTV ? 16 : 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Watched 2 days ago • ${item.duration}',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.play_circle_outline,
                          color: AppTheme.accentCyan, size: 28),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
