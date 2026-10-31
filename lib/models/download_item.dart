class DownloadItem {
  final String id;
  final String contentId;
  final String title;
  final String hindiTitle;
  final String posterUrl;
  final String fileSize;
  final double progress; // 0.0 to 1.0
  final bool isCompleted;
  final String quality;

  const DownloadItem({
    required this.id,
    required this.contentId,
    required this.title,
    this.hindiTitle = '',
    required this.posterUrl,
    required this.fileSize,
    this.progress = 1.0,
    this.isCompleted = true,
    this.quality = '1080p Full HD',
  });
}
