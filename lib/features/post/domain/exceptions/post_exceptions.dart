class PostException implements Exception {
  final String message;

  PostException(this.message);
}

class PostNotFoundException extends PostException {
  PostNotFoundException() : super('Post not found');
}

class PostNotLikedException extends PostException {
  PostNotLikedException() : super('Post not liked');
}

class PostAlreadyLikedException extends PostException {
  PostAlreadyLikedException() : super('Post already liked');
}

class PostNotCommentedException extends PostException {
  PostNotCommentedException() : super('Post not commented');
}

class PostAddException extends PostException {
  PostAddException() : super('Post add failed');
}

class PostDeleteException extends PostException {
  PostDeleteException() : super('Post delete failed');
}

class PostUpdateException extends PostException {
  PostUpdateException() : super('Post update failed');
}

class PostIncrementLikeCountException extends PostException {
  PostIncrementLikeCountException() : super('Post increment like count failed');
}

class PostDecrementLikeCountException extends PostException {
  PostDecrementLikeCountException() : super('Post decrement like count failed');
}

class PostIncrementCommentCountException extends PostException {
  PostIncrementCommentCountException() : super('Post increment comment count failed');
}

class PostDecrementCommentCountException extends PostException {
  PostDecrementCommentCountException() : super('Post decrement comment count failed');
}

class PostGetException extends PostException {
  PostGetException() : super('Post get failed');
}
