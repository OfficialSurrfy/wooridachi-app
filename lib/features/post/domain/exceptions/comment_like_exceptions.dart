class CommentLikeException implements Exception {}

class CommentLikeNotFoundException extends CommentLikeException {
  @override
  String toString() => 'Comment like not found';
}

class CommentLikeAlreadyExistsException extends CommentLikeException {
  @override
  String toString() => 'Comment like already exists';
}

class CommentLikeAddException extends CommentLikeException {
  @override
  String toString() => 'Failed to add comment like';
}

class CommentLikeDeleteException extends CommentLikeException {
  @override
  String toString() => 'Failed to delete comment like';
}
