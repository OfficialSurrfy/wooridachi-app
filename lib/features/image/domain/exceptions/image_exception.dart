class ImageException implements Exception {
  final String message;

  ImageException(this.message);
}

class ImageCompressionFailedException extends ImageException {
  ImageCompressionFailedException() : super('Image compression failed');
}

class ImageUploadFailedException extends ImageException {
  ImageUploadFailedException() : super('Image upload failed');
}

class ImageTooLargeException extends ImageException {
  ImageTooLargeException() : super('Image is too large');
}
