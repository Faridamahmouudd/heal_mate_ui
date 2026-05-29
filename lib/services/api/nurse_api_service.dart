import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';

class NurseApiService {
  Future<List<NurseModel>> getNurses() async {
    final response = await ApiClient.dio.get(Endpoints.nurses);

    final body = response.data;

    List data = [];

    if (body is List) {
      data = body;
    } else if (body is Map<String, dynamic>) {
      data = body["data"] ?? [];
    }

    return data
        .map((e) => NurseModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

class NurseModel {
  final int nurseId;
  final String fullName;

  NurseModel({
    required this.nurseId,
    required this.fullName,
  });

  factory NurseModel.fromJson(Map<String, dynamic> json) {
    return NurseModel(
      nurseId: json["nurseId"] ?? json["id"] ?? 0,
      fullName: json["fullName"] ?? json["name"] ?? "",
    );
  }
}