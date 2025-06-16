import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/studen_list_model.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:dio/dio.dart';

abstract class StudentListRemoteDataSource {
  const StudentListRemoteDataSource();

  Future<List<StudentListModel>> getStudentList(String className);
}

@LazySingleton(as: StudentListRemoteDataSource)
class StudentListRemoteDataSourceImpl implements StudentListRemoteDataSource {
  const StudentListRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<List<StudentListModel>> getStudentList(String className) async {
    try {
      logger.i('Fetching student list for class: $className');
      final response = await _dioClient.get<List<dynamic>>(
        EndPoint.getClassInfo,
        queryParameters: {'className': className},
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data!
            .map((e) => StudentListModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        logger.e(
            'Failed to fetch student list. Status: ${response.statusCode}, Response: ${response.data}');
        final String statusCodeString =
            response.statusCode?.toString() ?? '400';
        throw ServerException(
          message: 'Failed to fetch student list',
          statusCode: statusCodeString,
        );
      }
    } on DioException catch (e) {
      logger.e('DioError fetching student list: $e');
      throw ServerException.fromDioException(e);
    } catch (e) {
      logger.e('Unknown error fetching student list: $e');
      throw ServerException(
        message: 'An unknown error occurred while fetching student list',
        statusCode: '500',
      );
    }
  }
}
