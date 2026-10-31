import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/content_item.dart';
import '../viewmodels/app_providers.dart';
import '../presentation/widgets/common/empty_state_view.dart';
import '../widgets/movie_card.dart';
import '../widgets/tv_focusable.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  final bool filterMoviesOnly;
  final bool filterSeriesOnly;
  final bool filterKidsOnly;
  final Function(ContentItem) onItemSelect;
  final bool isTV;

  const BrowseScreen({
    super.key,
    this.filterMoviesOnly = false,
    this.filterSeriesOnly = false,
    this.filterKidsOnly = false,
    required this.onItemSelect,
    this.isTV = true,
  });

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  String _selectedGenre = 'All';

  final List<String> _genres = [
    'All',
    'Action',
    'Drama',
    'Sci-Fi',
    'Thriller',
    'Comedy',
    'Biography',
    'Crime',
    'Kids',
  ];

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(trProvider);
    var list = ref.watch(catalogueProvider);

    if (widget.filterKidsOnly) {
      list = list.where((c) => c.isKidsFriendly).toList();
    } else if (widget.filterMoviesOnly) {
      list = list.where((c) => c.isMovie).toList();
    } else if (widget.filterSeriesOnly) {
      list = list.where((c) => !c.isMovie).toList();
    }

    if (_selectedGenre != 'All') {
      list = list.where((c) => c.genres.contains(_selectedGenre)).toList();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = widget.isTV
        ? (screenWidth > 1200 ? 6 : (screenWidth > 900 ? 5 : 4))
        : (screenWidth > 500 ? 3 : 2);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isTV ? 48 : 20,
        vertical: 24,
      ),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Screen Title
          Text(
            widget.filterKidsOnly
                ? tr('kids_corner')
                : (widget.filterMoviesOnly
                    ? tr('movies')
                    : (widget.filterSeriesOnly
                        ? tr('series')
                        : 'Explore All Cinema')),
            style: GoogleFonts.outfit(
              fontSize: widget.isTV ? 30 : 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Genre Filter Chips Horizontal Bar
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _genres.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final genre = _genres[index];
                final isSelected = _selectedGenre == genre;

                return TVFocusable(
                  onPressed: () => setState(() => _selectedGenre = genre),
                  borderRadius: BorderRadius.circular(20),
                  scaleFactor: 1.08,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: isSelected ? AppTheme.brandGradient : null,
                      color: isSelected ? null : AppTheme.surfaceLight,
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        genre,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),

          // Content Grid or Empty State
          if (list.isEmpty)
            EmptyStateView(
              icon: Icons.movie_filter_outlined,
              title: 'No titles found in $_selectedGenre',
              message: 'Try switching to another category or check back soon.',
              buttonText: 'Show All Categories',
              onButtonPressed: () => setState(() => _selectedGenre = 'All'),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: widget.isTV ? 16 : 12,
                mainAxisSpacing: widget.isTV ? 20 : 16,
                childAspectRatio: 0.65,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return MovieCard(
                  item: item,
                  onTap: () => widget.onItemSelect(item),
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
