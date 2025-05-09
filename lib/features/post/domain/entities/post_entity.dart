import '../../data/models/post_model.dart';

class PostEntity {
  final String id;
  final String userId;

  final String title;
  final String description;

  final String? translatedTitle;
  final String? translatedDescription;

  final List<String>? imageUrls;
  final DateTime createdAt;
  int likesCount;
  int commentsCount;

  final String? address;
  final String? selectedPlace;

  final String? rating;
  final String? moneyRating;

  PostEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.translatedTitle,
    this.translatedDescription,
    this.imageUrls,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    this.address,
    this.selectedPlace,
    this.rating,
    this.moneyRating,
  });

  PostModel toModel() => PostModel(
        id: id,
        userId: userId,
        title: title,
        description: description,
        translatedTitle: translatedTitle,
        translatedDescription: translatedDescription,
        imageUrls: imageUrls,
        createdAt: createdAt,
        likesCount: likesCount,
        commentsCount: commentsCount,
        address: address,
        selectedPlace: selectedPlace,
        rating: rating,
        moneyRating: moneyRating,
      );

  PostEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? translatedTitle,
    String? translatedDescription,
    List<String>? imageUrls,
    DateTime? createdAt,
    int? likesCount,
    int? commentsCount,
    String? address,
    String? selectedPlace,
    String? rating,
    String? moneyRating,
  }) {
    return PostEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      translatedTitle: translatedTitle ?? this.translatedTitle,
      translatedDescription: translatedDescription ?? this.translatedDescription,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      address: address ?? this.address,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      rating: rating ?? this.rating,
      moneyRating: moneyRating ?? this.moneyRating,
    );
  }
}
