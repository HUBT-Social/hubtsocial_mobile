part of 'module_bloc.dart';

sealed class ModuleState extends Equatable {
  const ModuleState();

  @override
  List<Object> get props => [];
}

final class ModuleInitial extends ModuleState {}

class ModuleLoading extends ModuleState {}

class ModuleLoaded extends ModuleState {
  const ModuleLoaded(this.moduleData);
  final List<ModuleResponseModel> moduleData;

  @override
  List<Object> get props => [];
}

class ModuleLoadedError extends ModuleState {
  const ModuleLoadedError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
