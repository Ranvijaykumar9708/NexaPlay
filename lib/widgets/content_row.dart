import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/content_item.dart';
import 'movie_card.dart';

class ContentRow extends StatelessWidget {
  final String title;
  final List<ContentItem> items;
  final Function(ContentItem) onItemTap;
  final bool showProgress;
  final bool isFeaturedLandscape;
  final bool isTV;

  const ContentRow({
    super.key,
    required this.title,
    required this.items,
    required this.onItemTap,
    this.showProgress = false,
    this.isFeaturedLandscape = false,
    this.isTV = true,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final cardWidth = isTV ? (isFeaturedLandscape ? 280.0 : 170.0) : (isFeaturedLandscape ? 220.0 : 130.0);
    final cardHeight = isTV ? (isFeaturedLandscape ? 175.0 : 255.0) : (isFeaturedLandscape ? 140.0 : 195.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row Title
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTV ? 48 : 20,
            vertical: 10,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: isTV ? 20 : 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),

        // Horizontal Card Carousel
        SizedBox(
          height: cardHeight + 20, // headroom for scale animation
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: isTV ? 48 : 20,
              vertical: 8,
            ),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: isTV ? 16 : 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return MovieCard(
                item: item,
                onTap: () => onItemTap(item),
                width: cardWidth,
                height: cardHeight,
                showProgress: showProgress,
                isFeaturedLandscape: isFeaturedLandscape,
              );
            },
          ),
        ),
      ],
    );
  }
}
