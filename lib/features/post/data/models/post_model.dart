import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/post_entity.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final String id;
  final String userId;

  // Post details
  final String title;
  final String description;
  final String? translatedTitle;
  final String? translatedDescription;

  final List<String>? imageUrls;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;

  // Post location
  final String? address;
  final String? selectedPlace;

  // Post rating
  final String? rating;
  final String? moneyRating;

  PostModel({
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

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  PostEntity toEntity() => PostEntity(
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
}
