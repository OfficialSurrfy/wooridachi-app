class PostLikeException implements Exception {
  final String message;

  PostLikeException(this.message);
}

class PostLikeNotFoundException extends PostLikeException {
  PostLikeNotFoundException() : super('Post likes not found');
}

class PostLikeAlreadyExistsException extends PostLikeException {
  PostLikeAlreadyExistsException() : super('Post likes already exists');
}

class PostLikeDeleteException extends PostLikeException {
  PostLikeDeleteException() : super('Post likes delete failed');
}

class PostLikeAddException extends PostLikeException {
  PostLikeAddException() : super('Post likes add failed');
}
