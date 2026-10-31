import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/watch_party.dart';

class WatchPartyViewModel extends ChangeNotifier {
  WatchPartyRoom? _currentRoom;
  final List<LiveReaction> _activeReactions = [];

  WatchPartyRoom? get currentRoom => _currentRoom;
  List<LiveReaction> get activeReactions => _activeReactions;
  bool get isInParty => _currentRoom != null;

  void createRoom(String contentId, String hostName) {
    final code = 'NX-${Random().nextInt(9000) + 1000}';
    _currentRoom = WatchPartyRoom(
      roomCode: code,
      hostName: hostName,
      contentId: contentId,
      participantsCount: 1,
      isHost: true,
    );
    notifyListeners();
  }

  bool joinRoom(String code, String participantName) {
    if (code.trim().isEmpty) return false;
    _currentRoom = WatchPartyRoom(
      roomCode: code.toUpperCase(),
      hostName: 'Ranvijay',
      contentId: 'jawan',
      participantsCount: 4,
      isHost: false,
    );
    notifyListeners();
    return true;
  }

  void leaveParty() {
    _currentRoom = null;
    _activeReactions.clear();
    notifyListeners();
  }

  void sendReaction(String emoji) {
    final reaction = LiveReaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      emoji: emoji,
      sender: _currentRoom?.isHost == true ? 'Host' : 'Guest',
      xOffset: (Random().nextDouble() * 0.6) + 0.2, // 20% to 80% screen width
    );
    _activeReactions.add(reaction);
    notifyListeners();

    // Remove reaction after 3 seconds
    Timer(const Duration(milliseconds: 2500), () {
      _activeReactions.removeWhere((r) => r.id == reaction.id);
      notifyListeners();
    });
  }
}

final watchPartyProvider =
    ChangeNotifierProvider<WatchPartyViewModel>((ref) {
  return WatchPartyViewModel();
});
