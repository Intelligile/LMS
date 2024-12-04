part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class GetAllProductsLoadingState extends ProductState {}

final class GetAllProductsFailureState extends ProductState {
  final String errorMsg;

  GetAllProductsFailureState({required this.errorMsg});
}

final class GetAllProductsSuccessState extends ProductState {
  final List<RegionProductModel> products;

  GetAllProductsSuccessState({required this.products});
}

//------------------

final class GetProductLoadingState extends ProductState {}

final class GetProductFailureState extends ProductState {
  final String errorMsg;

  GetProductFailureState({required this.errorMsg});
}

final class GetProductSuccessState extends ProductState {
  final RegionProductModel product;

  GetProductSuccessState({required this.product});
}

//--------------------
final class DeleteProductLoadingState extends ProductState {}

final class DeleteProductFailureState extends ProductState {
  final String errorMsg;

  DeleteProductFailureState({required this.errorMsg});
}

final class DeleteProductSuccessState extends ProductState {}

//------------------

final class GetRegionProductsLoadingState extends ProductState {}

final class GetRegionProductsFailureState extends ProductState {
  final String errorMsg;

  GetRegionProductsFailureState({required this.errorMsg});
}

final class GetRegionProductsSuccessState extends ProductState {
  final List<RegionProductModel> regionProducts;

  GetRegionProductsSuccessState({required this.regionProducts});
}

//------------------

final class AddProductLoadingState extends ProductState {}

final class AddProductFailureState extends ProductState {
  final String errorMsg;

  AddProductFailureState({required this.errorMsg});
}

final class AddProductSuccessState extends ProductState {}

//------------------

final class UpdateProductLoadingState extends ProductState {}

final class UpdateProductFailureState extends ProductState {
  final String errorMsg;

  UpdateProductFailureState({required this.errorMsg});
}

final class UpdateProductSuccessState extends ProductState {}
