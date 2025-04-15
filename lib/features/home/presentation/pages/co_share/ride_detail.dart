import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kororyde_user/common/app_colors.dart';
import 'package:kororyde_user/common/app_constants.dart';
import 'package:kororyde_user/core/utils/custom_text.dart';
import 'package:kororyde_user/features/bookingpage/application/booking_bloc.dart';
import 'package:kororyde_user/features/home/application/home_bloc.dart';
import 'package:kororyde_user/features/home/domain/models/all_coshare_trip_model.dart';
import 'dart:developer';

class RideDetailPage extends StatefulWidget {
  final bool isRequest;
  final String pickUpAddr;
  final String dropOffAddr;
  final double pickUpLat;
  final double pickUpLong;
  final double dropOffLat;
  final double dropOffLong;
  final String distance;
  final CoShareTripData rider;
  const RideDetailPage({
    super.key,
    required this.isRequest,
    required this.pickUpAddr,
    required this.dropOffAddr,
    required this.pickUpLat,
    required this.pickUpLong,
    required this.dropOffLat,
    required this.dropOffLong,
    required this.rider,
    required this.distance,
  });

  @override
  State<RideDetailPage> createState() => _RideDetailPageState();
}

class _RideDetailPageState extends State<RideDetailPage> {
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
      pickLat: widget.pickUpLat,
      pickLng: widget.pickUpLong,
      dropLat: widget.rider.requestPlaces![0].dropLat!,
      dropLng: widget.rider.requestPlaces![0].dropLng!,
      stops: [],
      pickAddress: widget.pickUpAddr,
      dropAddress: widget.rider.requestPlaces![0].dropAddress!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 40),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.only(
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
                                text: widget.isRequest
                                    ? "Rider's detail"
                                    : "Selected ride",
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                              ),
                              MyText(
                                text:
                                    "The rider is ${widget.distance} km away from you",
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
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  // color:
                                  ),
                              child: Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: widget.isRequest ? "" : "Main rider",
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
                                      text: "${widget.rider.user!.name!}",
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
                            text: widget.isRequest
                                ? "Rider's current location"
                                : "Your current location",
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
                              Expanded(
                                child: MyText(
                                  text: "${widget.pickUpAddr}",
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
                            text: "Rider's destination",
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
                              Expanded(
                                child: MyText(
                                  text:
                                      "${widget.rider.requestPlaces![0].dropAddress}",
                                  maxLines: 3,
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
                      SizedBox(height: 20),
                      MyText(
                        text: "${widget.rider.user!.name}'s location",
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
                  // log("--marker list:${context.read<BookingBloc>().markerList}");
                  // log("--polylines:${context.read<BookingBloc>().polylines}");

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
                  return SizedBox.shrink();
                }),
                ////google map///
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child:
                // )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: !widget.isRequest
          ? Container(
              width: size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        final bloc = context.read<HomeBloc>();

                        bloc.add(JoinCoShareTripEvent(
                          destinationAddress: widget.dropOffAddr,
                          pickupAddress: widget.pickUpAddr,
                          pickUpLat: widget.pickUpLat,
                          pickUpLong: widget.pickUpLong,
                          tripRequestId: widget.rider.id!,
                          proposedAmount: 0,
                        ));

                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(
                                15,
                              ),
                            ),
                          ),
                          builder: (_) {
                            return BlocProvider.value(
                              value: context.read<BookingBloc>(),
                              child:
                                  StatefulBuilder(builder: (context, setState) {
                                return Stack(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20)
                                              .copyWith(top: 40),
                                      height: size.height * 0.38,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              MyText(
                                                text: "Contact passenger",
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Divider(),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.23)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.grey
                                                        .withOpacity(0.1)),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        "assets/svg/inMasseage.svg"),
                                                    SizedBox(width: 5),
                                                    Text("Message"),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.23)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.grey
                                                        .withOpacity(0.1)),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        "assets/svg/inCall.svg"),
                                                    SizedBox(width: 5),
                                                    Text("In-app call"),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          MyText(
                                            text: "Or copy main rider's number",
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                          SizedBox(height: 10),
                                          MyText(
                                            text: "08123456789",
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.primary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 20,
                                      top: 20,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),
                            );
                            // );
                          },
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.primary,
                        ),
                        child: Text(
                          "Contact passenger",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )

          //
          : SizedBox.shrink(),
      ////
    );
  }
}


/*

  showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(
                                15,
                              ),
                            ),
                          ),
                          builder: (_) {
                            final Size size = MediaQuery.of(context).size;
                            return BlocProvider.value(
                              value: context.read<HomeBloc>(),
                              child:
                                  StatefulBuilder(builder: (context, setState) {
                                return Stack(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10)
                                              .copyWith(top: 20),
                                      height: size.height * 0.45,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                MyText(
                                                  text: "Adam's offer",
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Divider(),
                                            SizedBox(height: 20),
                                            MyText(
                                              text: "Adam Thomas offers to pay",
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            SizedBox(height: 10),
                                            MyText(
                                              text: "#5,000",
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontSize: 22,
                                                      color: AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            SizedBox(height: 30),
                                            Container(
                                              width: size.width,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 12.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        //decline
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: AppColors.grey
                                                              .withOpacity(0.5),
                                                        ),
                                                        child: Text(
                                                            "Decline offer"),
                                                      ),
                                                    ),
                                                    SizedBox(width: 20),
                                                    InkWell(
                                                      onTap: () {
                                                        showModalBottomSheet<
                                                            void>(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(15),
                                                              topRight: Radius
                                                                  .circular(
                                                                15,
                                                              ),
                                                            ),
                                                          ),
                                                          builder: (_) {
                                                            return BlocProvider
                                                                .value(
                                                              value: context.read<
                                                                  HomeBloc>(),
                                                              child:
                                                                  renegociateMethod(
                                                                      size),
                                                            );
                                                            // );
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: AppColors.grey
                                                              .withOpacity(0.5),
                                                        ),
                                                        child: Text(
                                                          "Re-negotiate",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            InkWell(
                                              onTap: () {
                                                showModalBottomSheet<void>(
                                                  isScrollControlled: true,
                                                  context: context,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15),
                                                      topRight: Radius.circular(
                                                        15,
                                                      ),
                                                    ),
                                                  ),
                                                  builder: (_) {
                                                    return BlocProvider.value(
                                                      value: context
                                                          .read<HomeBloc>(),
                                                      child: acceptOfferMethod(
                                                          size),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                width: size.width,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: AppColors.primary),
                                                child: Text(
                                                  "Accpet offer",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 20,
                                      top: 20,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),
                            );
                            // );
                          },
                        );
*/