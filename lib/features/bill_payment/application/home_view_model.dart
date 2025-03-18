// import 'dart:developer' as dev;
// import 'dart:io';

// import 'package:flutter/material.dart';

// import 'package:geolocator/geolocator.dart';

// enum HomeState { loading, initial, error, success }

// enum RouteState { initial, start, ongoing, ended }

// class HomeViewModel extends ChangeNotifier {
//   HomeState _state = HomeState.initial;
//   HomeState get state => _state;

//   RouteState _routeState = RouteState.initial;
//   RouteState get routeState => _routeState;
//   File imageUpload = File("");
//   File? imageFile;

//   File fileUpload = File("");
//   File? fileData;

//   double currentLat = 0;
//   double currentLong = 0;

//   bool isImageSet = false;

//   String _email = '';
//   String get email => _email;

//   String _busStop = '';
//   String get busStop => _busStop;

//   String _destination = '';
//   String get destination => _destination;

//   String _selectedRoute = '';
//   String get selectedRoute => _selectedRoute;

//   double _busLat = 0;
//   double get busLat => _busLat;

//   double _busLong = 0;
//   double get busLong => _busLong;

//   bool _isDestinationVisible = false;
//   bool get isDestinationVisible => _isDestinationVisible;

// // // List<TripData>? data;
// //   TripModel _allTrips = TripModel();
// //   TripModel get allTrips => _allTrips;

// //   TripHistoryModel _tripHistory = TripHistoryModel();
// //   TripHistoryModel get tripHistory => _tripHistory;

//   Set tripRoutes = {};

//   bool showCard = true;

//   List koropeyList = [
//     "assets/pngs/car.png",
//     "assets/pngs/bus3.png",
//     "assets/pngs/bus2.png",
//   ];

//   PageController pageController = PageController();
//   List dSearchResults = [];

//   int currentPage = 0;
//   void setIndex(int index) {
//     currentPage = index;
//     notifyListeners();
//   }

//   void setState(HomeState state) {
//     _state = state;
//     notifyListeners();
//   }

//   void setRouteState(RouteState state) {
//     _routeState = state;
//     notifyListeners();
//   }

//   void setDestinationVisibility(bool visible) {
//     _isDestinationVisible = visible;
//     notifyListeners();
//   }

//   // void setEmail(String emial) {
//   //   _email = emial;
//   //   notifyListeners();
//   // }

//   // void setRouteAndBusStop({
//   //   required String route,
//   //   required String busStop,
//   // }) {
//   //   _selectedRoute = route;
//   //   _busStop = busStop;
//   //   notifyListeners();
//   // }

//   // void setBusLatAndLong({
//   //   required double lat,
//   //   required double long,
//   // }) {
//   //   _busLat = lat;
//   //   _busLong = long;
//   //   notifyListeners();
//   // }

//   // void setDestination({
//   //   required String destination,
//   // }) {
//   //   _destination = destination;
//   //   notifyListeners();
//   // }

//   // void setLocation(Position position) {
//   //   currentLat = position.latitude;
//   //   currentLong = position.longitude;
//   //   notifyListeners();
//   // }

//   // void setShowCard(bool card) {
//   //   showCard = card;
//   //   notifyListeners();
//   // }

//   // Future<void> getKoropeyInvestment() async {
//   //   try {
//   //     final response = await homeService.getKoropeyInvestment();
//   //     if (response.isError) {
//   //       setState(HomeState.error);
//   //     } else {
//   //       setState(HomeState.success);
//   //       koropeyInvestment = KoropeyModel.fromJson(response.data);
//   //       notifyListeners();
//   //     }
//   //   } catch (e) {
//   //     setState(HomeState.error);
//   //     dialogHandler.showDialog(
//   //       arguments: const ErrorDialogArgs(
//   //         errorMessage: "Something went wrong",
//   //       ),
//   //     );
//   //   }
//   // }

//   // Future<void> getUserProfile() async {
//   //   try {
//   //     final response = await userService.getUserProfile();
//   //     if (response.isError) {
//   //       setState(HomeState.error);
//   //     } else {
//   //       setState(HomeState.success);
//   //       userModel = UserModel.fromJson(response.data);
//   //       // dev.log("userModel:$userModel");
//   //       notifyListeners();
//   //     }
//   //   } catch (e) {
//   //     setState(HomeState.error);
//   //     dialogHandler.showDialog(
//   //       arguments: const ErrorDialogArgs(
//   //         errorMessage: "Something went wrong",
//   //       ),
//   //     );
//   //   }
//   // }

//   // Future<void> postInvestmentDetails(
//   //   context, {
//   //   required String investmentId,
//   //   required String numberOfSlots,
//   //   required String totalAmount,
//   // }) async {
//   //   setState(HomeState.loading);
//   //   try {
//   //     final response = await homeService.postInvestmentDetails(
//   //       investmentId: investmentId,
//   //       numberOfSlots: numberOfSlots,
//   //       totalAmount: totalAmount,
//   //       imageFile: imageUpload,
//   //     );
//   //     if (response.isError) {
//   //       setState(HomeState.error);
//   //       if (response.data['message']
//   //           .toString()
//   //           .contains("Your payment is yet to be confirmed")) {
//   //         dialogHandler.showDialog(
//   //           arguments: ErrorDialogArgs(
//   //             errorMessage:
//   //                 "You have a pending payment.\nPlease wait while we process your investment",
//   //           ),
//   //         );
//   //       }
//   //     } else {
//   //       setState(HomeState.success);
//   //       clearImage();
//   //       showConfirmDialogCustom(
//   //         context,
//   //         positiveText: "Ok",
//   //         title: "Payment Successful!",
//   //         subTitle: "Your investment will be processed within 48 hours.",
//   //         onAccept: () {
//   //           navigateToHomePage();
//   //         },
//   //         primaryColor: AppColors.blue,
//   //       );
//   //     }
//   //   } catch (e) {
//   //     setState(HomeState.error);
//   //     dialogHandler.showDialog(
//   //       arguments: const ErrorDialogArgs(
//   //         errorMessage: "Something went wrong",
//   //       ),
//   //     );
//   //   }
//   // }

//   // Future<void> postContarctAgreement(
//   //   context, {
//   //   required String investmentId,
//   // }) async {
//   //   // setState(HomeState.loading);
//   //   try {
//   //     final response = await homeService.postContarctAgreement(
//   //       imageFile: fileUpload,
//   //       investmentId: investmentId,
//   //     );
//   //     if (response.isError) {
//   //       setState(HomeState.error);
//   //     } else {
//   //       setState(HomeState.success);
//   //       clearImage();
//   //     }
//   //   } catch (e) {
//   //     setState(HomeState.error);
//   //     dev.log("catch agreement error:$e");
//   //   }
//   // }

//   // Future<File> selectImages() async {
//   //   try {
//   //     imageUpload = (await myUploadImage())!;
//   //     imageFile = imageUpload;

//   //     dev.log("imageUpload:$imageUpload");

//   //     if (imageFile != null) {
//   //       isImageSet = true;
//   //     } else {
//   //       isImageSet = false;
//   //     }
//   //   } catch (e) {
//   //     isImageSet = false;
//   //   }

//   //   notifyListeners();
//   //   return imageUpload;
//   // }

//   // Future<File> selectFile() async {
//   //   try {
//   //     fileUpload = (await pickFile())!;
//   //     fileData = fileUpload;
//   //   } catch (e) {}

//   //   notifyListeners();
//   //   return fileUpload;
//   // }

//   // Future<void> searchPlaces(search) async {
//   //   var response = await homeService.getAutocomplete(
//   //     search,
//   //   );

//   //   if (!response.isError) {
//   //     dSearchResults = response.data;
//   //   } else {
//   //     //
//   //   }

//   //   notifyListeners();
//   // }

//   void clearImage() {
//     imageFile = null;
//     fileData = null;
//     notifyListeners();
//   }

//   // Future<void> getAvialableBus() async {
//   //   try {
//   //     final response = await homeService.getAvialableBus();
//   //     if (response.isError) {
//   //       setState(HomeState.error);
//   //     } else {
//   //       setState(HomeState.success);
//   //       busModel = BusModel.fromJson(response.data);

//   //       notifyListeners();
//   //     }
//   //   } catch (e) {
//   //     setState(HomeState.error);
//   //   }
//   // }

//   // Future<void> getDrivers() async {
//   //   try {
//   //     final response = await homeService.getDrivers();
//   //     if (response.isError) {
//   //       setState(HomeState.error);
//   //     } else {
//   //       setState(HomeState.success);
//   //       driverModel = DriverModel.fromJson(response.data);
//   //       // dev.log("driverModel:${driverModel}");
//   //       notifyListeners();
//   //     }
//   //   } catch (e) {
//   //     setState(HomeState.error);
//   //   }
//   // }

//   // Future<void> getTripByRoute(String route) async {
//   //   try {
//   //     setState(HomeState.loading);
//   //     final response = await homeService.getTripByRoute(route);
//   //     if (response.isError) {
//   //       setState(HomeState.error);
//   //     } else {
//   //       setState(HomeState.success);
//   //       tripModel = TripModel.fromJson(response.data);
//   //       notifyListeners();
//   //     }
//   //   } catch (e) {
//   //     setState(HomeState.error);
//   //   }
//   // }

//   // Future<void> initPayment({
//   //   required int amount,
//   //   required String tripId,
//   // }) async {
//   //   try {
//   //     setState(HomeState.loading);
//   //     final response = await homeService.initiatePaystack(amount);
//   //     if (response.isError) {
//   //       setState(HomeState.error);
//   //     } else {
//   //       setState(HomeState.success);
//   //       navigateToCheckOutView(
//   //         paymentRef: response.data['data']['reference'],
//   //         paymentUrl: response.data['data']['authorization_url'],
//   //         tripId: tripId,
//   //         amount: amount ~/ 100,
//   //       );
//   //     }
//   //   } catch (e) {
//   //     setState(HomeState.error);
//   //   }
//   // }

//   // Future<void> makeTripPayment(
//   //   context, {
//   //   required String tripId,
//   //   required int amount,
//   //   required String referenceId,
//   // }) async {
//   //   try {
//   //     setState(HomeState.loading);
//   //     final response = await homeService.makeTripPayment(
//   //       amount: amount,
//   //       tripId: tripId,
//   //       referenceId: referenceId,
//   //     );
//   //     if (response.isError) {
//   //       // showConfirmDialogCustom(
//   //       //   context,
//   //       //   positiveText: "Ok",
//   //       //   title: "Successful!",
//   //       //   subTitle: "Please wait while we process your request",
//   //       //   onAccept: () {
//   //       //     navigateToHomePage();
//   //       //   },
//   //       //   primaryColor: AppColors.blue,
//   //       // );
//   //       setState(HomeState.error);
//   //     } else {
//   //       setState(HomeState.success);
//   //       tripRequest(
//   //         context,
//   //         busStop: busStop,
//   //         pickup: busStop,
//   //         destination: destination,
//   //         tripId: tripId,
//   //       );
//   //       // navigateToCheckOutView(
//   //       //     paymentRef: response.data['data']['reference'],
//   //       //     paymentUrl: response.data['data']['authorization_url']);
//   //     }
//   //   } catch (e) {
//   //     setState(HomeState.error);
//   //   }
//   // }

//   // Future<void> tripRequest(
//   //   context, {
//   //   required String tripId,
//   //   required String busStop,
//   //   required String pickup,
//   //   required String destination,
//   // }) async {
//   //   try {
//   //     setState(HomeState.loading);
//   //     final response = await homeService.tripRequest(
//   //       tripId: tripId,
//   //       busStop: busStop,
//   //       pickup: pickup,
//   //       destination: destination,
//   //     );
//   //     if (response.isError) {
//   //       setState(HomeState.error);
//   //     } else {
//   //       setState(HomeState.success);
//   //       setRouteState(RouteState.ongoing);
//   //       setDestinationVisibility(true);
//   //       showConfirmDialogCustom(
//   //         context,
//   //         positiveText: "Ok",
//   //         title: "Successful!",
//   //         subTitle: "Please wait while we process your request",
//   //         onAccept: () {
//   //           navigateToHomePage();
//   //         },
//   //         primaryColor: AppColors.blue,
//   //       );
//   //     }
//   //   } catch (e) {
//   //     setState(HomeState.error);
//   //   }
//   // }

//   // Future<void> getAllTrips() async {
//   //   try {
//   //     final response = await homeService.getAllTrips();
//   //     if (response.isError) {
//   //       setState(HomeState.error);
//   //     } else {
//   //       setState(HomeState.success);
//   //       _allTrips = TripModel.fromJson(response.data);

//   //       allTrips.data!.forEach(
//   //         (trip) {
//   //           if (trip.driver != null) {
//   //             tripRoutes.add(trip.vehicle!.route!);
//   //           }
//   //         },
//   //       );

//   //       notifyListeners();
//   //     }
//   //   } catch (e) {
//   //     setState(HomeState.error);
//   //   }
//   // }

//   // Future<void> getTripHistory() async {
//   //   try {
//   //     final response = await homeService.getTripHistory();
//   //     if (response.isError) {
//   //       setState(HomeState.error);
//   //     } else {
//   //       setState(HomeState.success);
//   //       _tripHistory = TripHistoryModel.fromJson(response.data);
//   //       // dev.log("_tripHistory:${_tripHistory.data}");
//   //       notifyListeners();
//   //     }
//   //   } catch (e) {
//   //     setState(HomeState.error);
//   //   }
//   // }

//   // DriverData getDriverById(String driverId) {
//   //   return driverModel!.data!.firstWhere(
//   //     (driver) => driver.id == driverId,
//   //     orElse: () => DriverData(name: "Dello"),
//   //   );
//   // }

//   // Passenger getPassenger(String userId, List passengers) {
//   //   return passengers.firstWhere(
//   //     (user) => user.userId == userId,
//   //     orElse: () => Passenger(id: "", userId: '', pickUp: '', destination: ''),
//   //   );
//   // }

//   String calculateDistance({
//     required double endLatitude,
//     required double endLongitude,
//     bool inKilometers = false,
//   }) {
//     double distanceInMeters = Geolocator.distanceBetween(
//       currentLat,
//       currentLong,
//       endLatitude,
//       endLongitude,
//     );

//     double distance = inKilometers ? distanceInMeters / 1000 : distanceInMeters;

//     return distance.toStringAsFixed(2);
//   }

//   void navigateToSignUp() {
//     // navigationHandler.pushNamed(signUpViewRoute);
//   }

//   void navigateToLogin() {
//     // navigationHandler.pushNamed(loginViewRoute);
//   }

//   void navigateToPhoneView() {
//     // navigationHandler.pushNamed(enterPhoneNumberViewRoute);
//   }

//   void navigateToNameCountryLocationView() {
//     // navigationHandler.pushNamed(nameCountryLocationViewRoute);
//   }

//   void navigateToForgotPassword() {
//     // navigationHandler.pushNamed(forgotPasswordViewRoute);
//   }

//   void navigateToChangePassword() {
//     // navigationHandler.pushNamed(changePasswordViewRoute);
//   }

//   // void navigateToHomePage() async {
//   //   final String accountType = await storage.read(key: 'accountType') ?? "";
//   //   navigationHandler.pushNamed(
//   //     homePageViewRoute,
//   //     arg: accountType,
//   //   );
//   // }

//   // void navigateToUnaunthenticatedView() {
//   //   navigationHandler.pushNamed(loginViewRoute);
//   // }

//   // void navigateToEnableLocationView() {
//   //   navigationHandler.popAndPushNamed(enableLocationViewRoute);
//   // }

//   // void navigateToCodeVerification() {
//   //   navigationHandler
//   //       .popAndPushNamed(codeVerificationViewRoute); //loginViewRoute
//   // }

//   // void navigateToCheckOutView({
//   //   required String paymentUrl,
//   //   required String paymentRef,
//   //   required String tripId,
//   //   required int amount,
//   // }) {
//   //   navigationHandler.pushNamed(checkoutView, arg: {
//   //     'paymentUrl': paymentUrl,
//   //     'paymentRef': paymentRef,
//   //     'tripId': tripId,
//   //     'amount': amount,
//   //   });
//   // }
// }
