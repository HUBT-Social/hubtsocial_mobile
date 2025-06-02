part of 'module_bloc.dart';

sealed class GetModuleState extends Equatable {
  const GetModuleState();

  @override
  List<Object> get props => [];
}

final class ModuleProfileInitial extends GetModuleState {}

class ModuleProfileLoading extends GetModuleState {}

class RoomMemberLoaded extends GetModuleState {
  const RoomMemberLoaded(this.roomInfo);
  final RoomInfoModel roomInfo;

  @override
  List<Object> get props => [];
}

class FetchRoomLoaded extends GetModuleState {
  const FetchRoomLoaded(this.listMessage);
  final List<Message> listMessage;

  @override
  List<Object> get props => [];
}

class UpdatedModuleProfile extends GetModuleState {}

class ModuleLoadedError extends GetModuleState {
  const ModuleLoadedError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
