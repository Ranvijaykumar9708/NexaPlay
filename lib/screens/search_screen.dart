import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/content_item.dart';
import '../data/mock_data.dart';
import '../viewmodels/app_providers.dart';
import '../presentation/widgets/inputs/tv_virtual_keyboard.dart';
import '../presentation/widgets/common/empty_state_view.dart';
import '../widgets/movie_card.dart';
import '../widgets/tv_focusable.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final Function(ContentItem) onItemSelect;
  final bool isTV;

  const SearchScreen({
    super.key,
    required this.onItemSelect,
    this.isTV = true,
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  final List<String> _recentSearches = List.from(MockData.recentSearches);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onKeypadPress(String key) {
    if (key == 'SPACE') {
      setState(() {
        _query += ' ';
        _searchController.text = _query;
      });
    } else if (key == '⌫') {
      if (_query.isNotEmpty) {
        setState(() {
          _query = _query.substring(0, _query.length - 1);
          _searchController.text = _query;
        });
      }
    } else if (key == 'CLEAR') {
      setState(() {
        _query = '';
        _searchController.text = '';
      });
    } else {
      setState(() {
        _query += key.toLowerCase();
        _searchController.text = _query;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTV = widget.isTV;
    final tr = ref.watch(trProvider);
    final allContent = ref.watch(catalogueProvider);

    final filtered = _query.trim().isEmpty
        ? <ContentItem>[]
        : allContent.where((c) {
            final q = _query.toLowerCase();
            return c.title.toLowerCase().contains(q) ||
                c.hindiTitle.toLowerCase().contains(q) ||
                c.genres.any((g) => g.toLowerCase().contains(q)) ||
                c.cast.any((a) => a.toLowerCase().contains(q));
          }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isTV ? 48 : 20,
        vertical: 24,
      ),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryViolet.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.search,
                    color: AppTheme.primaryViolet, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (val) => setState(() => _query = val),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '${tr('search')} (Jawan, Mirzapur, Animal, 12th Fail...)',
                      hintStyle: const TextStyle(color: AppTheme.textMuted),
                    ),
                  ),
                ),
                if (_query.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white60),
                    onPressed: () => setState(() {
                      _query = '';
                      _searchController.clear();
                    }),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Layout
          if (isTV)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Reusable TV Virtual Keyboard
                SizedBox(
                  width: 360,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'On-Screen TV Remote Keyboard',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textMuted,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TvVirtualKeyboard(onKeyPress: _onKeypadPress),
                    ],
                  ),
                ),
                const SizedBox(width: 36),

                // Right: Results or Recent Searches
                Expanded(
                  child: _buildResultsSection(filtered),
                ),
              ],
            )
          else
            _buildResultsSection(filtered),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildResultsSection(List<ContentItem> filtered) {
    if (_query.trim().isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Searches',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _recentSearches.map((term) {
              return TVFocusable(
                onPressed: () {
                  setState(() {
                    _query = term;
                    _searchController.text = term;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.history,
                          color: AppTheme.textMuted, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        term,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'Popular Suggestions',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          _buildPopularGrid(),
        ],
      );
    }

    if (filtered.isEmpty) {
      return EmptyStateView(
        icon: Icons.search_off_rounded,
        title: 'No results for "$_query"',
        message: 'Try searching for Jawan, Mirzapur, Animal, Panchayat, or 12th Fail',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Results (${filtered.length})',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.isTV ? 4 : 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final item = filtered[index];
            return MovieCard(
              item: item,
              onTap: () => widget.onItemSelect(item),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPopularGrid() {
    final popular = ref.watch(catalogueProvider).take(4).toList();
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: popular.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = popular[index];
          return MovieCard(
            item: item,
            onTap: () => widget.onItemSelect(item),
            width: 140,
            height: 210,
          );
        },
      ),
    );
  }
}
