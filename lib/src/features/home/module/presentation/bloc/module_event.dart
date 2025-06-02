part of 'module_bloc.dart';

sealed class ModuleEvent extends Equatable {
  const ModuleEvent();

  @override
  List<Object> get props => [];
}

class GetModuleEvent extends ModuleEvent {
  const GetModuleEvent();

  @override
  List<String> get props => [];
}
