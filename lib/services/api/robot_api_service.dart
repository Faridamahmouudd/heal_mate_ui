import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';

class RobotApiService {
  Future<Map<String, dynamic>> sendCommand({
    required int doctorId,
    int? patientId,
    required String command,
    String? parameters,
  }) async {
    final response = await ApiClient.dio.post(
      Endpoints.robotCommand,
      data: {
        "doctorId": doctorId,
        "patientId": patientId,
        "command": command,
        "parameters": parameters ?? "",
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> getStatus() async {
    final response = await ApiClient.dio.get(Endpoints.robotStatus);
    return Map<String, dynamic>.from(response.data);
  }

  Future<List<dynamic>> getLogs({
    int? doctorId,
    int? patientId,
  }) async {
    final response = await ApiClient.dio.get(
      Endpoints.robotLogs,
      queryParameters: {
        if (doctorId != null) "doctorId": doctorId,
        if (patientId != null) "patientId": patientId,
      },
    );

    return response.data is List ? response.data : [];
  }
}