class PostCommentException implements Exception {
  final String message;

  PostCommentException(this.message);
}

class PostCommentNotFoundException extends PostCommentException {
  PostCommentNotFoundException() : super('Post comment not found');
}

class PostCommentDeleteException extends PostCommentException {
  PostCommentDeleteException() : super('Post comment delete failed');
}

class PostCommentAddException extends PostCommentException {
  PostCommentAddException() : super('Post comment add failed');
}

class PostCommentGetException extends PostCommentException {
  PostCommentGetException() : super('Post comment get failed');
}

class PostCommentUpdateException extends PostCommentException {
  PostCommentUpdateException() : super('Post comment update failed');
}
