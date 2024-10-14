import 'package:bloc/bloc.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/add_product_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/delete_product_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/get_all_products_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/get_product_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/get_region_products_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/update_product_use_case.dart';
import 'package:meta/meta.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final DeleteRegionProductUseCase deleteRegionProductUseCase;
  final GetAllRegionProductsUseCase getAllRegionProductsUseCase;
  final GetRegionProductUseCase getRegionProductUseCase;
  final GetRegionProductsUseCase getRegionProductsUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  ProductCubit(
      this.deleteRegionProductUseCase,
      this.getAllRegionProductsUseCase,
      this.getRegionProductUseCase,
      this.getRegionProductsUseCase,
      this.addProductUseCase,
      this.updateProductUseCase)
      : super(
          ProductInitial(),
        );

  Future<void> getAllProducts() async {
    emit(GetAllProductsLoadingState());
    var result = await getAllRegionProductsUseCase.call();
    result.fold(
      (failure) {
        emit(GetAllProductsFailureState(errorMsg: failure.message));
      },
      (products) {
        emit(GetAllProductsSuccessState(products: products));
      },
    );
  }

  Future<void> getProduct({required int productId}) async {
    emit(GetProductLoadingState());
    var result = await getRegionProductUseCase.call(productId: productId);
    result.fold(
      (failure) {
        emit(GetProductFailureState(errorMsg: failure.message));
      },
      (product) {
        emit(GetProductSuccessState(product: product));
      },
    );
  }

  Future<void> getRegionProducts({required int regionId}) async {
    emit(GetRegionProductsLoadingState());
    var result = await getRegionProductsUseCase.call(regionId: regionId);
    result.fold(
      (failure) {
        emit(GetRegionProductsFailureState(errorMsg: failure.message));
      },
      (products) {
        emit(GetRegionProductsSuccessState(regionProducts: products));
      },
    );
  }

  Future<void> deleteProduct({required int productId}) async {
    emit(DeleteProductLoadingState());
    var result = await deleteRegionProductUseCase.call(productId: productId);
    result.fold(
      (failure) {
        emit(DeleteProductFailureState(errorMsg: failure.message));
      },
      (unit) {
        emit(DeleteProductSuccessState());
      },
    );
  }

  Future<void> addProduct({required List<RegionProductModel> products}) async {
    emit(AddProductLoadingState());
    var result = await addProductUseCase.call(products: products);
    result.fold(
      (failure) {
        emit(AddProductFailureState(errorMsg: failure.message));
      },
      (unit) {
        emit(AddProductSuccessState());
      },
    );
  }

  Future<void> updateProduct({required RegionProductModel product}) async {
    emit(UpdateProductLoadingState());
    var result = await updateProductUseCase.call(product: product);
    result.fold(
      (failure) {
        emit(UpdateProductFailureState(errorMsg: failure.message));
      },
      (unit) {
        emit(UpdateProductSuccessState());
      },
    );
  }
}
