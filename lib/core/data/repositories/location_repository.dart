import 'package:consignment/core/data/datasources/location_remote_data_source.dart';

class LocationRepository {
  final LocationRemoteDataSource _remote;

  LocationRepository({required LocationRemoteDataSource remote})
      : _remote = remote;

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) {
    return _remote.updateLocation(latitude: latitude, longitude: longitude);
  }
}
