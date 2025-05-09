// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      translatedTitle: json['translatedTitle'] as String?,
      translatedDescription: json['translatedDescription'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      likesCount: (json['likesCount'] as num).toInt(),
      commentsCount: (json['commentsCount'] as num).toInt(),
      address: json['address'] as String?,
      selectedPlace: json['selectedPlace'] as String?,
      rating: json['rating'] as String?,
      moneyRating: json['moneyRating'] as String?,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'translatedTitle': instance.translatedTitle,
      'translatedDescription': instance.translatedDescription,
      'imageUrls': instance.imageUrls,
      'createdAt': instance.createdAt.toIso8601String(),
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'address': instance.address,
      'selectedPlace': instance.selectedPlace,
      'rating': instance.rating,
      'moneyRating': instance.moneyRating,
    };
