// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:hubtsocial_mobile/src/features/user/domain/entities/user.dart';
// import 'package:hubtsocial_mobile/src/features/user/data/user_repository.dart';

// // Events
// abstract class EditProfileEvent extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class UpdateFirstName extends EditProfileEvent {
//   final String firstName;

//   UpdateFirstName(this.firstName);

//   @override
//   List<Object?> get props => [firstName];
// }

// class UpdateLastName extends EditProfileEvent {
//   final String lastName;

//   UpdateLastName(this.lastName);

//   @override
//   List<Object?> get props => [lastName];
// }

// class UpdateGender extends EditProfileEvent {
//   final Gender gender;

//   UpdateGender(this.gender);

//   @override
//   List<Object?> get props => [gender];
// }

// class UpdateDateOfBirth extends EditProfileEvent {
//   final DateTime dateOfBirth;

//   UpdateDateOfBirth(this.dateOfBirth);

//   @override
//   List<Object?> get props => [dateOfBirth];
// }

// class SaveProfileChanges extends EditProfileEvent {}

// // States
// abstract class EditProfileState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class EditProfileInitial extends EditProfileState {}

// class EditProfileLoading extends EditProfileState {}

// class EditProfileSuccess extends EditProfileState {}

// class EditProfileFailure extends EditProfileState {
//   final String error;

//   EditProfileFailure(this.error);

//   @override
//   List<Object?> get props => [error];
// }

// // BLoC
// class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
//   final UserRepository userRepository;
//   User user;

//   EditProfileBloc({required this.userRepository, required this.user})
//       : super(EditProfileInitial()) {
//     on<UpdateFirstName>((event, emit) {
//       user = user.copyWith(firstName: event.firstName);
//     });

//     on<UpdateLastName>((event, emit) {
//       user = user.copyWith(lastName: event.lastName);
//     });

//     on<UpdateGender>((event, emit) {
//       user = user.copyWith(gender: event.gender);
//     });

//     on<UpdateDateOfBirth>((event, emit) {
//       user = user.copyWith(birthDay: event.dateOfBirth);
//     });

//     on<SaveProfileChanges>((event, emit) async {
//       emit(EditProfileLoading());
//       try {
//         await userRepository.updateUserProfile(user);
//         emit(EditProfileSuccess());
//       } catch (e) {
//         emit(EditProfileFailure(e.toString()));
//       }
//     });
//   }
// }