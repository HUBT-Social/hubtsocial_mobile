import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/injections/injections.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/datasources/academic_result_remote_data_source.dart';

@module
abstract class AcademicResultModule {
  @lazySingleton
  AcademicResultRemoteDataSource get academicResultRemoteDataSource =>
      AcademicResultRemoteDataSourceImpl(dioClient: getIt());

  // Đã xóa đăng ký trùng lặp của AcademicResultRepoImpl
  // @lazySingleton
  // AcademicResultRepo get academicResultRepo =>
  //     AcademicResultRepoImpl(academicResultRemoteDataSource);

  // Đã xóa đăng ký trùng lặp của GetAcademicResultUseCase
  // @lazySingleton
  // GetAcademicResultUseCase get getAcademicResultUseCase =>
  //     GetAcademicResultUseCase(getIt());
}
