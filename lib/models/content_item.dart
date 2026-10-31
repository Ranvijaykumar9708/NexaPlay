class ContentItem {
  final String id;
  final String title;
  final String hindiTitle;
  final String description;
  final String posterUrl;
  final String backdropUrl;
  final double rating;
  final int year;
  final String duration;
  final List<String> genres;
  final String streamUrl;
  final List<String> cast;
  final String director;
  final String maturityRating;
  final bool is4K;
  final bool isHDR;
  final bool isDolbyVision;
  final bool isDolbyAtmos;
  final bool isKidsFriendly;
  final List<String> audioLanguages;
  final List<String> subtitleLanguages;
  final bool isTrending;
  final bool isMovie;
  final int seasons;
  final int introSkipStart;
  final int introSkipEnd;
  final List<String> trivia;
  final List<String> soundtrack;
  final bool isPremiere;

  const ContentItem({
    required this.id,
    required this.title,
    this.hindiTitle = '',
    required this.description,
    required this.posterUrl,
    required this.backdropUrl,
    required this.rating,
    required this.year,
    required this.duration,
    required this.genres,
    required this.streamUrl,
    required this.cast,
    required this.director,
    required this.maturityRating,
    this.is4K = true,
    this.isHDR = true,
    this.isDolbyVision = true,
    this.isDolbyAtmos = true,
    this.isKidsFriendly = false,
    this.audioLanguages = const ['Hindi (Original)', 'English', 'Tamil', 'Telugu'],
    this.subtitleLanguages = const ['Off', 'English', 'Hindi'],
    this.isTrending = false,
    this.isMovie = true,
    this.seasons = 1,
    this.introSkipStart = 0,
    this.introSkipEnd = 85,
    this.trivia = const [],
    this.soundtrack = const [],
    this.isPremiere = false,
  });
}
