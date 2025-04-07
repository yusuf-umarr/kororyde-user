import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kororyde_user/common/app_colors.dart';
import 'package:kororyde_user/core/utils/custom_button.dart';
import 'package:kororyde_user/core/utils/custom_text.dart';
import 'package:kororyde_user/features/bookingpage/application/booking_bloc.dart';

class RideDetailPage extends StatefulWidget {
  const RideDetailPage({super.key});

  @override
  State<RideDetailPage> createState() => _RideDetailPageState();
}

class _RideDetailPageState extends State<RideDetailPage> {
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
                                text: "Yab002",
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                              ),
                              MyText(
                                text: "Ride is 10m. away from you",
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Colors.grey,
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
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        "assets/images/defaultImg.png",
                                        height: size.height * 0.04,
                                        width: size.height * 0.04,
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
                          Spacer(),
                          Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          AppColors.primary.withOpacity(0.1)),
                                  child: SvgPicture.asset(
                                      'assets/svg/messageIcon.svg')),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          AppColors.primary.withOpacity(0.1)),
                                  child: SvgPicture.asset(
                                      'assets/svg/phoneIcon.svg')),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Main rider destination",
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
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Your current location",
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
                    ],
                  ),
                ),
                ////google map///
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.36),
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomButton(
                          isBorder: true,
                          buttonName: "Cancel",
                          borderRadius: 10,
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: size.width * 0.3,
                          isLoader: false,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          buttonColor: Colors.white,
                          textColor: AppColors.primary,
                        ),
                        SizedBox(width: 20),
                        CustomButton(
                          buttonName: "Accept",
                          borderRadius: 10,
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: size.width * 0.3,
                          isLoader: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      ////
    );
  }
}
