class UserProfile {
  final String id;
  final String name;
  final String avatarColor;
  final String avatarIcon;
  final bool isKids;
  final String? pin;

  const UserProfile({
    required this.id,
    required this.name,
    required this.avatarColor,
    required this.avatarIcon,
    this.isKids = false,
    this.pin,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatarColor': avatarColor,
    'avatarIcon': avatarIcon,
    'isKids': isKids,
    'pin': pin,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    name: json['name'] as String,
    avatarColor: json['avatarColor'] as String,
    avatarIcon: json['avatarIcon'] as String,
    isKids: json['isKids'] as bool? ?? false,
    pin: json['pin'] as String?,
  );
}
