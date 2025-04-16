import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kororyde_user/features/home/domain/models/all_coshare_trip_model.dart';
import 'package:kororyde_user/features/home/domain/models/incoming_coshare_request_model.dart';

import '../../../../core/network/exceptions.dart';
import '../../../../core/network/network.dart';
import '../../../account/domain/models/history_model.dart';
import '../models/recent_routes_model.dart';
import '../models/stop_address_model.dart';
import '../models/user_details_model.dart';
import 'home_repo.dart';
import '../../data/repository/home_api.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApi _homeApi;

  HomeRepositoryImpl(this._homeApi);

  // UserDetailData
  @override
  Future<Either<Failure, UserDetailResponseModel>> getUserDetails(
      {String? requestId}) async {
    UserDetailResponseModel userDetailsResponseModel;
    try {
      Response response =
          await _homeApi.getUserDetailsApi(requestId: requestId);
      log("response res----:${requestId}");
      // log("response res----:${response}");
      // //printWrapped('Get User Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else if (response.statusCode == 429) {
          return Left(GetDataFailure(message: 'Too many attempts'));
        } else {
          userDetailsResponseModel =
              UserDetailResponseModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(userDetailsResponseModel);
  }

  @override
  Future<Either<Failure, AllCoShareTripModel>> getAllCoShareTrip(
      {String? requestId}) async {
    AllCoShareTripModel allCoshareTripModel;
    try {
      Response response = await _homeApi.getAllCoShareTripApi();

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else if (response.statusCode == 429) {
          return Left(GetDataFailure(message: 'Too many attempts'));
        } else {
          allCoshareTripModel = AllCoShareTripModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(allCoshareTripModel);
  }

  @override
  Future<Either<Failure, IncomingCoShareModel>> getIncomingCoShareRequest(
      {String? requestId}) async {
    IncomingCoShareModel icomingResponseModel;
    try {
      Response response = await _homeApi.getIncomingCoShareRequestApi();

      // log("--icomin response:${response.data}");

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else if (response.statusCode == 429) {
          return Left(GetDataFailure(message: 'Too many attempts'));
        } else {
          icomingResponseModel = IncomingCoShareModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(icomingResponseModel);
  }

  @override
  Future<Either<Failure, dynamic>> getAutoCompletePlaces({
    required String input,
    required String mapType,
    required String? countryCode,
    required String enbleContryRestrictMap,
    required LatLng currentLatLng,
  }) async {
    List<dynamic> placesResponse = [];
    try {
      final response = await _homeApi.getAutocompletePlaces(
          countryCode: countryCode,
          enbleContryRestrictMap: enbleContryRestrictMap,
          input: input,
          mapType: mapType,
          currentLatLng: currentLatLng);
      //printWrapped('Places Response : $response');
      if (mapType == 'google_map') {
        for (var element in response.data["suggestions"]) {
          placesResponse.add({
            'place_id': element['placePrediction']['placeId'],
            'description': element['placePrediction']['text']['text'],
            'lat': '',
            'lon': '',
            'display_name': element['placePrediction']['structuredFormat']
                ['mainText']['text'],
          });
        }
      } else {
        for (var element in response) {
          placesResponse.add(element);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(placesResponse);
  }

  @override
  Future<Either<Failure, dynamic>> joinACoShareTrip({
    required String tripRequestId,
    required String pickupAddress,
    required String destinationAddress,
    required dynamic proposedAmount,
    dynamic pickUpLat,
    dynamic pickUpLong,
    dynamic destinationLat,
    dynamic destinationLong,
  }) async {
    dynamic response;
    try {
      response = await _homeApi.joinACoShareTripApi(
        tripRequestId: tripRequestId,
        pickupAddress: pickupAddress,
        destinationAddress: destinationAddress,
        proposedAmount: proposedAmount,
        pickUpLat: pickUpLat,
        pickUpLong: pickUpLong,
        destinationLat: destinationLat,
        destinationLong: destinationLong,
      );
      // log('--join co share  Response : $response');
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(response);
  }

  @override
  Future<Either<Failure, dynamic>> acceptRejectCoshareRequest({
    required String coShareRequestId,
    required String status,
  }) async {
    dynamic response;
    try {
      response = await _homeApi.acceptRejectCoshareRequestApi(
        coShareRequestId: coShareRequestId,
        status: status,
      );
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(response);
  }

  @override
  Future<Either<Failure, dynamic>> sendCoShareOffer({
    required String coShareRequestId,
    required String amount,
  }) async {
    dynamic response;
    try {
      response = await _homeApi.sendCoShareOfferApi(
        coShareRequestId: coShareRequestId,
        amount: amount,
      );
      log('--sendCoShareOfferApi Response : $response');
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(response);
  }

  @override
  Future<Either<Failure, dynamic>> getAutoCompletePlaceLatLng(
      {required String placeId}) async {
    LatLng placesResponse;
    try {
      final response =
          await _homeApi.getAutocompletePlaceLatLng(placeId: placeId);
      //printWrapped('Place LatLng Response : $response');
      placesResponse = response;
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(placesResponse);
  }

  @override
  Future<Either<Failure, dynamic>> getAddressFromLatLng(
      {required double lat,
      required double lng,
      required String mapType}) async {
    String placesResponse = '';
    try {
      final response = await _homeApi.getAddressFromLatLng(
          lat: lat, lng: lng, mapType: mapType);
      //printWrapped('Place Address Response : $response');

      placesResponse = (mapType == 'google_map')
          ? response.data['results'][0]['formatted_address']
          : response.data['display_name'];
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(placesResponse);
  }

  @override
  Future<Either<Failure, HistoryResponseModel>> getOnGoingRides(
      {required String historyFilter}) async {
    HistoryResponseModel onGoingRidesResponse;
    try {
      Response response =
          await _homeApi.getOnGoingRidesApi(historyFilter: historyFilter);
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else {
          onGoingRidesResponse = HistoryResponseModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(onGoingRidesResponse);
  }

  @override
  Future<Either<Failure, RecentRoutesModel>> getRecentRoutes() async {
    RecentRoutesModel recentRoutes;
    try {
      Response response = await _homeApi.getRecentRoutesApi();
      //printWrapped('Recent Routes Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else if (response.statusCode == 429) {
          return Left(GetDataFailure(message: 'Too many attempts'));
        } else {
          recentRoutes = RecentRoutesModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(recentRoutes);
  }

  @override
  Future<Either<Failure, dynamic>> serviceLocationVerify({
    required String rideType,
    required List<AddressModel> address,
  }) async {
    dynamic res;
    try {
      Response response = await _homeApi.serviceLocationVerifyApi(
        rideType: rideType,
        address: address,
      );
      // log('Service Available Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else if (response.statusCode == 429) {
          return Left(GetDataFailure(message: 'Too many attempts'));
        } else {
          res = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(res);
  }
}
