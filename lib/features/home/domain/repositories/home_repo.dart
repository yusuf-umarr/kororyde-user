import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kororyde_user/features/home/domain/models/all_coshare_trip_model.dart';
import 'package:kororyde_user/features/home/domain/models/incoming_coshare_request_model.dart';
import 'package:kororyde_user/features/home/domain/models/my_coshare_request.dart';

import '../../../../core/network/network.dart';
import '../../../account/domain/models/history_model.dart';
import '../models/recent_routes_model.dart';
import '../models/stop_address_model.dart';
import '../models/user_details_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, UserDetailResponseModel>> getUserDetails(
      {String? requestId});
  Future<Either<Failure, AllCoShareTripModel>> getAllCoShareTrip();
  Future<Either<Failure, IncomingCoShareModel>> getIncomingCoShareRequest(); 
  Future<Either<Failure, MyCoshareRequestModel>> getMyCoCoShareRequest(); 

  Future<Either<Failure, dynamic>> getAutoCompletePlaces({
    required String input,
    required String mapType,
    required String? countryCode,
    required String enbleContryRestrictMap,
    required LatLng currentLatLng,
  });
  Future<Either<Failure, dynamic>> joinACoShareTrip({
    required String tripRequestId,
    required String pickupAddress,
    required String destinationAddress,
    required dynamic proposedAmount,
    dynamic pickUpLat,
    dynamic pickUpLong,
    dynamic destinationLat,
    dynamic destinationLong,
  });
  Future<Either<Failure, dynamic>> acceptRejectCoshareRequest({
    required String coShareRequestId,
    required String status,
  
  });
  Future<Either<Failure, dynamic>> sendCoShareOffer({
    required String coShareRequestId,
    required String amount,
  
  });

  Future<Either<Failure, dynamic>> getAutoCompletePlaceLatLng(
      {required String placeId});

  Future<Either<Failure, dynamic>> getAddressFromLatLng({
    required double lat,
    required double lng,
    required String mapType,
  });

  Future<Either<Failure, HistoryResponseModel>> getOnGoingRides(
      {required String historyFilter});

  Future<Either<Failure, RecentRoutesModel>> getRecentRoutes();

  Future<Either<Failure, dynamic>> serviceLocationVerify({
    required String rideType,
    required List<AddressModel> address,
  });
}
