class ProfileEntity {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatarUrl;

  const ProfileEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
  });

  String get fullName => '$firstName $lastName';
}
