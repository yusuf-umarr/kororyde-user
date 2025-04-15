import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/network/network.dart';
import '../../../account/domain/models/history_model.dart';
import '../../domain/models/recent_routes_model.dart';
import '../../domain/models/stop_address_model.dart';
import '../../domain/models/user_details_model.dart';
import '../../domain/repositories/home_repo.dart';
import 'dart:developer' as dev;

class HomeUsecase {
  final HomeRepository _homeRepository;

  const HomeUsecase(this._homeRepository);

  Future<Either<Failure, UserDetailResponseModel>> userDetails(
      {String? requestId}) async {
    return _homeRepository.getUserDetails(requestId: requestId);
  }

  Future<Either<Failure, dynamic>> allCoShareTrip() async {
    return _homeRepository.getAllCoShareTrip();
  }
  Future<Either<Failure, dynamic>> getIncomingCoShare() async {
    return _homeRepository.getIncomingCoShareRequest();
  }

  Future<Either<Failure, dynamic>> joinCoShareTrip({
    required String tripRequestId,
    required String pickupAddress,
    required String destinationAddress,
    required dynamic proposedAmount,
    dynamic pickUpLat,
    dynamic pickUpLong,
    dynamic destinationLat,
    dynamic destinationLong,
  }) async {
    return _homeRepository.joinACoShareTrip(
      tripRequestId: tripRequestId,
      pickupAddress: pickupAddress,
      destinationAddress: destinationAddress,
      proposedAmount: proposedAmount,
      pickUpLat:pickUpLat,
      pickUpLong:pickUpLong,
      destinationLat:destinationLat,
      destinationLong:destinationLong,
    );
  }

  Future<Either<Failure, dynamic>> getAutoCompletePlaces({
    required String input,
    required String mapType,
    required String? countryCode,
    required String enbleContryRestrictMap,
    required LatLng currentLatLng,
  }) async {
    return _homeRepository.getAutoCompletePlaces(
        input: input,
        mapType: mapType,
        countryCode: countryCode,
        enbleContryRestrictMap: enbleContryRestrictMap,
        currentLatLng: currentLatLng);
  }

  Future<Either<Failure, dynamic>> getAutoCompletePlaceLatLng(
      {required String placeId}) async {
    return _homeRepository.getAutoCompletePlaceLatLng(placeId: placeId);
  }

  Future<Either<Failure, dynamic>> getAddressFromLatLng({
    required double lat,
    required double lng,
    required String mapType,
  }) async {
    var res = _homeRepository.getAddressFromLatLng(
        lat: lat, lng: lng, mapType: mapType);
    // dev.log(" getAddressFromLatLng:$res");
    return res;
  }

  Future<Either<Failure, HistoryResponseModel>> getOnGoingRides(
      {required String historyFilter}) async {
    return _homeRepository.getOnGoingRides(historyFilter: historyFilter);
  }

  Future<Either<Failure, RecentRoutesModel>> getRecentRoutes() async {
    return _homeRepository.getRecentRoutes();
  }

  Future<Either<Failure, dynamic>> serviceLocationVerify({
    required String rideType,
    required List<AddressModel> address,
  }) async {
    return _homeRepository.serviceLocationVerify(
        rideType: rideType, address: address);
  }
}
