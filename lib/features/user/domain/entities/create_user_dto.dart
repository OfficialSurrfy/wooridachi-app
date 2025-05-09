class CreateUserDto {
  final String id;
  final String email;
  final String username;
  final String university;
  final String language;

  CreateUserDto({
    required this.id,
    required this.email,
    required this.username,
    required this.university,
    required this.language,
  });
}
