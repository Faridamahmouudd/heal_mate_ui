import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../models/patient_model.dart';

class DoctorApiService {
  Future<int> _getDoctorId() async {
    final savedId = await SecureStorageService.getUserId();
    return int.tryParse(savedId ?? '') ?? 1;
  }

  Future<List<PatientModel>> getMyPatients() async {
    final doctorId = await _getDoctorId();

    final response = await ApiClient.dio.get(
      Endpoints.doctorPatients,
      queryParameters: {
        "doctorId": doctorId,
      },
    );

    final List data = response.data["data"] ?? [];

    return data.map((e) => PatientModel.fromJson(e)).toList();
  }

  Future<List<PatientModel>> searchPatients(String query) async {
    final doctorId = await _getDoctorId();

    final response = await ApiClient.dio.get(
      Endpoints.doctorSearchPatients,
      queryParameters: {
        "doctorId": doctorId,
        "search": query,
      },
    );

    final List data = response.data["data"] ?? [];

    return data.map((e) => PatientModel.fromJson(e)).toList();
  }
}