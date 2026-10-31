import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/content_item.dart';
import '../viewmodels/app_providers.dart';
import '../viewmodels/download_viewmodel.dart';
import '../presentation/widgets/common/format_badge.dart';
import '../presentation/widgets/overlays/watch_party_dialog.dart';
import '../presentation/widgets/overlays/premiere_pass_sheet.dart';
import '../presentation/widgets/overlays/audio_master_dialog.dart';
import '../widgets/movie_card.dart';
import '../widgets/tv_focusable.dart';

class ContentDetailsScreen extends ConsumerStatefulWidget {
  final ContentItem item;
  final VoidCallback onBack;
  final VoidCallback onPlay;
  final Function(ContentItem) onSelectSimilar;
  final bool isTV;

  const ContentDetailsScreen({
    super.key,
    required this.item,
    required this.onBack,
    required this.onPlay,
    required this.onSelectSimilar,
    this.isTV = true,
  });

  @override
  ConsumerState<ContentDetailsScreen> createState() =>
      _ContentDetailsScreenState();
}

class _ContentDetailsScreenState extends ConsumerState<ContentDetailsScreen> {
  int _activeTabIndex = 0;
  final List<String> _tabs = ['About', 'Cast & Crew', 'Similar', 'Trailers'];

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(trProvider);
    final inWatchlist =
        ref.watch(watchlistProvider).contains(widget.item.id);
    final downloadVm = ref.watch(downloadProvider);
    final isDownloaded = downloadVm.isDownloaded(widget.item.id);
    final isTV = widget.isTV;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Cinematic Backdrop
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: isTV ? 520 : 360,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  widget.item.backdropUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppTheme.surfaceLight,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: AppTheme.horizontalHeroGradient,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppTheme.background.withValues(alpha: 0.8),
                        AppTheme.background,
                      ],
                      stops: const [0.0, 0.65, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTV ? 48 : 20,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  TVFocusable(
                    onPressed: widget.onBack,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.5),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  SizedBox(height: isTV ? 120 : 60),

                  // Hindi Subtitle if available
                  if (widget.item.hindiTitle.isNotEmpty)
                    Text(
                      widget.item.hindiTitle,
                      style: GoogleFonts.outfit(
                        fontSize: isTV ? 20 : 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accentCyan,
                        letterSpacing: 0.5,
                      ),
                    ),

                  // Title
                  Text(
                    widget.item.title,
                    style: GoogleFonts.outfit(
                      fontSize: isTV ? 48 : 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      shadows: [
                        const Shadow(
                          color: Colors.black,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Metadata Badges Row with FormatBadge component
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '${widget.item.year}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      _buildDot(),
                      Text(
                        widget.item.genres.join(', '),
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      _buildDot(),
                      Text(
                        widget.item.duration,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      if (widget.item.is4K) const FormatBadge.fourK(),
                      if (widget.item.isDolbyVision) const FormatBadge.dolbyVision(),
                      if (widget.item.isDolbyAtmos) const FormatBadge.dolbyAtmos(),
                      FormatBadge.custom(widget.item.maturityRating),
                      FormatBadge.imdb(widget.item.rating),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Synopsis
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isTV ? 780 : double.infinity),
                    child: Text(
                      widget.item.description,
                      style: GoogleFonts.outfit(
                        fontSize: isTV ? 16 : 14,
                        height: 1.5,
                        color: Colors.white.withValues(alpha: 0.88),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons Row
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      // Play Now Button
                      TVFocusable(
                        autoFocus: true,
                        onPressed: widget.onPlay,
                        borderRadius: BorderRadius.circular(10),
                        scaleFactor: 1.08,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTV ? 28 : 22,
                            vertical: isTV ? 14 : 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9333EA), Color(0xFFC084FC)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryPurple
                                    .withValues(alpha: 0.5),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.play_arrow_rounded,
                                  color: Colors.white, size: 26),
                              const SizedBox(width: 8),
                              Text(
                                tr('play_now'),
                                style: GoogleFonts.outfit(
                                  fontSize: isTV ? 16 : 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Watch Trailer
                      TVFocusable(
                        onPressed: widget.onPlay,
                        borderRadius: BorderRadius.circular(10),
                        scaleFactor: 1.08,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTV ? 22 : 18,
                            vertical: isTV ? 14 : 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.movie_outlined,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                tr('watch_trailer'),
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

                      // Add to My List
                      TVFocusable(
                        onPressed: () {
                          ref.read(watchlistProvider).toggle(widget.item.id);
                        },
                        borderRadius: BorderRadius.circular(10),
                        scaleFactor: 1.08,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTV ? 20 : 16,
                            vertical: isTV ? 14 : 12,
                          ),
                          decoration: BoxDecoration(
                            color: inWatchlist
                                ? AppTheme.primaryPurple.withValues(alpha: 0.25)
                                : Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: inWatchlist
                                  ? AppTheme.primaryViolet
                                  : Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                inWatchlist ? Icons.check : Icons.add,
                                color: inWatchlist
                                    ? AppTheme.accentCyan
                                    : Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                inWatchlist ? tr('in_my_list') : tr('add_to_list'),
                                style: GoogleFonts.outfit(
                                  fontSize: isTV ? 15 : 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Watch Party
                      TVFocusable(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => WatchPartyDialog(
                              contentId: widget.item.id,
                              contentTitle: widget.item.title,
                              isTV: isTV,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        scaleFactor: 1.08,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTV ? 20 : 16,
                            vertical: isTV ? 14 : 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppTheme.accentCyan.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.group_work_rounded,
                                  color: AppTheme.accentCyan, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                tr('watch_party'),
                                style: GoogleFonts.outfit(
                                  fontSize: isTV ? 15 : 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Smart Offline Download
                      TVFocusable(
                        onPressed: () {
                          if (!isDownloaded) {
                            ref
                                .read(downloadProvider)
                                .downloadContent(widget.item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Saved "${widget.item.title}" for offline playback!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        scaleFactor: 1.08,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTV ? 20 : 16,
                            vertical: isTV ? 14 : 12,
                          ),
                          decoration: BoxDecoration(
                            color: isDownloaded
                                ? AppTheme.accentCyan.withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDownloaded
                                  ? AppTheme.accentCyan
                                  : Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isDownloaded
                                    ? Icons.download_done_rounded
                                    : Icons.download_for_offline_outlined,
                                color: isDownloaded
                                    ? AppTheme.accentCyan
                                    : Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isDownloaded
                                    ? tr('downloaded')
                                    : tr('download_offline'),
                                style: GoogleFonts.outfit(
                                  fontSize: isTV ? 15 : 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Theatrical Pass (if Premiere)
                      if (widget.item.isPremiere)
                        TVFocusable(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => PremierePassSheet(
                                item: widget.item,
                                isTV: isTV,
                                onUnlocked: () {
                                  Navigator.pop(ctx);
                                  widget.onPlay();
                                },
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          scaleFactor: 1.08,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTV ? 20 : 16,
                              vertical: isTV ? 14 : 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFF59E0B)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.confirmation_number_rounded,
                                    color: Colors.black, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  tr('premiere_pass'),
                                  style: GoogleFonts.outfit(
                                    fontSize: isTV ? 14 : 12,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Master Audio
                      TVFocusable(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AudioMasterDialog(isTV: isTV),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        scaleFactor: 1.08,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTV ? 18 : 14,
                            vertical: isTV ? 14 : 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.tune_rounded,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                'MASTER AUDIO',
                                style: GoogleFonts.outfit(
                                  fontSize: isTV ? 14 : 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // Section Tabs
                  Row(
                    children: List.generate(_tabs.length, (idx) {
                      final isSelected = _activeTabIndex == idx;
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: TVFocusable(
                          onPressed: () => setState(() => _activeTabIndex = idx),
                          borderRadius: BorderRadius.circular(6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _tabs[idx],
                                style: GoogleFonts.outfit(
                                  fontSize: isTV ? 17 : 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.textMuted,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: isSelected ? 30 : 0,
                                height: 3,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.brandGradient,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  _buildTabContent(isTV),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(bool isTV) {
    switch (_activeTabIndex) {
      case 0: // About
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Director', widget.item.director),
              const Divider(color: Colors.white10),
              _buildInfoRow('Starring Cast', widget.item.cast.join(', ')),
              const Divider(color: Colors.white10),
              _buildInfoRow('Audio Languages', widget.item.audioLanguages.join(', ')),
              const Divider(color: Colors.white10),
              _buildInfoRow('Subtitles', widget.item.subtitleLanguages.join(', ')),
              const Divider(color: Colors.white10),
              _buildInfoRow('Maturity Rating', widget.item.maturityRating),
            ],
          ),
        );

      case 1: // Cast & Crew
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: widget.item.cast.map((actor) {
            return Container(
              width: isTV ? 160 : 130,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: isTV ? 32 : 24,
                    backgroundColor: AppTheme.primaryPurple.withValues(alpha: 0.3),
                    child: Text(
                      actor.isNotEmpty ? actor[0] : 'A',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    actor,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );

      case 2: // Similar Titles
        final similar = ref
            .watch(catalogueProvider)
            .where((c) => c.id != widget.item.id)
            .take(6)
            .toList();

        return SizedBox(
          height: isTV ? 230 : 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: similar.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final sim = similar[index];
              return MovieCard(
                item: sim,
                onTap: () => widget.onSelectSimilar(sim),
                width: isTV ? 140 : 110,
                height: isTV ? 210 : 165,
              );
            },
          ),
        );

      case 3: // Trailers & Clips
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 140,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black45,
                ),
                child: const Center(
                  child: Icon(Icons.play_circle_fill,
                      color: AppTheme.accentCyan, size: 36),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Official Trailer 1 (4K Dolby Atmos)',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Duration: 2m 45s • 4K Ultra HD • 7.1 Surround',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppTheme.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
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
