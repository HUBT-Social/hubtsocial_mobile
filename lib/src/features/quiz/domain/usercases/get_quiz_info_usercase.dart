import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/data/domain/usecases/usecases.dart';
import '../../data/models/quiz_info_response_model.dart';
import '../../data/models/quiz_response_model.dart';
import '../repos/quiz_repo.dart';

@LazySingleton()
class GetQuizInfoUserCase extends UseCaseWithParams<void, GetQuizInfoParams> {
  const GetQuizInfoUserCase(this._repo);
  final QuizRepo _repo;
  @override
  ResultFuture<QuizInfoResponseModel> call(GetQuizInfoParams param) =>
      _repo.getQuiz(id: param.id);
}

class GetQuizInfoParams extends Equatable {
  const GetQuizInfoParams({
    required this.id,
  });
  const GetQuizInfoParams.empty() : id = "";
  final String id;

  @override
  List<String> get props => [id];
}
