import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/failure.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/datasources/student_list_remote_data_source.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/studen_list_model.dart';

abstract class StudentListRepository {
  const StudentListRepository();

  ResultFuture<List<StudentListModel>> getStudentList(String className);
}

@LazySingleton(as: StudentListRepository)
class StudentListRepositoryImpl implements StudentListRepository {
  const StudentListRepositoryImpl(this._remoteDataSource);

  final StudentListRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<StudentListModel>> getStudentList(String className) async {
    try {
      final result = await _remoteDataSource.getStudentList(className);
      return Right(result);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
