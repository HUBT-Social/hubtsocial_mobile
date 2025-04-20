import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/quiz/data/models/quiz_info_response_model.dart';

import '../../data/models/quiz_response_model.dart';

abstract class QuizRepo {
  const QuizRepo();
  ResultFuture<List<QuizResponseModel>> fetchQuiz({
    required int page,
  });
  ResultFuture<QuizInfoResponseModel> getQuiz({
    required String id,
  });
}
