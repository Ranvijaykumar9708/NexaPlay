import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/content_item.dart';
import '../viewmodels/app_providers.dart';
import '../widgets/hero_banner.dart';
import '../widgets/content_row.dart';

class HomeScreen extends ConsumerWidget {
  final Function(ContentItem) onItemSelect;
  final Function(ContentItem) onPlay;
  final bool isTV;

  const HomeScreen({
    super.key,
    required this.onItemSelect,
    required this.onPlay,
    this.isTV = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(trProvider);
    final accessible = ref.watch(catalogueProvider);
    final playbackMap = ref.watch(playbackProvider).progress;

    // Hero item is JAWAN (India's mega blockbuster)
    final heroItem = accessible.firstWhere(
      (c) => c.id == 'jawan',
      orElse: () => accessible.first,
    );

    // Continue Watching list
    final continueWatching = <ContentItem>[];
    for (final id in playbackMap.keys) {
      final match = accessible.where((c) => c.id == id);
      if (match.isNotEmpty) continueWatching.add(match.first);
    }

    final trending = accessible.where((c) => c.isTrending).toList();
    final bollywood = accessible.where((c) => c.isMovie).toList();
    final hindiSeries = accessible.where((c) => !c.isMovie).toList();
    final southSuperhits = accessible
        .where((c) =>
            c.id == 'kalki-2898-ad' || c.id == 'kgf-2' || c.id == 'rrr')
        .toList();
    final kidsFriendly =
        accessible.where((c) => c.isKidsFriendly).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Spotlight Banner
          HeroBanner(
            item: heroItem,
            isTV: isTV,
            onPlay: () => onPlay(heroItem),
            onMoreInfo: () => onItemSelect(heroItem),
          ),

          const SizedBox(height: 12),

          // 1. Continue Watching
          if (continueWatching.isNotEmpty)
            ContentRow(
              title: tr('continue_watching'),
              items: continueWatching,
              showProgress: true,
              isFeaturedLandscape: true,
              isTV: isTV,
              onItemTap: (item) => onPlay(item),
            ),

          // 2. Trending in India
          ContentRow(
            title: tr('trending_now'),
            items: trending,
            isTV: isTV,
            onItemTap: onItemSelect,
          ),

          // 3. Bollywood Blockbusters
          ContentRow(
            title: tr('blockbuster_movies'),
            items: bollywood,
            isTV: isTV,
            onItemTap: onItemSelect,
          ),

          // 4. Cult Hindi Web Series
          ContentRow(
            title: tr('cult_series'),
            items: hindiSeries,
            isTV: isTV,
            onItemTap: onItemSelect,
          ),

          // 5. South Indian Dubbed Superhits
          if (southSuperhits.isNotEmpty)
            ContentRow(
              title: tr('south_blockbusters'),
              items: southSuperhits,
              isTV: isTV,
              onItemTap: onItemSelect,
            ),

          // 6. Kids & Family Animation
          if (kidsFriendly.isNotEmpty)
            ContentRow(
              title: tr('kids_corner'),
              items: kidsFriendly,
              isTV: isTV,
              onItemTap: onItemSelect,
            ),

          // 7. Recommended
          ContentRow(
            title: tr('recommended'),
            items: accessible.reversed.toList(),
            isTV: isTV,
            onItemTap: onItemSelect,
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
