// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<RegionProductModel>> getAllProducts();
  Future<List<RegionProductModel>> getRegionProducts({required int regionId});
  Future<RegionProductModel> getProduct({required int productId});
  Future<void> deleteProduct({required int productId});
  Future<void> addProduct({required List<RegionProductModel> products});
  Future<void> updateProduct({required RegionProductModel product});
}

class ProductsRemoteDataSourceImpl extends ProductsRemoteDataSource {
  final Api api;
  ProductsRemoteDataSourceImpl({
    required this.api,
  });
  @override
  Future<void> deleteProduct({required int productId}) async {
    await api.delete(endPoint: 'api/products/$productId');
  }

  @override
  Future<List<RegionProductModel>> getAllProducts() async {
    List<RegionProductModel> products = [];
    List result;

    result = await api.get(endPoint: 'api/products', token: jwtToken);

    for (var productData in result) {
      products.add(RegionProductModel.fromMap(productData));
    }

    return products;
  }

  @override
  Future<RegionProductModel> getProduct({required int productId}) async {
    RegionProductModel productModel;
    var res =
        await api.get(endPoint: 'api/products/$productId', token: jwtToken);
    productModel = RegionProductModel.fromJson(res);
    return productModel;
  }

  @override
  Future<List<RegionProductModel>> getRegionProducts(
      {required int regionId}) async {
    List<RegionProductModel> regionProducts = [];
    List result;

    result = await api.get(
        endPoint: 'api/products/region/$regionId', token: jwtToken);

    for (var productData in result) {
      regionProducts.add(RegionProductModel.fromJson(productData));
    }
    return regionProducts;
  }

  @override
  Future<void> addProduct({required List<RegionProductModel> products}) async {
    List<dynamic> jsonProducts =
        products.map((product) => product.toMap()).toList();
    await api.post2(
        endPoint: 'api/products', body: jsonProducts, token: jwtToken);
  }

  @override
  Future<void> updateProduct({required RegionProductModel product}) async {
    await api.put(
        endPoint: 'api/products/${product.id}',
        body: product.toMap(),
        token: jwtToken);
  }
}
