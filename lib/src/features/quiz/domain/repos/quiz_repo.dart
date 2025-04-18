import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';

import '../../data/models/quiz_response_model.dart';

abstract class QuizRepo {
  const QuizRepo();
  ResultFuture<List<QuizResponseModel>> fetchQuiz({
    required int page,
  });
}
