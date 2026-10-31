import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/content_item.dart';
import '../viewmodels/app_providers.dart';
import '../presentation/widgets/common/empty_state_view.dart';
import '../widgets/movie_card.dart';

class WatchlistScreen extends ConsumerWidget {
  final Function(ContentItem) onItemSelect;
  final VoidCallback onBrowseCatalogue;
  final bool isTV;

  const WatchlistScreen({
    super.key,
    required this.onItemSelect,
    required this.onBrowseCatalogue,
    this.isTV = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(trProvider);
    final watchlistSet = ref.watch(watchlistProvider).watchlist;
    final accessible = ref.watch(catalogueProvider);

    final items = accessible.where((c) => watchlistSet.contains(c.id)).toList();

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
                '${tr('my_list')} (${items.length})',
                style: GoogleFonts.outfit(
                  fontSize: isTV ? 30 : 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (items.isEmpty)
            EmptyStateView(
              icon: Icons.bookmark_outline_rounded,
              title: 'Your Watchlist is Empty',
              message: 'Save your favorite Bollywood movies and web series to watch them anytime.',
              buttonText: 'Browse Popular Movies',
              onButtonPressed: onBrowseCatalogue,
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTV ? 5 : 2,
                crossAxisSpacing: isTV ? 16 : 12,
                mainAxisSpacing: isTV ? 20 : 16,
                childAspectRatio: 0.65,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return MovieCard(
                  item: item,
                  onTap: () => onItemSelect(item),
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
