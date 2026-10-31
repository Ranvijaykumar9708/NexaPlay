import '../../domain/repositories/i_content_repository.dart';
import '../../models/content_item.dart';
import '../../models/live_channel.dart';
import '../mock_data.dart';

class ContentRepositoryImpl implements IContentRepository {
  @override
  Future<List<ContentItem>> getAllContent() async {
    return List.unmodifiable(MockData.allContent);
  }

  @override
  Future<List<ContentItem>> getTrendingContent() async {
    return MockData.allContent.where((c) => c.isTrending).toList();
  }

  @override
  Future<List<ContentItem>> getMovies() async {
    return MockData.allContent.where((c) => c.isMovie).toList();
  }

  @override
  Future<List<ContentItem>> getSeries() async {
    return MockData.allContent.where((c) => !c.isMovie).toList();
  }

  @override
  Future<List<ContentItem>> getKidsContent() async {
    return MockData.allContent.where((c) => c.isKidsFriendly).toList();
  }

  @override
  Future<List<LiveChannel>> getLiveChannels() async {
    return List.unmodifiable(MockData.liveChannels);
  }

  @override
  Future<List<ContentItem>> searchContent(String query) async {
    if (query.trim().isEmpty) return [];
    final lower = query.toLowerCase();
    return MockData.allContent.where((c) {
      return c.title.toLowerCase().contains(lower) ||
          c.hindiTitle.toLowerCase().contains(lower) ||
          c.genres.any((g) => g.toLowerCase().contains(lower)) ||
          c.cast.any((a) => a.toLowerCase().contains(lower));
    }).toList();
  }
}
