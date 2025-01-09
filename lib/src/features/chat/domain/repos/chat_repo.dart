import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/chat_response_model.dart';

abstract class ChatRepo {
  const ChatRepo();
  ResultFuture<List<ChatResponseModel>> fetchChat({
    required int page,
  });
}
