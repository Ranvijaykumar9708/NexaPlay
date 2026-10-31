import '../../models/content_item.dart';
import '../../models/live_channel.dart';

abstract class IContentRepository {
  Future<List<ContentItem>> getAllContent();
  Future<List<ContentItem>> getTrendingContent();
  Future<List<ContentItem>> getMovies();
  Future<List<ContentItem>> getSeries();
  Future<List<ContentItem>> getKidsContent();
  Future<List<LiveChannel>> getLiveChannels();
  Future<List<ContentItem>> searchContent(String query);
}
