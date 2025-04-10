import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kororyde_user/common/app_colors.dart';
import 'package:kororyde_user/core/utils/custom_text.dart';
import 'package:kororyde_user/features/bookingpage/application/booking_bloc.dart';

class RideDetailPage extends StatefulWidget {
  final bool isRequest;
  const RideDetailPage({super.key, required this.isRequest});

  @override
  State<RideDetailPage> createState() => _RideDetailPageState();
}

class _RideDetailPageState extends State<RideDetailPage> {
  final TextEditingController _offerController =
      TextEditingController(text: '100');
  int coShareMaxSeats = 100;
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
                                text: "The rider is 10mins away from you",
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
                                      text: "Francis Adeoti",
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
                              MyText(
                                text: "42 adebola st, surulere, lagos",
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
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
                              MyText(
                                text: "Elegushi Royal, lekki,",
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      MyText(
                        text: "francis's location",
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
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.40),
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
                          8.5373, //   AppConstants.currentLocations.latitude,
                          4.5444,
                        ), //    AppConstants.currentLocations.longitude),
                        zoom: 15.0,
                      ),
                      onCameraMove: (CameraPosition position) async {},
                      onCameraIdle: () async {},
                      minMaxZoomPreference: const MinMaxZoomPreference(0, 20),
                      buildingsEnabled: false,
                      zoomControlsEnabled: false,
                      myLocationEnabled: (context
                                  .read<BookingBloc>()
                                  .isNormalRideSearching ||
                              context
                                  .read<BookingBloc>()
                                  .isBiddingRideSearching ||
                              (context.read<BookingBloc>().requestData != null))
                          ? false
                          : true,
                      myLocationButtonEnabled: false,
                    ),
                  ),
                ),
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
          ? 
          
          Container(
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
                                                text: "Contact main rider",
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
                          color: Colors.grey.withOpacity(0.6),
                        ),
                        child: Text("Contact main rider"),
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
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
                                      height: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom ==
                                              0
                                          ? size.height * 0.4
                                          : size.height * 0.8,
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              MyText(
                                                text: "Your offer",
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          // SizedBox(height: 10),
                                          Row(
                                            children: [
                                              MyText(
                                                text:
                                                    "Negotiate how much you'd like to pay",
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          SizedBox(height: 30),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  width: size.width * 0.20,
                                                  child: Center(
                                                    child: TextFormField(
                                                      controller:
                                                          _offerController,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          final parsedVal =
                                                              int.tryParse(val);
                                                          if (parsedVal !=
                                                              null) {
                                                            coShareMaxSeats =
                                                                parsedVal;
                                                            _offerController
                                                                    .text =
                                                                parsedVal
                                                                    .toString();
                                                          }
                                                        });
                                                      },
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (coShareMaxSeats > 100)
                                                      coShareMaxSeats -= 100;
                                                    _offerController.text =
                                                        coShareMaxSeats
                                                            .toString();
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Colors.red),
                                                    color:
                                                        Colors.red.withOpacity(
                                                      0.4,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "-100",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    coShareMaxSeats += 100;
                                                    _offerController.text =
                                                        coShareMaxSeats
                                                            .toString();
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Colors.green),
                                                    color: Colors.green
                                                        .withOpacity(
                                                      0.4,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "+100",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.025,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors
                                                                  .primary),
                                                  onPressed: () {},
                                                  child: Text(
                                                    "Send offer",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
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
                          "Join ride",
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
