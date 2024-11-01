import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';

abstract class RegionRemoteDataSource {
  Future<List<RegionModel>> getAllRegions();
  Future<RegionModel> getRegion({required int regionId});
  Future<void> deleteRegion({required int regionId});
  Future<void> addRegion({required List<RegionModel> regions});
  Future<void> updateRegion({required RegionModel region});
}

class RegionRemoteDataSourceImpl extends RegionRemoteDataSource {
  final Api api;
  RegionRemoteDataSourceImpl({
    required this.api,
  });
  @override
  Future<void> addRegion({required List<RegionModel> regions}) async {
    List<dynamic> jsonRegions =
        regions.map((region) => region.toMap()).toList();
    await api.post2(
        endPoint: 'api/regions', body: jsonRegions, token: jwtToken);
  }

  @override
  Future<void> deleteRegion({required int regionId}) async {
    await api.delete(endPoint: 'api/regions/$regionId');
  }

  @override
  Future<List<RegionModel>> getAllRegions() async {
    List<RegionModel> regions = [];
    List result;

    result = await api.get(endPoint: 'api/regions', token: jwtToken);

    for (var regionData in result) {
      regions.add(RegionModel.fromMap(regionData));
    }
    return regions;
  }

  @override
  Future<RegionModel> getRegion({required int regionId}) async {
    RegionModel regionModel;
    var res = await api.get(endPoint: 'api/regions/$regionId', token: jwtToken);
    regionModel = RegionModel.fromJson(res);
    return regionModel;
  }

  @override
  Future<void> updateRegion({required RegionModel region}) async {
    await api.put(
        endPoint: 'api/regions/${region.id}',
        body: region.toMap(),
        token: jwtToken);
  }
}
