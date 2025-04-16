class IncomingCoShareModel {
  bool? status;
  List<IncomingCoShareData>? data;

  IncomingCoShareModel({this.status, this.data});

  factory IncomingCoShareModel.fromJson(Map<String, dynamic> json) {
    return IncomingCoShareModel(
      status: json['status'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => IncomingCoShareData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class IncomingCoShareData {
  IncomingCoShareUser? user;
  IncomingCoShareTrip? trip;
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
  int? totalRequests;

  IncomingCoShareData({
    this.user,
    this.trip,
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
    this.totalRequests,
  });

  factory IncomingCoShareData.fromJson(Map<String, dynamic> json) {
    return IncomingCoShareData(
      user: json['user'] != null ? IncomingCoShareUser.fromJson(json['user']) : null,
      trip: json['trip'] != null ? IncomingCoShareTrip.fromJson(json['trip']) : null,
      id: json['id'],
      tripRequestId: json['trip_request_id'],
      userId: json['user_id'],
      pickupAddress: json['pickup_address'],
      destinationAddress: json['destination_address'],
      pickupLat: (json['pickup_lat'] as num?)?.toDouble(),
      pickupLng: (json['pickup_lng'] as num?)?.toDouble(),
      destinationLat: (json['destination_lat'] as num?)?.toDouble(),
      destinationLng: (json['destination_lng'] as num?)?.toDouble(),
      proposedAmount: json['proposed_amount'],
      status: json['status'],
      totalRequests: json['total_requests'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'trip': trip?.toJson(),
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
      'total_requests': totalRequests,
    };
  }
}

class IncomingCoShareUser {
  int? id;
  String? name;
  String? mobile;
  String? profilePicture;

  IncomingCoShareUser({this.id, this.name, this.mobile, this.profilePicture});

  factory IncomingCoShareUser.fromJson(Map<String, dynamic> json) {
    return IncomingCoShareUser(
      id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'profile_picture': profilePicture,
    };
  }
}

class IncomingCoShareTrip {
  dynamic coShareMaxSeats;

  IncomingCoShareTrip({this.coShareMaxSeats});

  factory IncomingCoShareTrip.fromJson(Map<String, dynamic> json) {
    return IncomingCoShareTrip(
      coShareMaxSeats: json['co_share_max_seats'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'co_share_max_seats': coShareMaxSeats,
    };
  }
}
