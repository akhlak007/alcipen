class User {
  final String id;
  final String name;
  final String email;
  final String photo;
  final String? bio;
  final List<String>? specialties;
  final UserRole role;
  final double? rating;
  final int? completedProjects;
  final Map<String, dynamic>? writerDetails;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
    this.bio,
    this.specialties,
    required this.role,
    this.rating,
    this.completedProjects,
    this.writerDetails,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      bio: json['bio'],
      specialties: json['specialties'] != null
          ? List<String>.from(json['specialties'])
          : null,
      role: json['role'] == 'writer' ? UserRole.writer : UserRole.seeker,
      rating: json['rating']?.toDouble(),
      completedProjects: json['completedProjects'],
      writerDetails: json['writerDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo': photo,
      'bio': bio,
      'specialties': specialties,
      'role': role == UserRole.writer ? 'writer' : 'seeker',
      'rating': rating,
      'completedProjects': completedProjects,
      'writerDetails': writerDetails,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photo,
    String? bio,
    List<String>? specialties,
    UserRole? role,
    double? rating,
    int? completedProjects,
    Map<String, dynamic>? writerDetails,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      bio: bio ?? this.bio,
      specialties: specialties ?? this.specialties,
      role: role ?? this.role,
      rating: rating ?? this.rating,
      completedProjects: completedProjects ?? this.completedProjects,
      writerDetails: writerDetails ?? this.writerDetails,
    );
  }
}

class WriterDetails {
  final double pageRate;
  final bool isAvailable;
  final List<String> subjects;
  final int totalEarnings;
  final List<String> sampleWork;

  WriterDetails({
    required this.pageRate,
    required this.isAvailable,
    required this.subjects,
    required this.totalEarnings,
    required this.sampleWork,
  });

  factory WriterDetails.fromJson(Map<String, dynamic> json) {
    return WriterDetails(
      pageRate: json['pageRate'].toDouble(),
      isAvailable: json['isAvailable'],
      subjects: List<String>.from(json['subjects']),
      totalEarnings: json['totalEarnings'],
      sampleWork: List<String>.from(json['sampleWork']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageRate': pageRate,
      'isAvailable': isAvailable,
      'subjects': subjects,
      'totalEarnings': totalEarnings,
      'sampleWork': sampleWork,
    };
  }
}

enum UserRole {
  seeker,
  writer,
}