class UserModel {
  final String uid;
  final String email;
  final String? name;
  final DateTime? birthDate;

  UserModel({required this.uid, required this.email, this.name, this.birthDate});

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'],
      name: map['name'],
      birthDate: map['birthDate'] != null && map['birthDate'].isNotEmpty
          ? DateTime.parse(map['birthDate'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name ?? '',
      'birthDate': birthDate?.toIso8601String() ?? '',
    };
  }
}