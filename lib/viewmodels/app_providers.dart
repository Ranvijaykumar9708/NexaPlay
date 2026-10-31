import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/localization/app_strings.dart';
import '../models/content_item.dart';
import '../models/live_channel.dart';
import '../models/profile.dart';
import '../data/mock_data.dart';

// --- 1. LOCALIZATION VIEWMODEL ---
class LocaleViewModel extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;
  AppLanguage get language => _language;

  LocaleViewModel() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langStr = prefs.getString('app_language');
    if (langStr == 'hindi') {
      _language = AppLanguage.hindi;
      notifyListeners();
    }
  }

  void setLanguage(AppLanguage language) async {
    _language = language;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'app_language',
      language == AppLanguage.hindi ? 'hindi' : 'english',
    );
  }

  void toggleLanguage() {
    setLanguage(
      _language == AppLanguage.english
          ? AppLanguage.hindi
          : AppLanguage.english,
    );
  }
}

final localeProvider = ChangeNotifierProvider<LocaleViewModel>((ref) {
  return LocaleViewModel();
});

// Translation helper
final trProvider = Provider<String Function(String)>((ref) {
  final lang = ref.watch(localeProvider).language;
  return (String key) => AppStrings.get(key, lang);
});

// --- 2. PROFILE VIEWMODEL ---
class ProfileViewModel extends ChangeNotifier {
  UserProfile _currentProfile = MockData.initialProfiles.first;
  List<UserProfile> _profiles = List.from(MockData.initialProfiles);

  UserProfile get currentProfile => _currentProfile;
  List<UserProfile> get profiles => _profiles;

  ProfileViewModel() {
    _initProfiles();
  }

  Future<void> _initProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final savedProfilesJson = prefs.getString('profiles_v2');
    if (savedProfilesJson != null) {
      final decoded = jsonDecode(savedProfilesJson) as List;
      _profiles = decoded.map((e) => UserProfile.fromJson(e)).toList();
      final currentId = prefs.getString('current_profile_id');
      _currentProfile = _profiles.firstWhere(
        (p) => p.id == currentId,
        orElse: () => _profiles.first,
      );
      notifyListeners();
    }
  }

  void selectProfile(UserProfile profile) async {
    _currentProfile = profile;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_profile_id', profile.id);
  }

  void addProfile(UserProfile profile) async {
    _profiles.add(profile);
    notifyListeners();
    _persistProfiles();
  }

  void deleteProfile(String profileId) {
    if (_profiles.length <= 1) return;
    _profiles.removeWhere((p) => p.id == profileId);
    if (_currentProfile.id == profileId) {
      _currentProfile = _profiles.first;
    }
    notifyListeners();
    _persistProfiles();
  }

  bool verifyParentalPin(String pin) {
    return pin == '1234';
  }

  void _persistProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_profiles.map((e) => e.toJson()).toList());
    await prefs.setString('profiles_v2', encoded);
  }
}

final profileViewModelProvider = ChangeNotifierProvider<ProfileViewModel>((
  ref,
) {
  return ProfileViewModel();
});

// --- 3. CATALOGUE VIEWMODEL ---
final catalogueProvider = Provider<List<ContentItem>>((ref) {
  final profileVm = ref.watch(profileViewModelProvider);
  if (profileVm.currentProfile.isKids) {
    return MockData.allContent.where((c) => c.isKidsFriendly).toList();
  }
  return MockData.allContent;
});

// --- 4. WATCHLIST VIEWMODEL ---
class WatchlistViewModel extends ChangeNotifier {
  final Set<String> _watchlist = {'jawan', 'mirzapur', '12th-fail'};
  Set<String> get watchlist => _watchlist;

  WatchlistViewModel() {
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('watchlist_v2');
    if (list != null) {
      _watchlist.clear();
      _watchlist.addAll(list);
      notifyListeners();
    }
  }

  void toggle(String contentId) async {
    if (_watchlist.contains(contentId)) {
      _watchlist.remove(contentId);
    } else {
      _watchlist.add(contentId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('watchlist_v2', _watchlist.toList());
  }

  bool contains(String id) => _watchlist.contains(id);
}

final watchlistProvider = ChangeNotifierProvider<WatchlistViewModel>((ref) {
  return WatchlistViewModel();
});

// --- 5. PLAYBACK PROGRESS VIEWMODEL ---
class PlaybackInfo {
  final int positionSeconds;
  final int totalSeconds;
  final DateTime updatedAt;

  PlaybackInfo({
    required this.positionSeconds,
    required this.totalSeconds,
    required this.updatedAt,
  });

  double get ratio =>
      totalSeconds > 0 ? (positionSeconds / totalSeconds).clamp(0.0, 1.0) : 0.0;

  String get timeLeft {
    final rem = totalSeconds - positionSeconds;
    if (rem <= 0) return 'Completed';
    final h = rem ~/ 3600;
    final m = (rem % 3600) ~/ 60;
    return h > 0 ? '${h}h ${m}m left' : '${m}m left';
  }
}

class PlaybackViewModel extends ChangeNotifier {
  final Map<String, PlaybackInfo> _progress = {
    'jawan': PlaybackInfo(
      positionSeconds: 5800,
      totalSeconds: 10080,
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    'mirzapur': PlaybackInfo(
      positionSeconds: 1200,
      totalSeconds: 3600,
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    '12th-fail': PlaybackInfo(
      positionSeconds: 2400,
      totalSeconds: 8820,
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  };

  Map<String, PlaybackInfo> get progress => _progress;

  void updateProgress(String id, int pos, int total) {
    if (pos >= total - 15) {
      _progress.remove(id);
    } else if (pos > 10) {
      _progress[id] = PlaybackInfo(
        positionSeconds: pos,
        totalSeconds: total,
        updatedAt: DateTime.now(),
      );
    }
    notifyListeners();
  }

  void remove(String id) {
    _progress.remove(id);
    notifyListeners();
  }

  void clearAll() {
    _progress.clear();
    notifyListeners();
  }
}

final playbackProvider = ChangeNotifierProvider<PlaybackViewModel>((ref) {
  return PlaybackViewModel();
});

// --- 6. LIVE TV VIEWMODEL ---
class LiveTvViewModel extends ChangeNotifier {
  LiveChannel _selectedChannel = MockData.liveChannels.first;
  LiveChannel get selectedChannel => _selectedChannel;

  void selectChannel(LiveChannel channel) {
    _selectedChannel = channel;
    notifyListeners();
  }
}

final liveTvProvider = ChangeNotifierProvider<LiveTvViewModel>((ref) {
  return LiveTvViewModel();
});

// --- 7. VIP GOLD MEMBERSHIP VIEWMODEL ---
class VipViewModel extends ChangeNotifier {
  bool _isVip = true;
  String _planName = 'NexaPlay Gold VIP (Annual 4K)';
  bool _spatialAudioEnabled = true;
  bool _dolbyVisionEnabled = true;

  bool get isVip => _isVip;
  String get planName => _planName;
  bool get spatialAudioEnabled => _spatialAudioEnabled;
  bool get dolbyVisionEnabled => _dolbyVisionEnabled;

  void toggleSpatialAudio() {
    _spatialAudioEnabled = !_spatialAudioEnabled;
    notifyListeners();
  }

  void toggleDolbyVision() {
    _dolbyVisionEnabled = !_dolbyVisionEnabled;
    notifyListeners();
  }

  void upgradeToUltra() {
    _isVip = true;
    _planName = 'NexaPlay Gold Ultra 4K Dolby Atmos';
    notifyListeners();
  }
}

final vipProvider = ChangeNotifierProvider<VipViewModel>((ref) {
  return VipViewModel();
});
