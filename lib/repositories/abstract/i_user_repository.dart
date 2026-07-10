import 'package:my_guide_app/models/user_model.dart';

abstract class IUserRepository {
  Future<UserModel?> getUser(String id);
  Future<void> createUser(UserModel user);
  Future<void> updateLastLogin(String id);
}
