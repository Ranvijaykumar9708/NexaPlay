import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/content_item.dart';
import '../data/mock_data.dart';
import '../viewmodels/app_providers.dart';
import '../widgets/live_channel_card.dart';
import '../widgets/tv_focusable.dart';

class LiveTvView extends ConsumerWidget {
  final Function(ContentItem) onPlayChannel;
  final bool isTV;

  const LiveTvView({
    super.key,
    required this.onPlayChannel,
    this.isTV = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(trProvider);
    final selectedChannel = ref.watch(liveTvProvider).selectedChannel;
    final channels = MockData.liveChannels;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isTV ? 48 : 20,
        vertical: 24,
      ),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.netflixRed,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'LIVE',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        tr('live_channels'),
                        style: GoogleFonts.outfit(
                          fontSize: isTV ? 28 : 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'High definition 24x7 Indian television with electronic program guide',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Featured Live Channel Hero Player Card
          Container(
            height: isTV ? 320 : 220,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppTheme.cardColor,
              border: Border.all(color: Colors.white12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  selectedChannel.logoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: AppTheme.surfaceLight),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.85),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // Channel Info & Play CTA
                Positioned(
                  left: isTV ? 32 : 16,
                  bottom: isTV ? 28 : 16,
                  right: isTV ? 32 : 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryPurple,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                selectedChannel.category.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              selectedChannel.name,
                              style: GoogleFonts.outfit(
                                fontSize: isTV ? 28 : 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Now: ${selectedChannel.currentShow} (${selectedChannel.currentShowTime})',
                              style: GoogleFonts.outfit(
                                fontSize: isTV ? 15 : 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.accentCyan,
                              ),
                            ),
                            Text(
                              'Upcoming: ${selectedChannel.nextShow} at ${selectedChannel.nextShowTime}',
                              style: GoogleFonts.outfit(
                                fontSize: isTV ? 13 : 11,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Watch Live Button
                      TVFocusable(
                        autoFocus: true,
                        onPressed: () {
                          // Adapt channel to ContentItem for player
                          final item = ContentItem(
                            id: selectedChannel.id,
                            title: '${selectedChannel.name} - ${selectedChannel.currentShow}',
                            description: 'Live Broadcast: ${selectedChannel.currentShow}',
                            posterUrl: selectedChannel.logoUrl,
                            backdropUrl: selectedChannel.logoUrl,
                            rating: 9.2,
                            year: 2026,
                            duration: 'LIVE',
                            genres: [selectedChannel.category, 'Live TV'],
                            streamUrl: selectedChannel.streamUrl,
                            cast: ['Live Anchors', 'Commentary Team'],
                            director: selectedChannel.name,
                            maturityRating: 'U (All Ages)',
                            is4K: selectedChannel.isHD,
                          );
                          onPlayChannel(item);
                        },
                        borderRadius: BorderRadius.circular(10),
                        scaleFactor: 1.08,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTV ? 24 : 16,
                            vertical: isTV ? 12 : 10,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE50914), Color(0xFFFF5252)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.netflixRed.withValues(alpha: 0.5),
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
                                'Watch Live',
                                style: GoogleFonts.outfit(
                                  fontSize: isTV ? 15 : 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Channel Schedule Grid
          Text(
            'All Channels & Schedules',
            style: GoogleFonts.outfit(
              fontSize: isTV ? 20 : 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: channels.map((ch) {
              return LiveChannelCard(
                channel: ch,
                isTV: isTV,
                onTap: () {
                  ref.read(liveTvProvider).selectChannel(ch);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
