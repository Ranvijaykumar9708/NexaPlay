import '../../models/profile.dart';

abstract class IProfileRepository {
  Future<List<UserProfile>> getProfiles();
  Future<UserProfile?> getActiveProfile();
  Future<void> saveActiveProfile(String profileId);
  Future<void> addProfile(UserProfile profile);
  Future<void> deleteProfile(String profileId);
  bool verifyParentalPin(String pin);
}
