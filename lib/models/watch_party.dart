class LiveReaction {
  final String id;
  final String emoji;
  final String sender;
  final double xOffset;

  LiveReaction({
    required this.id,
    required this.emoji,
    required this.sender,
    required this.xOffset,
  });
}

class WatchPartyRoom {
  final String roomCode;
  final String hostName;
  final String contentId;
  final int participantsCount;
  final bool isHost;

  const WatchPartyRoom({
    required this.roomCode,
    required this.hostName,
    required this.contentId,
    this.participantsCount = 4,
    this.isHost = true,
  });
}
