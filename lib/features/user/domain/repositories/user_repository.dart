import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUserById(String userId);
  Future<UserEntity> getUserByEmail(String email);
  Future<UserEntity> getUserByUsername(String username);
  Future<UserEntity> setUser(UserEntity user);
  Future<void> deleteUser(String userId);
}
