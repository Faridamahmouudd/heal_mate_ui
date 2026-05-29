import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import '../../models/chat_message_model.dart';

class ChatApiService {
  Future<List<ChatMessageModel>> getHistory(int userA, int userB) async {
    final response = await ApiClient.dio.get(
      "${Endpoints.chatHistory}/$userA/$userB",
      queryParameters: {
        "page": 1,
        "pageSize": 50,
      },
    );

    final dynamic body = response.data;

    List messages = [];

    if (body is Map<String, dynamic>) {
      messages = body["messages"] ?? body["data"] ?? [];
    } else if (body is List) {
      messages = body;
    }

    return messages
        .map((e) => ChatMessageModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<ChatMessageModel>> getUserChats(int userId) async {
    final response = await ApiClient.dio.get(
      "${Endpoints.chatUser}/$userId",
    );

    final dynamic body = response.data;

    List chats = [];

    if (body is Map<String, dynamic>) {
      chats = body["data"] ?? body["messages"] ?? [];
    } else if (body is List) {
      chats = body;
    }

    return chats
        .map((e) => ChatMessageModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<ChatMessageModel> sendMessage({
    required int senderId,
    required int receiverId,
    required String message,
  }) async {
    final response = await ApiClient.dio.post(
      Endpoints.chatSend,
      data: {
        "senderId": senderId,
        "receiverId": receiverId,
        "type": "Text",
        "content": message,
        "contentUrl": message,
      },
    );

    final dynamic body = response.data;

    if (body is Map<String, dynamic>) {
      final data = body["data"] ?? body;
      return ChatMessageModel.fromJson(Map<String, dynamic>.from(data));
    }

    return ChatMessageModel(
      messageId: 0,
      senderId: senderId,
      receiverId: receiverId,
      type: "Text",
      contentPath: message,
      sentAt: DateTime.now(),
      isRead: false,
    );
  }

  Future<void> markAsRead(List<int> ids) async {
    if (ids.isEmpty) return;

    await ApiClient.dio.post(
      Endpoints.chatMarkAsRead,
      data: ids,
    );
  }
}