import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import '../../models/login_response_model.dart';

class AuthApiService {

  // ================= LOGIN =================

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {

    final response = await ApiClient.dio.post(
      Endpoints.login,
      data: {
        "email": email,
        "password": password,
      },
    );

    return LoginResponseModel.fromJson(response.data);
  }

  // ================= REGISTER =================

  Future<void> register({
    required String email,
    required String password,
    required String role,
  }) async {

    await ApiClient.dio.post(
      Endpoints.register,
      data: {
        "email": email,
        "password": password,
        "role": role,
      },
    );
  }
}