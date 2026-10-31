import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/content_item.dart';
import '../models/profile.dart';
import '../data/mock_data.dart';

class PlaybackRecord {
  final int positionSeconds;
  final int totalSeconds;
  final DateTime updatedAt;

  PlaybackRecord({
    required this.positionSeconds,
    required this.totalSeconds,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'pos': positionSeconds,
    'total': totalSeconds,
    'updated': updatedAt.toIso8601String(),
  };

  factory PlaybackRecord.fromJson(Map<String, dynamic> json) => PlaybackRecord(
    positionSeconds: json['pos'] as int? ?? 0,
    totalSeconds: json['total'] as int? ?? 1,
    updatedAt: DateTime.tryParse(json['updated'] as String? ?? '') ?? DateTime.now(),
  );

  double get progressRatio =>
      totalSeconds > 0 ? (positionSeconds / totalSeconds).clamp(0.0, 1.0) : 0.0;

  String get timeLeftFormatted {
    final remaining = totalSeconds - positionSeconds;
    if (remaining <= 0) return 'Finished';
    final hours = remaining ~/ 3600;
    final minutes = (remaining % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m left';
    }
    return '${minutes}m left';
  }
}

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _isLoggedIn = true;
  bool get isLoggedIn => _isLoggedIn;

  UserProfile? _currentProfile;
  UserProfile? get currentProfile => _currentProfile;

  List<UserProfile> _profiles = List.from(MockData.initialProfiles);
  List<UserProfile> get profiles => _profiles;

  final Set<String> _watchlist = {'jawan', 'the-last-of-us', 'money-heist'};
  Set<String> get watchlist => _watchlist;

  final Map<String, PlaybackRecord> _continueWatching = {
    'jawan': PlaybackRecord(
      positionSeconds: 5760, // 1h 36m in
      totalSeconds: 10080, // 2h 48m total
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    'the-last-of-us': PlaybackRecord(
      positionSeconds: 2100,
      totalSeconds: 3600,
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    'money-heist': PlaybackRecord(
      positionSeconds: 1800,
      totalSeconds: 3000,
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  };
  Map<String, PlaybackRecord> get continueWatching => _continueWatching;

  String _audioLanguage = 'English';
  String get audioLanguage => _audioLanguage;

  String _subtitleLanguage = 'English';
  String get subtitleLanguage => _subtitleLanguage;

  String _videoQuality = 'Auto';
  String get videoQuality => _videoQuality;

  bool _autoplayNext = true;
  bool get autoplayNext => _autoplayNext;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? true;
      _audioLanguage = prefs.getString('audioLanguage') ?? 'English';
      _subtitleLanguage = prefs.getString('subtitleLanguage') ?? 'English';
      _videoQuality = prefs.getString('videoQuality') ?? 'Auto';
      _autoplayNext = prefs.getBool('autoplayNext') ?? true;

      // Watchlist
      final savedWatchlist = prefs.getStringList('watchlist');
      if (savedWatchlist != null) {
        _watchlist.clear();
        _watchlist.addAll(savedWatchlist);
      }

      // Profiles
      final savedProfilesJson = prefs.getString('profiles');
      if (savedProfilesJson != null) {
        final decoded = jsonDecode(savedProfilesJson) as List;
        _profiles = decoded.map((e) => UserProfile.fromJson(e)).toList();
      }

      // Current profile
      final currentProfileId = prefs.getString('currentProfileId');
      if (currentProfileId != null) {
        _currentProfile = _profiles.firstWhere(
          (p) => p.id == currentProfileId,
          orElse: () => _profiles.first,
        );
      } else {
        _currentProfile = _profiles.first;
      }

      // Continue watching records
      final savedCwJson = prefs.getString('continueWatching');
      if (savedCwJson != null) {
        final decoded = jsonDecode(savedCwJson) as Map<String, dynamic>;
        decoded.forEach((key, value) {
          _continueWatching[key] = PlaybackRecord.fromJson(value);
        });
      }
    } catch (e) {
      debugPrint('Error initializing AppState: $e');
      _currentProfile ??= _profiles.first;
    }
    _isInitialized = true;
    notifyListeners();
  }

  void selectProfile(UserProfile profile) {
    _currentProfile = profile;
    notifyListeners();
    _saveProfileSelection();
  }

  void addProfile(UserProfile profile) {
    _profiles.add(profile);
    notifyListeners();
    _saveProfiles();
  }

  void deleteProfile(String profileId) {
    if (_profiles.length <= 1) return;
    _profiles.removeWhere((p) => p.id == profileId);
    if (_currentProfile?.id == profileId) {
      _currentProfile = _profiles.first;
    }
    notifyListeners();
    _saveProfiles();
  }

  bool isInWatchlist(String contentId) => _watchlist.contains(contentId);

  void toggleWatchlist(String contentId) {
    if (_watchlist.contains(contentId)) {
      _watchlist.remove(contentId);
    } else {
      _watchlist.add(contentId);
    }
    notifyListeners();
    _saveWatchlist();
  }

  void savePlaybackProgress(String contentId, int pos, int total) {
    if (pos >= total - 10) {
      // Completed, remove from continue watching
      _continueWatching.remove(contentId);
    } else if (pos > 10) {
      _continueWatching[contentId] = PlaybackRecord(
        positionSeconds: pos,
        totalSeconds: total,
        updatedAt: DateTime.now(),
      );
    }
    notifyListeners();
    _saveContinueWatching();
  }

  void removeContinueWatching(String contentId) {
    _continueWatching.remove(contentId);
    notifyListeners();
    _saveContinueWatching();
  }

  PlaybackRecord? getPlaybackProgress(String contentId) =>
      _continueWatching[contentId];

  void setAudioLanguage(String lang) {
    _audioLanguage = lang;
    notifyListeners();
    _savePrefsString('audioLanguage', lang);
  }

  void setSubtitleLanguage(String sub) {
    _subtitleLanguage = sub;
    notifyListeners();
    _savePrefsString('subtitleLanguage', sub);
  }

  void setVideoQuality(String quality) {
    _videoQuality = quality;
    notifyListeners();
    _savePrefsString('videoQuality', quality);
  }

  void setAutoplayNext(bool value) {
    _autoplayNext = value;
    notifyListeners();
    SharedPreferences.getInstance().then((p) => p.setBool('autoplayNext', value));
  }

  void login(String phone) {
    _isLoggedIn = true;
    notifyListeners();
    SharedPreferences.getInstance().then((p) => p.setBool('isLoggedIn', true));
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
    SharedPreferences.getInstance().then((p) => p.setBool('isLoggedIn', false));
  }

  List<ContentItem> get accessibleContent {
    if (_currentProfile?.isKids == true) {
      return MockData.allContent.where((c) => c.isKidsFriendly).toList();
    }
    return MockData.allContent;
  }

  List<ContentItem> get watchlistItems {
    final accessible = accessibleContent;
    return accessible.where((c) => _watchlist.contains(c.id)).toList();
  }

  List<ContentItem> get continueWatchingItems {
    final accessible = accessibleContent;
    final items = <ContentItem>[];
    for (final id in _continueWatching.keys) {
      final match = accessible.where((c) => c.id == id);
      if (match.isNotEmpty) items.add(match.first);
    }
    return items;
  }

  Future<void> _saveProfileSelection() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentProfile != null) {
      await prefs.setString('currentProfileId', _currentProfile!.id);
    }
  }

  Future<void> _saveProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _profiles.map((p) => p.toJson()).toList();
    await prefs.setString('profiles', jsonEncode(jsonList));
  }

  Future<void> _saveWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('watchlist', _watchlist.toList());
  }

  Future<void> _saveContinueWatching() async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, dynamic>{};
    _continueWatching.forEach((k, v) => map[k] = v.toJson());
    await prefs.setString('continueWatching', jsonEncode(map));
  }

  Future<void> _savePrefsString(String key, String val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, val);
  }
}
