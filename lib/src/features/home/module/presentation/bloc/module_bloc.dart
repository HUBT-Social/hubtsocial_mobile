import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/module_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usercases/get_module_usercase.dart';

part 'module_event.dart';
part 'module_state.dart';

@Injectable()
class ModuleBloc extends Bloc<ModuleEvent, ModuleState> {
  ModuleBloc({
    required GetModuleUserCase getModule,
  })  : _getModule = getModule,
        super(ModuleInitial()) {
    on<ModuleEvent>((event, emit) {
      emit(ModuleLoading());
    });
    on<GetModuleEvent>(_getModuleHandler);
  }

  final GetModuleUserCase _getModule;

  Future<void> _getModuleHandler(
    GetModuleEvent event,
    Emitter<ModuleState> emit,
  ) async {
    final result = await _getModule(GetModuleParams());
    result.fold((failure) => emit(ModuleLoadedError(failure.message)),
        (response) => emit(ModuleLoaded(response)));
  }
}
