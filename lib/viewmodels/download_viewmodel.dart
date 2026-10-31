import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/content_item.dart';
import '../models/download_item.dart';

class DownloadViewModel extends ChangeNotifier {
  final List<DownloadItem> _downloads = [
    const DownloadItem(
      id: 'd1',
      contentId: 'jawan',
      title: 'JAWAN',
      hindiTitle: 'जवान',
      posterUrl:
          'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=600&auto=format&fit=crop&q=80',
      fileSize: '2.4 GB',
      quality: '4K Ultra HD',
    ),
    const DownloadItem(
      id: 'd2',
      contentId: 'mirzapur',
      title: 'MIRZAPUR: S3 E1',
      hindiTitle: 'मिर्ज़ापुर',
      posterUrl:
          'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=600&auto=format&fit=crop&q=80',
      fileSize: '850 MB',
      quality: '1080p Full HD',
    ),
  ];

  double _usedStorageGb = 28.5;
  final double _totalStorageGb = 128.0;

  List<DownloadItem> get downloads => _downloads;
  double get usedStorageGb => _usedStorageGb;
  double get totalStorageGb => _totalStorageGb;
  double get storageRatio => (_usedStorageGb / _totalStorageGb).clamp(0.0, 1.0);

  bool isDownloaded(String contentId) {
    return _downloads.any((d) => d.contentId == contentId);
  }

  void downloadContent(ContentItem item) {
    if (isDownloaded(item.id)) return;
    _downloads.add(DownloadItem(
      id: 'd_${DateTime.now().millisecondsSinceEpoch}',
      contentId: item.id,
      title: item.title,
      hindiTitle: item.hindiTitle,
      posterUrl: item.posterUrl,
      fileSize: '1.8 GB',
      quality: '1080p Full HD',
    ));
    _usedStorageGb += 1.8;
    notifyListeners();
  }

  void removeDownload(String downloadId) {
    _downloads.removeWhere((d) => d.id == downloadId);
    _usedStorageGb = (_usedStorageGb - 1.5).clamp(10.0, 128.0);
    notifyListeners();
  }
}

final downloadProvider =
    ChangeNotifierProvider<DownloadViewModel>((ref) {
  return DownloadViewModel();
});
