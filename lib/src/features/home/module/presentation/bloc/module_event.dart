part of 'module_bloc.dart';

sealed class ModuleEvent extends Equatable {
  const ModuleEvent();

  @override
  List<Object> get props => [];
}

class FetchModuleEvent extends ModuleEvent {
  const FetchModuleEvent({
    required this.roomId,
    required this.page,
  });

  final String roomId;
  final int page;

  @override
  List<String> get props => [roomId];
}

class GetRoomMemberEvent extends ModuleEvent {
  const GetRoomMemberEvent({
    required this.roomId,
  });

  final String roomId;

  @override
  List<String> get props => [roomId];
}
