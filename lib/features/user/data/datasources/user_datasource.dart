import '../../data/models/user_model.dart';

abstract class UserDatasource {
  Future<UserModel> getUserById(String userId);
  Future<UserModel> getUserByEmail(String email);
  Future<UserModel> getUserByUsername(String username);
  Future<void> setUser(UserModel user);
  Future<void> deleteUser(String userId);
}
