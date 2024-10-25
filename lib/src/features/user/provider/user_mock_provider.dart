import 'dart:async';
import '../model/user.dart';

User get _mockUser => User(
      id: 'gondraz',
      name: 'gondraz',
      email: 'gondraz@test.com',
      imageUrl:
          'https://cdn.discordapp.com/attachments/1276556647732609066/1282204877249974343/Artboard_1.png?ex=670b54d8&is=670a0358&hm=d352e4ef44e5532a5bf02fa900ad9e2be558a83ec306c3e1002158b77b6ef65a&',
      createdAt: DateTime.now(),
    );

class UserMockProvider {
  UserMockProvider() {
    triggerNotLoggedIn();
  }

  final _userStream = StreamController<User?>.broadcast();

  Stream<User?> getUserStream() => _userStream.stream;

  Future<User?> triggerLoggedIn() async {
    await _networkDelay();

    final user = _mockUser;
    _userStream.add(user);
    return user;
  }

  Future<void> triggerNotLoggedIn() async {
    await _networkDelay();
    _userStream.add(null);
  }

  void triggerLoggedOut() {
    _userStream.add(null);
  }

  /// Simulate network delay
  Future<void> _networkDelay() async {
    await Future<void>.delayed(const Duration(seconds: 2));
  }
}
