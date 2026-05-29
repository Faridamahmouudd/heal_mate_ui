class LoginResponseModel {
  final String token;
  final String role;
  final int userId;

  LoginResponseModel({
    required this.token,
    required this.role,
    required this.userId,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final user = json["user"] ?? {};

    return LoginResponseModel(
      token: json["token"] ?? "",
      role: json["role"] ?? user["role"] ?? "",
      userId: user["id"] ?? json["userId"] ?? 0,
    );
  }
}