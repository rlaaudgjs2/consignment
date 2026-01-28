import 'package:consignment/core/data/network/api_client.dart';

abstract class LocationRemoteDataSource {
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  });
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final ApiClient _api;

  LocationRemoteDataSourceImpl(this._api);

  @override
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    await _api.post(
      '/api/v1/transporter/location/update',
      data: <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
      },
    );
  }
}
