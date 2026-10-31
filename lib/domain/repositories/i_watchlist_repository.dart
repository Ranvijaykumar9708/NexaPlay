abstract class IWatchlistRepository {
  Future<Set<String>> getWatchlist();
  Future<void> toggleWatchlist(String contentId);
  Future<bool> isInWatchlist(String contentId);
}
