import 'package:vivapro/features/auth/data/industry.dart';

class Profile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String profileImage;
  final Industry industry;
  final List<String> skills;
  final String language;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.profileImage,
    required this.industry,
    required this.skills,
    required this.language,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      profileImage: json['profileImage'],
      industry: Industry.values.firstWhere((e) => e.name == json['industry']),
      skills: List<String>.from(json['skills']),
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'profileImage': profileImage,
      'industry': industry.name,
      'skills': skills,
      'language': language,
    };
  }

  @override
  String toString() {
    return 'Profile(id: $id, name: $name, email: $email, phone: $phone, address: $address, profileImage: $profileImage, industry: $industry, skills: $skills, language: $language)';
  }
}
