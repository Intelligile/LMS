part of 'region_cubit.dart';

@immutable
sealed class RegionState {}

final class RegionInitial extends RegionState {}

final class GetAllRegionsLoadingState extends RegionState {}

final class GetAllRegionsFailureState extends RegionState {
  final String errorMsg;

  GetAllRegionsFailureState({required this.errorMsg});
}

final class GetAllRegionsSuccessState extends RegionState {
  final List<RegionModel> regions;

  GetAllRegionsSuccessState({required this.regions});
}

//------------------
final class DeleteRegionLoadingState extends RegionState {}

final class DeleteRegionFailureState extends RegionState {
  final String errorMsg;

  DeleteRegionFailureState({required this.errorMsg});
}

final class DeleteRegionSuccessState extends RegionState {}

//------------------
final class AddRegionLoadingState extends RegionState {}

final class AddRegionFailureState extends RegionState {
  final String errorMsg;

  AddRegionFailureState({required this.errorMsg});
}

final class AddRegionSuccessState extends RegionState {}

//------------------
final class UpdateRegionLoadingState extends RegionState {}

final class UpdateRegionFailureState extends RegionState {
  final String errorMsg;

  UpdateRegionFailureState({required this.errorMsg});
}

final class UpdateRegionSuccessState extends RegionState {}
