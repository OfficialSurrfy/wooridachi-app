abstract class BlockReportException implements Exception {
  final String message;
  const BlockReportException(this.message);
}

class UserNotFoundException extends BlockReportException {
  const UserNotFoundException([super.message = 'User not found']);
}

class UserAlreadyBlockedException extends BlockReportException {
  const UserAlreadyBlockedException([super.message = 'User is already blocked']);
}

class MaxBlockedUsersException extends BlockReportException {
  const MaxBlockedUsersException([super.message = 'The maximum number of blocked users is 1000']);
}

class UserNotBlockedException extends BlockReportException {
  const UserNotBlockedException([super.message = 'User is not blocked']);
}

class UserReportFailedException extends BlockReportException {
  const UserReportFailedException([super.message = 'Failed to report user']);
}

class CantReportYourselfException extends BlockReportException {
  const CantReportYourselfException([super.message = 'You cannot report yourself']);
}

class CantBlockYourselfException extends BlockReportException {
  const CantBlockYourselfException([super.message = 'You cannot block yourself']);
}
