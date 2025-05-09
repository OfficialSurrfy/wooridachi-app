abstract class UserException implements Exception {
  final String message;
  const UserException(this.message);
}

class UserNotFoundException extends UserException {
  const UserNotFoundException([super.message = 'User not found']);
}

class UserAlreadyExistsException extends UserException {
  const UserAlreadyExistsException([super.message = 'User already exists']);
}

class UserDeletionFailedException extends UserException {
  const UserDeletionFailedException([super.message = 'Failed to delete user']);
}

class UserUpdateFailedException extends UserException {
  const UserUpdateFailedException([super.message = 'Failed to update user']);
}
