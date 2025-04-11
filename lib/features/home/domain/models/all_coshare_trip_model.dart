class AllCoShareTripModel {
  final bool? status;
  final List<CoShareTripData>? data;

  AllCoShareTripModel({this.status, this.data});

  factory AllCoShareTripModel.fromJson(Map<String, dynamic> json) {
    return AllCoShareTripModel(
      status: json['status'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CoShareTripData.fromJson(e))
          .toList(),
    );
  }
}

class CoShareTripData {
  final String? id;
  final String? requestNumber;
  final int? isCoShare;
  final int? coShareMaxSeats;
  final String? transportType;
  final ZoneType? zoneType;
  final ServiceLocation? serviceLocation;
  final User? user;
  final List<RequestPlace>? requestPlaces;

  CoShareTripData({
    this.id,
    this.requestNumber,
    this.isCoShare,
    this.coShareMaxSeats,
    this.transportType,
    this.zoneType,
    this.serviceLocation,
    this.user,
    this.requestPlaces,
  });

  factory CoShareTripData.fromJson(Map<String, dynamic> json) {
    return CoShareTripData(
      id: json['id'],
      requestNumber: json['request_number'],
      isCoShare: json['is_co_share'],
      coShareMaxSeats: json['co_share_max_seats'],
      transportType: json['transport_type'],
      zoneType: json['zone_type'] != null
          ? ZoneType.fromJson(json['zone_type'])
          : null,
      serviceLocation: json['service_location'] != null
          ? ServiceLocation.fromJson(json['service_location'])
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      requestPlaces: (json['request_places'] as List<dynamic>?)
          ?.map((e) => RequestPlace.fromJson(e))
          .toList(),
    );
  }
}

class ZoneType {
  final String? id;
  final String? transportType;
  final String? paymentType;
  final Zone? zone;

  ZoneType({this.id, this.transportType, this.paymentType, this.zone});

  factory ZoneType.fromJson(Map<String, dynamic> json) {
    return ZoneType(
      id: json['id'],
      transportType: json['transport_type'],
      paymentType: json['payment_type'],
      zone: json['zone'] != null ? Zone.fromJson(json['zone']) : null,
    );
  }
}

class Zone {
  final String? id;
  final String? name;
  final String? translationDataset;

  Zone({this.id, this.name, this.translationDataset});

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'],
      name: json['name'],
      translationDataset: json['translation_dataset'],
    );
  }
}

class ServiceLocation {
  final String? id;
  final String? name;
  final String? translationDataset;

  ServiceLocation({this.id, this.name, this.translationDataset});

  factory ServiceLocation.fromJson(Map<String, dynamic> json) {
    return ServiceLocation(
      id: json['id'],
      name: json['name'],
      translationDataset: json['translation_dataset'],
    );
  }
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? mobile;
  final String? gender;
  final String? profilePicture;
  final int? country;
  final String? timezone;
  final double? currentLat;
  final double? currentLng;

  User({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.gender,
    this.profilePicture,
    this.country,
    this.timezone,
    this.currentLat,
    this.currentLng,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      gender: json['gender'],
      profilePicture: json['profile_picture'],
      country: json['country'],
      timezone: json['timezone'],
      currentLat: (json['current_lat'] as num?)?.toDouble(),
      currentLng: (json['current_lng'] as num?)?.toDouble(),
    );
  }
}

class RequestPlace {
  final int? id;
  final double? pickLat;
  final double? pickLng;
  final double? dropLat;
  final double? dropLng;
  final String? requestPath;
  final String? pickAddress;
  final String? dropAddress;
  final String? pickupPocName;
  final String? dropPocName;
  final String? pickupPocMobile;
  final String? dropPocMobile;
  final String? pickupPocInstruction;
  final String? dropPocInstruction;
  final String? createdAt;
  final String? updatedAt;

  RequestPlace({
    this.id,
    this.pickLat,
    this.pickLng,
    this.dropLat,
    this.dropLng,
    this.requestPath,
    this.pickAddress,
    this.dropAddress,
    this.pickupPocName,
    this.dropPocName,
    this.pickupPocMobile,
    this.dropPocMobile,
    this.pickupPocInstruction,
    this.dropPocInstruction,
    this.createdAt,
    this.updatedAt,
  });

  factory RequestPlace.fromJson(Map<String, dynamic> json) {
    return RequestPlace(
      id: json['id'],
      pickLat: (json['pick_lat'] as num?)?.toDouble(),
      pickLng: (json['pick_lng'] as num?)?.toDouble(),
      dropLat: (json['drop_lat'] as num?)?.toDouble(),
      dropLng: (json['drop_lng'] as num?)?.toDouble(),
      requestPath: json['request_path'],
      pickAddress: json['pick_address'],
      dropAddress: json['drop_address'],
      pickupPocName: json['pickup_poc_name'],
      dropPocName: json['drop_poc_name'],
      pickupPocMobile: json['pickup_poc_mobile'],
      dropPocMobile: json['drop_poc_mobile'],
      pickupPocInstruction: json['pickup_poc_instruction'],
      dropPocInstruction: json['drop_poc_instruction'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
