import 'package:chatview/chatview.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/features/room_chat/data/models/room_info_model.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/module_response_model.dart';
import '../../domain/usercases/fetch_module_usercase.dart';
import '../../domain/usercases/get_room_member_usercase.dart';

part 'module_event.dart';
part 'module_state.dart';

@Injectable()
class GetModuleBloc extends Bloc<ModuleEvent, GetModuleState> {
  GetModuleBloc({
    required FetchModuleUserCase fetchModule,
    required GetRoomMemberUserCase getModule,
  })  : _fetchModule = fetchModule,
        _getModule = getModule,
        super(ModuleProfileInitial()) {
    on<ModuleEvent>((event, emit) {
      emit(ModuleProfileLoading());
    });
    on<FetchModuleEvent>(_fetchModuleHandler);
    on<GetRoomMemberEvent>(_getRoomMemberHandler);
  }

  final FetchModuleUserCase _fetchModule;
  final GetRoomMemberUserCase _getModule;

  Future<void> _fetchModuleHandler(
    FetchModuleEvent event,
    Emitter<GetModuleState> emit,
  ) async {
    final result = await _fetchModule(FetchModuleParams(roomId: event.roomId));
    result.fold((failure) => emit(ModuleLoadedError(failure.message)),
        (response) => emit(FetchRoomLoaded(response)));
  }

  Future<void> _getRoomMemberHandler(
    GetRoomMemberEvent event,
    Emitter<GetModuleState> emit,
  ) async {
    final result = await _getModule(GetModuleParams(roomId: event.roomId));
    result.fold((failure) => emit(ModuleLoadedError(failure.message)),
        (response) => emit(RoomMemberLoaded(response)));
  }
}
