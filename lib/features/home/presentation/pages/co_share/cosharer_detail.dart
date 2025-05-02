import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kororyde_user/common/app_colors.dart';
import 'package:kororyde_user/common/app_constants.dart';
import 'package:kororyde_user/core/utils/custom_text.dart';
import 'package:kororyde_user/features/bookingpage/application/booking_bloc.dart';
import 'package:kororyde_user/features/home/domain/models/all_coshare_trip_model.dart';
import 'package:kororyde_user/features/home/domain/models/incoming_coshare_request_model.dart';
import 'dart:developer' as dev;

import 'package:kororyde_user/features/home/presentation/pages/co_share/coshare_page.dart';

class CosharerDetail extends StatefulWidget {
  final  request; //MyCoShareRequestCard

  const CosharerDetail({
    super.key,
    required this.request,
  });

  @override
  State<CosharerDetail> createState() => _CosharerDetailState();
}

class _CosharerDetailState extends State<CosharerDetail> {
  final TextEditingController _offerController =
      TextEditingController(text: '100');
  int coShareMaxSeats = 100;

  @override
  void initState() {
    addPoly();
    super.initState();
  }

  addPoly() {
    final bloc = context.read<BookingBloc>();

    bloc.add(PolylineEvent(
      isInitCall: true,
      // arg: event.arg,
      pickLat: widget.request.request!,
      pickLng: widget.request.pickupLng!,
      dropLat: widget.request.destinationLat!,
      dropLng: widget.request.destinationLng!,
      stops: [],
      pickAddress: widget.request.pickupAddress!,
      dropAddress: widget.request.destinationAddress!,
    ));
  }

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
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )),
            height: size.height,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: "Detail",
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                              ),
                              MyText(
                                text: "The passender is ${calculateDistance(
                                  sourceLat:
                                      AppConstants.currentLocations.latitude,
                                  sourceLng:
                                      AppConstants.currentLocations.longitude,
                                  destinationLat: widget.request.pickupLat!,
                                  destinationLng: widget.request.pickupLng!,
                                ).toStringAsFixed(
                                  0,
                                )} m away from you",
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Colors.black.withOpacity(0.5),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13),
                              ),
                            ],
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  // color:
                                  ),
                              child: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: "",
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Colors.black.withOpacity(0.5),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11),
                              ),
                              Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        "assets/images/defaultImg.png",
                                        height: size.height * 0.05,
                                        width: size.height * 0.05,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: MyText(
                                      text: widget.request.user!.name!,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text:
                                "${widget.request.user!.name}'s current location",
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset("assets/svg/sourceAddr.svg"),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: size.width * 0.8,
                                child: MyText(
                                  text: "${widget.request.pickupAddress}",
                                  maxLines: 4,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "${widget.request.user!.name}'s destination",
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                  "assets/svg/destinationAddr.svg"),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: size.width * 0.8,
                                child: MyText(
                                  text: "${widget.request.destinationAddress}",
                                  maxLines: 4,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      MyText(
                        text: "${widget.request.user!.name}'s location",
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                      ),
                    ],
                  ),
                ),

                ////google map///
                /////
                BlocBuilder<BookingBloc, BookingState>(
                    builder: (context, state) {
                  dev.log(
                      "--marker list:${context.read<BookingBloc>().markerList}");
                  dev.log(
                      "--polylines:${context.read<BookingBloc>().polylines}");

                  if (state is BookingUpdateState) {
                    return Padding(
                      padding: EdgeInsets.only(top: size.height * 0.42),
                      child: SizedBox(
                        height: size.height * 0.5,
                        width: size.width,
                        child: GoogleMap(
                          // gestureRecognizers: {
                          //   Factory<OneSequenceGestureRecognizer>(
                          //     () => EagerGestureRecognizer(),
                          //   ),
                          // },
                          onMapCreated: (GoogleMapController controller) {
                            context.read<BookingBloc>().googleMapController =
                                controller;
                          },
                          compassEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                AppConstants.currentLocations.latitude,
                                AppConstants.currentLocations.longitude),
                            zoom: 15.0,
                          ),
                          onCameraMove: (CameraPosition position) async {},
                          onCameraIdle: () async {},
                          minMaxZoomPreference:
                              const MinMaxZoomPreference(0, 20),
                          buildingsEnabled: false,
                          zoomControlsEnabled: false,
                          myLocationEnabled: (context
                                      .read<BookingBloc>()
                                      .isNormalRideSearching ||
                                  context
                                      .read<BookingBloc>()
                                      .isBiddingRideSearching ||
                                  (context.read<BookingBloc>().requestData !=
                                      null))
                              ? false
                              : true,
                          myLocationButtonEnabled: false,

                          markers:
                              Set.from(context.read<BookingBloc>().markerList),
                          polylines: context.read<BookingBloc>().polylines,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
