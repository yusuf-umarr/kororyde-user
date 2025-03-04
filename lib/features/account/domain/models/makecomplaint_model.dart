import 'dart:convert';

ComplaintResponseModel complaintResponseModelFromJson(String str) =>
    ComplaintResponseModel.fromJson(json.decode(str));

class ComplaintResponseModel {
  bool success;
  String message;
  List<ComplaintList> data;

  ComplaintResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ComplaintResponseModel.fromJson(Map<String, dynamic> json) =>
      ComplaintResponseModel(
        success: json["success"],
        message: json["message"],
        data: List<ComplaintList>.from(
            json["data"].map((x) => ComplaintList.fromJson(x))),
      );
}

class ComplaintList {
  String id;
  // dynamic companyKey;
  String userType;
  String complaintType;
  String title;
  // int active;
  // DateTime createdAt;
  // DateTime updatedAt;
  // dynamic deletedAt;

  ComplaintList({
    required this.id,
    // required this.companyKey,
    required this.userType,
    required this.complaintType,
    required this.title,
    // required this.active,
    // required this.createdAt,
    // required this.updatedAt,
    // required this.deletedAt,
  });

  factory ComplaintList.fromJson(Map<String, dynamic> json) => ComplaintList(
        id: json["id"],
        // companyKey: json["company_key"],
        userType: json["user_type"],
        complaintType: json["complaint_type"],
        title: json["title"],
        // active: json["active"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        // deletedAt: json["deleted_at"],
      );
}
