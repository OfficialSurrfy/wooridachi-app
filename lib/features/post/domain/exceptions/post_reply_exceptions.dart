class PostReplyException implements Exception {
  final String message;

  PostReplyException(this.message);
}

class PostReplyNotFoundException extends PostReplyException {
  PostReplyNotFoundException() : super('Post reply not found');
}

class PostReplyDeleteException extends PostReplyException {
  PostReplyDeleteException() : super('Post reply delete failed');
}

class PostReplyAddException extends PostReplyException {
  PostReplyAddException() : super('Post reply add failed');
}

class PostReplyGetException extends PostReplyException {
  PostReplyGetException() : super('Post reply get failed');
}

class PostReplyUpdateException extends PostReplyException {
  PostReplyUpdateException() : super('Post reply update failed');
}
