import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kororyde_user/common/app_arguments.dart';
import 'package:kororyde_user/common/app_colors.dart';
import 'package:kororyde_user/common/local_data.dart';
import 'package:kororyde_user/core/utils/custom_navigation_icon.dart';
import 'package:kororyde_user/core/utils/custom_text.dart';
import 'package:kororyde_user/features/bookingpage/application/booking_bloc.dart';
import 'package:kororyde_user/features/home/application/home_bloc.dart';
import 'package:kororyde_user/features/home/domain/models/all_coshare_trip_model.dart';
import 'package:kororyde_user/features/home/presentation/pages/co_share/ride_detail.dart';
import 'dart:developer' as dev;
import 'dart:math';

class AvailableCoshareRidePage extends StatefulWidget {
  static const String routeName = '/availableCoShare';
  final BookingPageArguments arg;

  const AvailableCoshareRidePage({super.key, required this.arg});

  @override
  State<AvailableCoshareRidePage> createState() =>
      _AvailableCoshareRidePageState();
}

class _AvailableCoshareRidePageState extends State<AvailableCoshareRidePage> {
  dynamic userId;
  @override
  void initState() {
    getUserId();
    context.read<HomeBloc>().add(GetAllCoShareTripEvent());

    super.initState();
  }

  getUserId() async {
    // final token = await AppSharedPreference.getToken();
    userId = await AppSharedPreference.getUserId();

    dev.log("--userId:$userId");
  }

  @override
  Widget build(BuildContext context) {
    // final bloc = context.watch<HomeBloc>();
    // getUserId();

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: size.width * 0.2,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          child: NavigationIconWidget(
            onTap: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: Theme.of(context).primaryColorDark),
            isShadowWidget: true,
          ),
        ),
        title: MyText(
          text: "Available co-sharing rides",
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is CoShareTripDataLoadedState) {
            final sortedTrips = state.data
                .where((trip) => trip.user?.id != int.parse(userId))
                .toList();

            sortedTrips.sort((a, b) {
              DateTime? aCreatedAt = a.requestPlaces?.isNotEmpty == true
                  ? DateTime.tryParse(a.requestPlaces!.first.createdAt ?? '')
                  : null;
              DateTime? bCreatedAt = b.requestPlaces?.isNotEmpty == true
                  ? DateTime.tryParse(b.requestPlaces!.first.createdAt ?? '')
                  : null;

              if (aCreatedAt == null && bCreatedAt == null) return 0;
              if (aCreatedAt == null) return 1;
              if (bCreatedAt == null) return -1;

              return bCreatedAt.compareTo(aCreatedAt); // Descending order

              // return aCreatedAt.compareTo(
              //     bCreatedAt); // Change to b.compareTo(a) for descending
            });
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: sortedTrips
                      .map((trip) => AvailableRideCard(
                            rider: trip,
                            arg: widget.arg,
                          ))
                      .toList(),
                ),
              ),
            );
          } else {
            return FutureBuilder(
              future: Future.delayed(const Duration(seconds: 2)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(
                    child: Text("No Co-Share available at this moment"),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class AvailableRideCard extends StatelessWidget {
  final BookingPageArguments arg;
  final CoShareTripData rider;
  AvailableRideCard({
    super.key,
    required this.rider,
    required this.arg,
  });

  double? distanceMeters;
  static const double earthRadiusKm = 6371.0;

  // Helper method to convert degrees to radians
  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  // Method to calculate the distance in meters
  double calculateDistance({
    required double sourceLat,
    required double sourceLng,
    required double destinationLat,
    required double destinationLng,
  }) {
    // Convert latitude and longitude from degrees to radians
    final double sourceLatRad = _toRadians(sourceLat);
    final double sourceLngRad = _toRadians(sourceLng);
    final double destinationLatRad = _toRadians(destinationLat);
    final double destinationLngRad = _toRadians(destinationLng);

    // Haversine formula
    final double dLat = destinationLatRad - sourceLatRad;
    final double dLng = destinationLngRad - sourceLngRad;

    final double a = pow(sin(dLat / 2), 2) +
        cos(sourceLatRad) * cos(destinationLatRad) * pow(sin(dLng / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    distanceMeters = (earthRadiusKm * c);

    return distanceMeters!;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // dev.log("image:${rider.user!.profilePicture!}");

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<HomeBloc>(),
              child: RideDetailPage(
                  isRequest: false,
                  pickUpAddr: arg.pickupAddressList[0].address,
                  dropOffAddr: arg.stopAddressList[0].address,
                  pickUpLat: double.parse(arg.picklat),
                  pickUpLong: double.parse(arg.picklng),
                  dropOffLat: double.parse(arg.droplat),
                  dropOffLong: double.parse(arg.droplng),
                  rider: rider,
                  distance: calculateDistance(
                    sourceLat: double.parse(arg.picklat),
                    sourceLng: double.parse(arg.picklng),
                    destinationLat: rider.requestPlaces!.first.pickLat!,
                    destinationLng: rider.requestPlaces!.first.pickLng!,
                  ).toStringAsFixed(0)),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        width: size.width,
        // height: size.height * 0.125,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.primary.withOpacity(0.1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child:
                                // rider.user!.profilePicture != null
                                //     ? Image.network(
                                //         rider.user!.profilePicture!,
                                //         height: 30,
                                //         width: 30,
                                //       )
                                //     :
                                Image.asset(
                              "assets/images/defaultImg.png",
                              height: 30,
                              width: 30,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: MyText(
                            text: rider.user!.name!,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                    // MyText(
                    //   text: "Toyota Camry (Black)",
                    //   textStyle: Theme.of(context)
                    //       .textTheme
                    //       .bodySmall!
                    //       .copyWith(
                    //           color: Colors.black.withOpacity(0.5),
                    //           fontWeight: FontWeight.w400,
                    //           fontSize: 11),
                    // ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/svg/airplaneSeat.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: MyText(
                            text: "${rider.coShareMaxSeats} seats available",
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SvgPicture.asset("assets/svg/socialDistance.svg"),
                        MyText(
                          text: "${calculateDistance(
                            sourceLat: arg.pickupAddressList.first.lat,
                            sourceLng: arg.pickupAddressList.first.lng,
                            destinationLat: rider.requestPlaces!.first.pickLat!,
                            destinationLng: rider.requestPlaces!.first.pickLng!,
                          ).toStringAsFixed(0)} km away",
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            riderAddrCard(
              context,
              title: 'Pick-up address',
              icon: "assets/svg/sourceAddr.svg",
              adrr: "${rider.requestPlaces![0].pickAddress}",
            ),
            riderAddrCard(context,
                title: 'Destination address',
                icon: "assets/svg/destinationAddr.svg",
                adrr: "${rider.requestPlaces![0].dropAddress}"),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primary),
              child: Text(
                "View detail",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column riderAddrCard(
    BuildContext context, {
    required String icon,
    required String adrr,
    required String title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        MyText(
          text: title,
          textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.black.withOpacity(0.5),
              fontWeight: FontWeight.w400,
              fontSize: 11),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: SvgPicture.asset(icon),
            ),
            Expanded(
              child: MyText(
                text: adrr,
                textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
