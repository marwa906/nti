class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    required this.bio,
  });

  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String bio;

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? location,
    String? bio,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bio: bio ?? this.bio,
    );
  }
}
