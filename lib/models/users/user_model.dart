class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String phoneNumber;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
    );
  }
}
