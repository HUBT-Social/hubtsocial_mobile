import '../model/user.dart';
import '../provider/user_mock_provider.dart';

class UserRepository {
  const UserRepository({
    required this.userProvider,
  });

  final UserMockProvider userProvider;

  Stream<User?> getUserStream() {
    return userProvider.getUserStream();
  }

  void logOut() {
    userProvider.triggerLoggedOut();
  }
}