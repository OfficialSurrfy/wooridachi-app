class ReplyLikeException implements Exception {}

class ReplyLikeNotFoundException extends ReplyLikeException {
  @override
  String toString() => 'Reply like not found';
}

class ReplyLikeAlreadyExistsException extends ReplyLikeException {
  @override
  String toString() => 'Reply like already exists';
}

class ReplyLikeAddException extends ReplyLikeException {
  @override
  String toString() => 'Failed to add reply like';
}

class ReplyLikeDeleteException extends ReplyLikeException {
  @override
  String toString() => 'Failed to delete reply like';
}
