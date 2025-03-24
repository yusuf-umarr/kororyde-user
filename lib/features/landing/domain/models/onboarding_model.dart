import 'dart:convert';

OnBoardingResponseModel onBoardingResponseModelFromJson(String str) =>
    OnBoardingResponseModel.fromJson(json.decode(str));

class OnBoardingResponseModel {
  bool success;
  OnBoardingList data;

  OnBoardingResponseModel({
    required this.success,
    required this.data,
  });

  factory OnBoardingResponseModel.fromJson(Map<String, dynamic> json) =>
      OnBoardingResponseModel(
        success: json["success"],
        data: OnBoardingList.fromJson(json["data"]),
      );
}

class OnBoardingList {
  Onboarding onboarding;

  OnBoardingList({
    required this.onboarding,
  });

  factory OnBoardingList.fromJson(Map<String, dynamic> json) => OnBoardingList(
        onboarding: Onboarding.fromJson(json["onboarding"]),
      );
}

class Onboarding {
  List<OnBoardingData> data;

  Onboarding({
    required this.data,
  });

  factory Onboarding.fromJson(Map<String, dynamic> json) => Onboarding(
        data: List<OnBoardingData>.from(
            json["data"].map((x) => OnBoardingData.fromJson(x))),
      );
}

class OnBoardingData {
  int order;
  int id;
  String screen;
  String title;
  String onboardingImage;
  String description;
  int active;

  OnBoardingData({
    required this.order,
    required this.id,
    required this.screen,
    required this.title,
    required this.onboardingImage,
    required this.description,
    required this.active,
  });

  factory OnBoardingData.fromJson(Map<String, dynamic> json) => OnBoardingData(
        order: json["order"],
        id: json["id"],
        screen: json["screen"],
        title: json["title"],
        onboardingImage: json["onboarding_image"],
        description: json["description"],
        active: json["active"],
      );
}


 String jsonString = '''[{"order":4,"id":4,"screen":"user","title":"Your Ride, Your Way","onboarding_image":"assets/images/onboardOne.png","description":"Book affordable and reliable rides anytime, anywhere. Whether you're commuting to work or heading out with friends, we've got you covered!","active":1},{"order":1,"id":1,"screen":"user","title":"Safe & Secure Rides","onboarding_image":"assets/images/onboardTwo.png","description":"Every ride is tracked, and every driver is verified to ensure your safety. Share your ride details with loved ones for extra peace of mind.","active":1},{"order":2,"id":2,"screen":"user","title":"Pay Your Way","onboarding_image":"assets/images/onboardThree.png","description":"Enjoy multiple payment options, including cash, card, and mobile wallets. Earn rewards and discounts on every ride!","active":1}]''';

  List<dynamic> onBoardingDataJson = json.decode(jsonString);

