import 'dart:io';

class PostUploadDto {
  final String title;
  final String description;
  final String? address;
  final String? selectedPlace;
  final String? rating;
  final String? moneyRating;
  final List<File>? images;

  PostUploadDto({
    required this.title,
    required this.description,
    this.address,
    this.selectedPlace,
    this.rating,
    this.moneyRating,
    this.images,
  });
}
