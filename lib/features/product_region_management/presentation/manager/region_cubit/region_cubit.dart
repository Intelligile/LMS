import 'package:bloc/bloc.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';
import 'package:lms/features/product_region_management/domain/use_case/region_use_cases/add_region_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/region_use_cases/delete_region_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/region_use_cases/get_all_regions_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/region_use_cases/get_region_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/region_use_cases/update_region_use_case.dart';
import 'package:meta/meta.dart';

part 'region_state.dart';

class RegionCubit extends Cubit<RegionState> {
  final AddRegionUseCase addRegionUseCase;
  final DeleteRegionUseCase deleteRegionUseCase;
  final GetAllRegionsUseCase getAllRegionsUseCase;
  final GetRegionUseCase getRegionUseCase;
  final UpdateRegionUseCase updateRegionUseCase;
  RegionCubit(
      this.addRegionUseCase,
      this.deleteRegionUseCase,
      this.getAllRegionsUseCase,
      this.getRegionUseCase,
      this.updateRegionUseCase)
      : super(RegionInitial());
  Future<void> getAllRegions() async {
    emit(GetAllRegionsLoadingState());
    var result = await getAllRegionsUseCase.call();
    result.fold(
      (failure) {
        emit(GetAllRegionsFailureState(errorMsg: failure.message));
      },
      (regions) {
        emit(GetAllRegionsSuccessState(regions: regions));
      },
    );
  }

  Future<void> updateRegion({required RegionModel region}) async {
    emit(UpdateRegionLoadingState());
    var result = await updateRegionUseCase.call(region: region);
    result.fold(
      (failure) {
        emit(UpdateRegionFailureState(errorMsg: failure.message));
      },
      (unit) {
        emit(UpdateRegionSuccessState());
      },
    );
  }

  Future<void> addRegion({required List<RegionModel> regions}) async {
    emit(AddRegionLoadingState());
    var result = await addRegionUseCase.call(regions: regions);
    result.fold(
      (failure) {
        emit(AddRegionFailureState(errorMsg: failure.message));
      },
      (unit) {
        emit(AddRegionSuccessState());
      },
    );
  }

  Future<void> deleteRegion({required int regionId}) async {
    emit(DeleteRegionLoadingState());
    var result = await deleteRegionUseCase.call(regionId: regionId);
    result.fold(
      (failure) {
        emit(DeleteRegionFailureState(errorMsg: failure.message));
      },
      (unit) {
        emit(DeleteRegionSuccessState());
      },
    );
  }
}
