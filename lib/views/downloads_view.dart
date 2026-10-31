import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/content_item.dart';
import '../viewmodels/download_viewmodel.dart';
import '../viewmodels/app_providers.dart';
import '../presentation/widgets/common/empty_state_view.dart';
import '../widgets/tv_focusable.dart';

class DownloadsView extends ConsumerWidget {
  final Function(ContentItem) onPlayItem;
  final bool isTV;

  const DownloadsView({
    super.key,
    required this.onPlayItem,
    this.isTV = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadVm = ref.watch(downloadProvider);
    final downloads = downloadVm.downloads;

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
              Text(
                'Offline Downloads (${downloads.length})',
                style: GoogleFonts.outfit(
                  fontSize: isTV ? 30 : 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Smart Storage Meter Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Internal Device Storage',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${downloadVm.usedStorageGb.toStringAsFixed(1)} GB used of ${downloadVm.totalStorageGb.toStringAsFixed(0)} GB',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.accentCyan,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: downloadVm.storageRatio,
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryViolet),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Auto-Delete watched episodes is ON • Smart Wi-Fi Auto-Download is ON',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Downloads List
          if (downloads.isEmpty)
            const EmptyStateView(
              icon: Icons.cloud_download_outlined,
              title: 'No Offline Downloads',
              message:
                  'Download Indian movies and web series to watch offline on flights, trains, and low internet.',
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: downloads.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final d = downloads[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          d.posterUrl,
                          width: isTV ? 80 : 60,
                          height: isTV ? 110 : 85,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d.title,
                              style: GoogleFonts.outfit(
                                fontSize: isTV ? 17 : 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (d.hindiTitle.isNotEmpty)
                              Text(
                                d.hindiTitle,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: AppTheme.accentCyan,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              '${d.quality} • ${d.fileSize}',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Play Offline Button
                      TVFocusable(
                        onPressed: () {
                          final item = ref
                              .read(catalogueProvider)
                              .firstWhere((c) => c.id == d.contentId);
                          onPlayItem(item);
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: AppTheme.brandGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.play_arrow,
                                  color: Colors.white, size: 18),
                              SizedBox(width: 4),
                              Text('Play Offline',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent, size: 22),
                        onPressed: () => downloadVm.removeDownload(d.id),
                      ),
                    ],
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
