import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

enum SportsCamAngle {
  mainFeed,
  stumpCam,
  tacticalBirdEye,
  superstarCam,
}

class AudioMasterViewModel extends ChangeNotifier {
  bool _isImaxEnhanced = false;
  bool _isDialogueBoosterOn = true;
  double _playbackSpeed = 1.0;
  String _sleepTimerText = 'Off';
  SportsCamAngle _currentCamAngle = SportsCamAngle.mainFeed;

  bool get isImaxEnhanced => _isImaxEnhanced;
  bool get isDialogueBoosterOn => _isDialogueBoosterOn;
  double get playbackSpeed => _playbackSpeed;
  String get sleepTimerText => _sleepTimerText;
  SportsCamAngle get currentCamAngle => _currentCamAngle;

  void toggleImax() {
    _isImaxEnhanced = !_isImaxEnhanced;
    notifyListeners();
  }

  void toggleDialogueBooster() {
    _isDialogueBoosterOn = !_isDialogueBoosterOn;
    notifyListeners();
  }

  void setPlaybackSpeed(double speed) {
    _playbackSpeed = speed;
    notifyListeners();
  }

  void setSleepTimer(String duration) {
    _sleepTimerText = duration;
    notifyListeners();
  }

  void setCamAngle(SportsCamAngle angle) {
    _currentCamAngle = angle;
    notifyListeners();
  }
}

final audioMasterProvider =
    ChangeNotifierProvider<AudioMasterViewModel>((ref) {
  return AudioMasterViewModel();
});
