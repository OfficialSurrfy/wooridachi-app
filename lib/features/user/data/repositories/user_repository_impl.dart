import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_datasource.dart';
import '../../domain/exceptions/user_exceptions.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasource _datasource;

  UserRepositoryImpl(this._datasource);

  @override
  Future<UserEntity> getUserById(String userId) async {
    try {
      final userModel = await _datasource.getUserById(userId);
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> getUserByEmail(String email) async {
    try {
      final userModel = await _datasource.getUserByEmail(email);
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> getUserByUsername(String username) async {
    try {
      final userModel = await _datasource.getUserByUsername(username);
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> setUser(UserEntity user) async {
    try {
      final userModel = user.toModel();
      await _datasource.setUser(userModel);
      return user;
    } catch (e) {
      throw const UserUpdateFailedException();
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _datasource.deleteUser(userId);
    } catch (e) {
      throw const UserDeletionFailedException();
    }
  }
}
