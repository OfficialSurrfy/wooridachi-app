class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}

class UserNotFoundException extends AuthException {
  UserNotFoundException() : super('User not found');
}

class InvalidCredentialException extends AuthException {
  InvalidCredentialException() : super('Invalid credential');
}

class InvalidEmailException extends AuthException {
  InvalidEmailException() : super('Invalid email');
}

class InvalidPasswordException extends AuthException {
  InvalidPasswordException() : super('Invalid password');
}

class WeakPasswordException extends AuthException {
  WeakPasswordException() : super('Weak password');
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException() : super('Email already in use');
}

class UserAlreadyExistsException extends AuthException {
  UserAlreadyExistsException() : super('User already exists');
}

class EmailNotVerifiedException extends AuthException {
  EmailNotVerifiedException() : super('Email not verified');
}

class UserNotVerifiedException extends AuthException {
  UserNotVerifiedException() : super('User not verified');
}

class UserNotLoggedInException extends AuthException {
  UserNotLoggedInException() : super('User not logged in');
}

class UserNotRegisteredException extends AuthException {
  UserNotRegisteredException() : super('User not registered');
}

class FirebaseAuthExceptionHandler extends AuthException {
  FirebaseAuthExceptionHandler(super.message);

  static AuthException fromCode(String code) {
    switch (code) {
      case 'user-not-found':
        return UserNotFoundException();
      case 'invalid-credential':
        return InvalidCredentialException();
      case 'invalid-email':
        return InvalidEmailException();
      case 'wrong-password':
        return InvalidPasswordException();
      case 'user-disabled':
        return UserNotVerifiedException();
      case 'email-already-in-use':
        return EmailAlreadyInUseException();
      case 'weak-password':
        return WeakPasswordException();
      case 'email-not-verified':
        return EmailNotVerifiedException();
      default:
        return AuthException('An unknown error occurred');
    }
  }
}
