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


  String jsonString = '''[{"order":4,"id":4,"screen":"user","title":"Support","onboarding_image":"assets/images/onboardOne.png","description":"Embark on your journey with confidence, knowing that our commitment to your satisfaction is unwavering","active":1},{"order":1,"id":1,"screen":"user","title":"Assurance","onboarding_image":"assets/images/onboardTwo.png","description":"Customer safety first, Always and forever our pledge, Your well-being, our priority, With you every step, edge to edge.","active":1},{"order":2,"id":2,"screen":"user","title":"Clarity","onboarding_image":"assets/images/onboardThree.png","description":"Fair pricing, crystal clear, Your trust, our promise sincere. With us, youll find no hidden fee, Transparency is our guarantee.","active":1},{"order":3,"id":3,"screen":"user","title":"Intuitive","onboarding_image":"assets/images/onboardTwo.png","description":"Seamless journeys, Just a tap away, Explore hassle-free, Every step of the way.","active":1}]''';

  List<dynamic> onBoardingDataJson = json.decode(jsonString);

