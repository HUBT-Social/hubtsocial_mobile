import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/typedefs.dart';
import '../repos/auth_repo.dart';

@LazySingleton()
class InformationUserCase
    extends UseCaseWithParams<void, InformationUserParams> {
  const InformationUserCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(InformationUserParams param) => _repo.informationUser(
        firstName: param.firstName,
        lastName: param.lastName,
        birtOfDate: param.birtOfDate,
        gender: param.gender,
        phoneNumber: param.phoneNumber,
      );
}

class InformationUserParams extends Equatable {
  const InformationUserParams({
    required this.firstName,
    required this.lastName,
    required this.birtOfDate,
    required this.gender,
    required this.phoneNumber,
  });
  const InformationUserParams.empty(this.firstName, this.lastName,
      this.birtOfDate, this.gender, this.phoneNumber);
  final String firstName;
  final String lastName;
  final String birtOfDate;
  final String gender;
  final String phoneNumber;

  @override
  List<Object?> get props =>
      [firstName, lastName, birtOfDate, gender, phoneNumber];
}
