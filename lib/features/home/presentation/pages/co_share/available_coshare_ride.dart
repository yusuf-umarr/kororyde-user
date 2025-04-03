import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kororyde_user/common/app_arguments.dart';
import 'package:kororyde_user/common/app_colors.dart';
import 'package:kororyde_user/common/app_constants.dart';
import 'package:kororyde_user/core/utils/avatar_glow.dart';
import 'package:kororyde_user/core/utils/custom_navigation_icon.dart';
import 'package:kororyde_user/core/utils/custom_text.dart';
import 'package:kororyde_user/features/account/application/acc_bloc.dart';
import 'package:kororyde_user/features/bookingpage/application/booking_bloc.dart';
import 'package:kororyde_user/features/home/application/home_bloc.dart';

class AvailableCoshareRidePage extends StatefulWidget {
  static const String routeName = '/availableCoShare';
  final BookingPageArguments arg;

  const AvailableCoshareRidePage({super.key, required this.arg});

  @override
  State<AvailableCoshareRidePage> createState() =>
      _AvailableCoshareRidePageState();
}

class _AvailableCoshareRidePageState extends State<AvailableCoshareRidePage> {
  @override
  Widget build(BuildContext context) {
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
              // Navigator.pop(context);
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: Theme.of(context).primaryColorDark),
            isShadowWidget: true,
          ),
        ),
        title: MyText(
            text: "Available ride",
            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w500)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0).copyWith(top: size.height * 0.05),
        child: Column(
          children: [
            AvailableRideCard(),
            AvailableRideCard(),
            AvailableRideCard(),
          ],
        ),
      ),
    );
  }
}

class AvailableRideCard extends StatelessWidget {
  const AvailableRideCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return BlocProvider.value(
                  value: BlocProvider.of<HomeBloc>(context),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: size.height * 0.7,
                    child: Stack(
                      children: [
                        Column(
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
                                              color: Theme.of(context)
                                                  .primaryColorDark,
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
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          
                          ],
                        ),
                          ////google map///
                            SizedBox(
                              height: size.height * 0.3,
                              width: size.width,
                              child: GoogleMap(
                                // gestureRecognizers: {
                                //   Factory<OneSequenceGestureRecognizer>(
                                //     () => EagerGestureRecognizer(),
                                //   ),
                                // },
                                onMapCreated: (GoogleMapController controller) {
                                  context
                                      .read<BookingBloc>()
                                      .googleMapController = controller;
                                },
                                compassEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    8.5373, //   AppConstants.currentLocations.latitude,
                                    4.5444,
                                  ), //    AppConstants.currentLocations.longitude),
                                  zoom: 15.0,
                                ),
                                onCameraMove:
                                    (CameraPosition position) async {},
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
                                        (context
                                                .read<BookingBloc>()
                                                .requestData !=
                                            null))
                                    ? false
                                    : true,
                                myLocationButtonEnabled: false,
                              ),
                            )
                            ////google map///
                      ],
                    ),
                  ));
            });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        width: size.width,
        height: size.height * 0.125,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.grey4.withOpacity(0.2)),
        child: Row(
          children: [
            SizedBox(
                width: size.width * 0.22,
                child: Image.asset("assets/png/rideIcon.png")),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: "Toyotal Camry (Black)",
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                  MyText(
                    text: "Francis Adeoti",
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset("assets/png/airplaneSeat.png"),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: MyText(
                          text: "2 seats available",
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: "10m. away",
                    textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        fontSize: 12),
                  ),
                  MyText(
                    text: "Yab0003",
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     MyText(
            //       text: "10mins away",
            //       textStyle: Theme.of(context)
            //           .textTheme
            //           .bodySmall!
            //           .copyWith(
            //               color: Colors.grey,
            //               fontWeight: FontWeight.w400,
            //               fontSize: 12),
            //     ),
            //     MyText(
            //       text: "20,000",
            //       textStyle:
            //           Theme.of(context).textTheme.bodySmall!.copyWith(
            //                 color: AppColors.primary,
            //                 fontWeight: FontWeight.w500,
            //                 fontSize: 12,
            //               ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
