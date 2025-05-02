class MyCoshareRequestModel {
  bool? status;
  int? totalcount;
  List<MyCoshareRequestData>? data;

  MyCoshareRequestModel({this.status, this.totalcount, this.data});

  MyCoshareRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalcount = json['totalcount'];
    if (json['data'] != null) {
      data = <MyCoshareRequestData>[];
      json['data'].forEach((v) {
        data!.add(MyCoshareRequestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['status'] = status;
    result['totalcount'] = totalcount;
    if (data != null) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class MyCoshareRequestData {
  UserModel? coShareUser;
  UserModel? requestUser;
  TripRequest? tripRequest;
  CoShareRequest? coShareRequest;

  MyCoshareRequestData({
    this.coShareUser,
    this.requestUser, 
    this.tripRequest,
    this.coShareRequest,
  });

  MyCoshareRequestData.fromJson(Map<String, dynamic> json) {
    coShareUser = json['co_share_user'] != null
        ? UserModel.fromJson(json['co_share_user'])
        : null;
    requestUser = json['request_user'] != null
        ? UserModel.fromJson(json['request_user'])
        : null;
    tripRequest = json['trip_request'] != null
        ? TripRequest.fromJson(json['trip_request'])
        : null;
    coShareRequest = json['co_share_request'] != null
        ? CoShareRequest.fromJson(json['co_share_request'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    if (coShareUser != null) {
      result['co_share_user'] = coShareUser!.toJson();
    }
    if (requestUser != null) {
      result['request_user'] = requestUser!.toJson();
    }
    if (tripRequest != null) {
      result['trip_request'] = tripRequest!.toJson();
    }
    if (coShareRequest != null) {
      result['co_share_request'] = coShareRequest!.toJson();
    }
    return result;
  }
}

class UserModel {
  int? id;
  String? name;
  String? mobile;
  String? profilePicture;
  double? currentLat;
  double? currentLng;

  UserModel({
    this.id,
    this.name,
    this.mobile,
    this.profilePicture,
    this.currentLat,
    this.currentLng,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    profilePicture = json['profile_picture'];
    currentLat = json['current_lat']?.toDouble();
    currentLng = json['current_lng']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'profile_picture': profilePicture,
      'current_lat': currentLat,
      'current_lng': currentLng,
    };
  }
}

class TripRequest {
  String? id;
  String? pickupAddress;
  String? destinationAddress;
  double? pickupLat;
  double? pickupLng;
  double? destinationLat;
  double? destinationLng;
  dynamic amount;
  String? status;

  TripRequest({
    this.id,
    this.pickupAddress,
    this.destinationAddress,
    this.pickupLat,
    this.pickupLng,
    this.destinationLat,
    this.destinationLng,
    this.amount,
    this.status,
  });

  TripRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pickupAddress = json['pickup_address'];
    destinationAddress = json['destination_address'];
    pickupLat = json['pickup_lat']?.toDouble();
    pickupLng = json['pickup_lng']?.toDouble();
    destinationLat = json['destination_lat']?.toDouble();
    destinationLng = json['destination_lng']?.toDouble();
    amount = json['amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickup_address': pickupAddress,
      'destination_address': destinationAddress,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'destination_lat': destinationLat,
      'destination_lng': destinationLng,
      'amount': amount,
      'status': status,
    };
  }
}

class CoShareRequest {
  int? id;
  String? tripRequestId;
  int? userId;
  String? pickupAddress;
  String? destinationAddress;
  double? pickupLat;
  double? pickupLng;
  double? destinationLat;
  double? destinationLng;
  String? proposedAmount;
  String? status;
   String? negotiationAmount;


  CoShareRequest({
    this.id,
    this.tripRequestId,
    this.userId,
    this.pickupAddress,
    this.destinationAddress,
    this.pickupLat,
    this.pickupLng,
    this.destinationLat,
    this.destinationLng,
    this.proposedAmount,
    this.status,
    this.negotiationAmount,
  });

  CoShareRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripRequestId = json['trip_request_id'];
    userId = json['user_id'];
    pickupAddress = json['pickup_address'];
    destinationAddress = json['destination_address'];
    pickupLat = json['pickup_lat']?.toDouble();
    pickupLng = json['pickup_lng']?.toDouble();
    destinationLat = json['destination_lat']?.toDouble();
    destinationLng = json['destination_lng']?.toDouble();
    proposedAmount = json['proposed_amount'];
    status = json['status'];
    negotiationAmount = json['negotiation_amount'];

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_request_id': tripRequestId,
      'user_id': userId,
      'pickup_address': pickupAddress,
      'destination_address': destinationAddress,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'destination_lat': destinationLat,
      'destination_lng': destinationLng,
      'proposed_amount': proposedAmount,
      'status': status,
      'negotiation_amount': negotiationAmount,
    };
  }
}
