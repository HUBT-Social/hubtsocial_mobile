import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/subject_score_model.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/score_distribution_model.dart';

abstract class AcademicResultRepo {
  const AcademicResultRepo();

  ResultFuture<List<SubjectScoreModel>> getAcademicResult();

  ResultFuture<ScoreDistributionModel> getAcademicResultChart();
}
