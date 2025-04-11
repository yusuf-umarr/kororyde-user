import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kororyde_user/common/app_arguments.dart';
import 'package:kororyde_user/common/app_colors.dart';
import 'package:kororyde_user/core/utils/custom_navigation_icon.dart';
import 'package:kororyde_user/core/utils/custom_text.dart';
import 'package:kororyde_user/features/bookingpage/application/booking_bloc.dart';
import 'package:kororyde_user/features/home/application/home_bloc.dart';
import 'package:kororyde_user/features/home/presentation/pages/co_share/ride_detail.dart';
import 'dart:developer';

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
  void initState() {
    context.read<HomeBloc>().add(GetAllCoShareTripEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //            context.read<HomeBloc>().add(GetAllCoShareTripEvent());

    log("--get pickup:${widget.arg.picklat}");
    log("--get available co-share:${context.watch<HomeBloc>().allCoShareTripData}");

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
          text: "Available co-sharing rides",
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            MyText(
              text: "17 co-sharing rides are available at the moment",
              textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.black.withOpacity(0.5),
                  ),
            ),
            SizedBox(height: size.height * 0.05),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<HomeBloc>(),
              child: RideDetailPage(isRequest: false),
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
            color: AppColors.grey4.withOpacity(0.2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: "Abiola John",
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    MyText(
                      text: "Toyota Camry (Black)",
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset("assets/svg/airplaneSeat.svg"),
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
            riderAddrCard(
              context,
              title: 'Rider pick-up address',
              icon: "assets/svg/sourceAddr.svg",
              adrr: "ikoyi Royal lagos, Lekki",
            ),
            riderAddrCard(
              context,
              title: 'Rider destination',
              icon: "assets/svg/destinationAddr.svg",
              adrr: "Elegushi Royal beach, Lekki Elegushi Royal beach, Lekki",
            ),
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
        SizedBox(height: 10),
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
