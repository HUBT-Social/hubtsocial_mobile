import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/data/domain/usecases/usecases.dart';
import '../../data/models/quiz_response_model.dart';
import '../repos/quiz_repo.dart';

@LazySingleton()
class FetchQuizUserCase extends UseCaseWithParams<void, FetchQuizParams> {
  const FetchQuizUserCase(this._repo);
  final QuizRepo _repo;
  @override
  ResultFuture<List<QuizResponseModel>> call(FetchQuizParams param) =>
      _repo.fetchQuiz(page: param.page);
}

class FetchQuizParams extends Equatable {
  const FetchQuizParams({
    required this.page,
  });
  const FetchQuizParams.empty() : page = 0;
  final int page;

  @override
  List<String> get props => [page.toString()];
}
