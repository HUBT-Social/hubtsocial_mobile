import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/data/domain/usecases/usecases.dart';
import '../../data/models/chat_response_model.dart';
import '../repos/chat_repo.dart';

@LazySingleton()
class FetchChatUserCase extends UseCaseWithParams<void, FetchChatParams> {
  const FetchChatUserCase(this._repo);
  final ChatRepo _repo;
  @override
  ResultFuture<List<ChatResponseModel>> call(FetchChatParams param) =>
      _repo.fetchChat(page: param.page);
}

class FetchChatParams extends Equatable {
  const FetchChatParams({
    required this.page,
  });
  const FetchChatParams.empty() : page = 0;
  final int page;

  @override
  List<String> get props => [page.toString()];
}
