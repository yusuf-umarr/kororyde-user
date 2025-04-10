// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:kororyde_user/core/utils/custom_textfield.dart';
import 'package:kororyde_user/features/bottom_nav/presentation/bottom_nav.dart';
import 'package:latlong2/latlong.dart' as fmlt;
import 'package:kororyde_user/features/account/presentation/pages/outstation_page.dart';
import 'package:kororyde_user/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../common/common.dart';
import '../../../../common/pickup_icon.dart';
import '../../../../core/utils/avatar_glow.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_dialoges.dart';
import '../../../../core/utils/custom_divider.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_navigation_icon.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../application/booking_bloc.dart';
import '../../../../core/utils/custom_container.dart';
import '../widgets/apply_coupons.dart';
import '../widgets/bidding_waiting_for_driver.dart';
import '../widgets/chat_with_driver.dart';
import '../widgets/choose_payments.dart';
import '../widgets/eta_detail_view.dart';
import '../widgets/eta_list_shimmer.dart';
import '../widgets/eta_list_view.dart';
import '../widgets/no_driver_found.dart';
import '../widgets/on_ride_bottom_sheet.dart';
import '../widgets/rental_eta_list_view.dart';
import '../widgets/rental_package_select.dart';
import '../widgets/select_cancel_reason.dart';
import '../widgets/select_goods_type.dart';
import '../widgets/select_preference.dart';
import '../widgets/sos_notify.dart';
import '../widgets/waiting_for_driver.dart';
import 'trip_summary_page.dart';
import 'dart:developer';

class BookingPage extends StatefulWidget {
  static const String routeName = '/booking';
  final BookingPageArguments arg;

  const BookingPage({super.key, required this.arg});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int maxSeat = 1;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  final TextEditingController coShareController = TextEditingController();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      BookingBloc().nearByVechileSubscription?.pause();
      BookingBloc().etaDurationStream?.pause();
    }
    if (state == AppLifecycleState.resumed) {
      BookingBloc().nearByVechileSubscription?.resume();
      BookingBloc().etaDurationStream?.resume();
    }
  }

  @override
  void dispose() {
    if (BookingBloc().nearByVechileSubscription != null) {
      BookingBloc().nearByVechileSubscription?.cancel();
      BookingBloc().nearByVechileSubscription = null;
    }
    if (BookingBloc().etaDurationStream != null) {
      BookingBloc().etaDurationStream?.cancel();
      BookingBloc().etaDurationStream = null;
    }
    BookingBloc().add(BookingNavigatorPopEvent());
    // //Animate
    // _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return builderWidget();
  }

  Widget builderWidget() {
    return BlocProvider(
      create: (context) => BookingBloc()
        ..add(GetDirectionEvent())
        ..add(BookingInitEvent(arg: widget.arg, vsync: this)),
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) async {
          if (state is BookingLoadingStartState) {
            log("BookingLoadingStartState 1   now====");

            CustomLoader.loader(context);
          } else if (state is BookingLoadingStopState) {
            log("BookingLoadingStopState  2  now====");
            CustomLoader.dismiss(context);
            log("Booking---LoadingStopState  2b  now====");
          } else if (state is BookingSuccessState) {
            log("BookingSuccessState  3  now====");

            context.read<BookingBloc>().nearByVechileCheckStream(
                context,
                this,
                LatLng(double.parse(widget.arg.picklat),
                    double.parse(widget.arg.picklng)));
          } else if (state is LogoutState) {
            context.read<BookingBloc>().nearByVechileSubscription?.cancel();
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          } else if (state is BookingNavigatorPopState) {
            context.read<BookingBloc>().nearByVechileSubscription?.cancel();
            if (context.read<BookingBloc>().isPop) {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            }
          } else if (state is SelectGoodsTypeState) {
            final bookingBloc = context.read<BookingBloc>();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              barrierColor: Theme.of(context).shadowColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              builder: (_) {
                return BlocProvider.value(
                  value: bookingBloc,
                  child: const SelectGoodsType(),
                );
              },
            );
          } else if (state is ShowEtaInfoState) {
            final bookingBloc = context.read<BookingBloc>();
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              isScrollControlled: true,
              elevation: 0,
              barrierColor: Theme.of(context).shadowColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              builder: (_) {
                return BlocProvider.value(
                  value: bookingBloc,
                  child: EtaDetailsWidget(
                      etaInfo: (!context.read<BookingBloc>().isRentalRide)
                          ? context.read<BookingBloc>().isMultiTypeVechiles
                              ? context
                                  .read<BookingBloc>()
                                  .sortedEtaDetailsList[state.infoIndex]
                              : context
                                  .read<BookingBloc>()
                                  .etaDetailsList[state.infoIndex]
                          : context
                              .read<BookingBloc>()
                              .rentalEtaDetailsList[state.infoIndex]),
                );
              },
            );
          } else if (state is ShowBiddingState) {
            final bookingBloc = context.read<BookingBloc>();
            context.read<BookingBloc>().farePriceController.text =
                context.read<BookingBloc>().isMultiTypeVechiles
                    ? context
                        .read<BookingBloc>()
                        .sortedEtaDetailsList[
                            context.read<BookingBloc>().selectedVehicleIndex]
                        .total
                        .toString()
                    : context
                        .read<BookingBloc>()
                        .etaDetailsList[
                            context.read<BookingBloc>().selectedVehicleIndex]
                        .total
                        .toString();
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              elevation: 0,
              isScrollControlled: true,
              barrierColor: Theme.of(context).shadowColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              builder: (_) {
                final Size size = MediaQuery.of(context).size;
                log("pickUpAddressList:${context.read<BookingBloc>().pickUpAddressList}");
                //////biddingPriceOffer start//////
                return BlocProvider.value(
                  value: bookingBloc,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.width * 0.01),
                          MyText(
                              text: context
                                      .read<BookingBloc>()
                                      .isMultiTypeVechiles
                                  ? context
                                      .read<BookingBloc>()
                                      .sortedEtaDetailsList[context
                                          .read<BookingBloc>()
                                          .selectedVehicleIndex]
                                      .name
                                  : context
                                      .read<BookingBloc>()
                                      .etaDetailsList[context
                                          .read<BookingBloc>()
                                          .selectedVehicleIndex]
                                      .name,
                              textStyle: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(height: size.width * 0.03),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: AppLocalizations.of(context)!
                                    .pickupLocation,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Theme.of(context).disabledColor),
                              ),
                              SizedBox(height: size.width * 0.01),
                              ListView.builder(
                                  itemCount: context
                                      .read<BookingBloc>()
                                      .pickUpAddressList
                                      .length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    final address = context
                                        .read<BookingBloc>()
                                        .pickUpAddressList
                                        .elementAt(index);
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 5),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.width * 0.01),
                                              child: const PickupIcon(),
                                            ),
                                            Expanded(
                                              child: MyText(
                                                text: address.address,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                              SizedBox(height: size.width * 0.01),
                              MyText(
                                text:
                                    AppLocalizations.of(context)!.dropLocation,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Theme.of(context).disabledColor),
                              ),
                              SizedBox(height: size.width * 0.01),
                              ListView.builder(
                                  itemCount: context
                                      .read<BookingBloc>()
                                      .dropAddressList
                                      .length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    final address = context
                                        .read<BookingBloc>()
                                        .dropAddressList
                                        .elementAt(index);
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.width * 0.005),
                                              child: const DropIcon(),
                                            ),
                                            Expanded(
                                              child: MyText(
                                                text: address.address,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                          SizedBox(height: size.width * 0.03),
                          Center(
                            child: MyText(
                                text:
                                    AppLocalizations.of(context)!.offerYourFare,
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge),
                          ),
                          SizedBox(height: size.width * 0.005),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyText(
                                  text: AppLocalizations.of(context)!
                                      .minimumRecommendedFare
                                      .replaceAll('***',
                                          '${context.read<BookingBloc>().isMultiTypeVechiles ? context.read<BookingBloc>().sortedEtaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].currency : context.read<BookingBloc>().etaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].currency} ${context.read<BookingBloc>().isMultiTypeVechiles ? context.read<BookingBloc>().sortedEtaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].minAmount.toStringAsFixed(2) : context.read<BookingBloc>().etaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].minAmount.toStringAsFixed(2)}'),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).disabledColor)),
                            ],
                          ),
                          SizedBox(height: size.width * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: size.width * 0.03),
                              Container(
                                width: size.width * 0.5,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .dividerColor
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextField(
                                  enabled: true,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.number,
                                  controller: context
                                      .read<BookingBloc>()
                                      .farePriceController,
                                  decoration: InputDecoration(
                                    border: const UnderlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide()),
                                    prefixIconConstraints: BoxConstraints(
                                        maxWidth: size.width * 0.2),
                                    prefixIcon: Center(
                                      child: MyText(
                                        text: context
                                                .read<BookingBloc>()
                                                .isMultiTypeVechiles
                                            ? context
                                                .read<BookingBloc>()
                                                .sortedEtaDetailsList[context
                                                    .read<BookingBloc>()
                                                    .selectedVehicleIndex]
                                                .currency
                                                .toString()
                                            : context
                                                .read<BookingBloc>()
                                                .etaDetailsList[context
                                                    .read<BookingBloc>()
                                                    .selectedVehicleIndex]
                                                .currency
                                                .toString(),
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayLarge,
                                      ),
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                            ],
                          ),
                          SizedBox(height: size.width * 0.05),
                          Center(
                            child: CustomButton(
                              width: size.width,
                              buttonColor: Theme.of(context).primaryColor,
                              buttonName:
                                  AppLocalizations.of(context)!.createRequest,
                              isLoader: context.read<BookingBloc>().isLoading,
                              onTap: () {
                                if (double.parse(context
                                        .read<BookingBloc>()
                                        .farePriceController
                                        .text) >=
                                    (context
                                            .read<BookingBloc>()
                                            .isMultiTypeVechiles
                                        ? context
                                            .read<BookingBloc>()
                                            .sortedEtaDetailsList[context
                                                .read<BookingBloc>()
                                                .selectedVehicleIndex]
                                            .total
                                        : context
                                            .read<BookingBloc>()
                                            .etaDetailsList[context
                                                .read<BookingBloc>()
                                                .selectedVehicleIndex]
                                            .total)) {
                                  Navigator.pop(context);
                                  if (widget.arg.transportType == 'taxi' ||
                                      (widget.arg.transportType == 'delivery' &&
                                          context
                                                  .read<BookingBloc>()
                                                  .selectedGoodsTypeId !=
                                              0)) {
                                    log("--- try co-share ====");

                                    //===start/============/
                                    showModalBottomSheet<void>(
                                      isScrollControlled: true,
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15)),
                                      ),
                                      builder: (_) {
                                        return BlocProvider.value(
                                          value: context.read<BookingBloc>(),
                                          child: StatefulBuilder(
                                              builder: (context, setState) {
                                            return Stack(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                          horizontal: 20)
                                                      .copyWith(top: 40),
                                                  height: size.height * 0.5,
                                                  child: Column(
                                                    children: [
                                                      MyText(
                                                        text: "Try Co-Share",
                                                        textStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      SizedBox(height: 20),
                                                      MyText(
                                                        text:
                                                            "With Co-Share, you can carry other passengers\nalong your route",
                                                        textStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.03,
                                                      ),
                                                      SizedBox(height: 20),
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            width: size.width *
                                                                0.8,
                                                            child:
                                                                ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .primary),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                log("---is_co_share:false");

                                                                context
                                                                    .read<
                                                                        BookingBloc>()
                                                                    .add(
                                                                      BiddingCreateRequestEvent(
                                                                        userData: widget
                                                                            .arg
                                                                            .userData,
                                                                        vehicleData: context.read<BookingBloc>().isMultiTypeVechiles
                                                                            ? context.read<BookingBloc>().sortedEtaDetailsList[context.read<BookingBloc>().selectedVehicleIndex]
                                                                            : context.read<BookingBloc>().etaDetailsList[context.read<BookingBloc>().selectedVehicleIndex],
                                                                        pickupAddressList: widget
                                                                            .arg
                                                                            .pickupAddressList,
                                                                        dropAddressList: widget
                                                                            .arg
                                                                            .stopAddressList,
                                                                        selectedTransportType: widget
                                                                            .arg
                                                                            .transportType,
                                                                        paidAt: context.read<BookingBloc>().payAtDrop
                                                                            ? 'Receiver'
                                                                            : 'Sender',
                                                                        selectedPaymentType: context
                                                                            .read<BookingBloc>()
                                                                            .selectedPaymentType,
                                                                        scheduleDateTime: context
                                                                            .read<BookingBloc>()
                                                                            .scheduleDateTime,
                                                                        goodsTypeId: context
                                                                            .read<BookingBloc>()
                                                                            .selectedGoodsTypeId
                                                                            .toString(),
                                                                        goodsQuantity: context
                                                                            .read<BookingBloc>()
                                                                            .goodsQtyController
                                                                            .text,
                                                                        offeredRideFare: context
                                                                            .read<BookingBloc>()
                                                                            .farePriceController
                                                                            .text,
                                                                        polyLine: context
                                                                            .read<BookingBloc>()
                                                                            .polyLine,
                                                                        isPetAvailable: context
                                                                            .read<BookingBloc>()
                                                                            .petPreference,
                                                                        isLuggageAvailable: context
                                                                            .read<BookingBloc>()
                                                                            .luggagePreference,
                                                                        isOutstationRide: widget
                                                                            .arg
                                                                            .isOutstationRide,
                                                                        isRoundTrip: context
                                                                            .read<BookingBloc>()
                                                                            .isRoundTrip,
                                                                        scheduleDateTimeForReturn: context
                                                                            .read<BookingBloc>()
                                                                            .scheduleDateTimeForReturn,
                                                                      ),
                                                                    );

                                                                // context.read<BookingBloc>().add((
                                                                //     userData: widget
                                                                //         .arg
                                                                //         .userData,
                                                                //     vehicleData: context.read<BookingBloc>().isMultiTypeVechiles
                                                                //         ? context.read<BookingBloc>().sortedEtaDetailsList[context
                                                                //             .read<
                                                                //                 BookingBloc>()
                                                                //             .selectedVehicleIndex]
                                                                //         : context.read<BookingBloc>().etaDetailsList[context
                                                                //             .read<
                                                                //                 BookingBloc>()
                                                                //             .selectedVehicleIndex],
                                                                //     pickupAddressList: widget
                                                                //         .arg
                                                                //         .pickupAddressList,
                                                                //     dropAddressList: widget
                                                                //         .arg
                                                                //         .stopAddressList,
                                                                //     selectedTransportType: widget
                                                                //         .arg
                                                                //         .transportType,
                                                                //     paidAt: context.read<BookingBloc>().payAtDrop
                                                                //         ? 'Receiver'
                                                                //         : 'Sender',
                                                                //     selectedPaymentType: context
                                                                //         .read<BookingBloc>()
                                                                //         .selectedPaymentType,
                                                                //     scheduleDateTime: context.read<BookingBloc>().scheduleDateTime,
                                                                //     goodsTypeId: context.read<BookingBloc>().selectedGoodsTypeId.toString(),
                                                                //     goodsQuantity: context.read<BookingBloc>().goodsQtyController.text,
                                                                //     offeredRideFare: context.read<BookingBloc>().farePriceController.text,
                                                                //     polyLine: context.read<BookingBloc>().polyLine,
                                                                //     isPetAvailable: context.read<BookingBloc>().petPreference,
                                                                //     isLuggageAvailable: context.read<BookingBloc>().luggagePreference,
                                                                //     isOutstationRide: widget.arg.isOutstationRide,
                                                                //     isRoundTrip: context.read<BookingBloc>().isRoundTrip,
                                                                //     scheduleDateTimeForReturn: context.read<BookingBloc>().scheduleDateTimeForReturn));
                                                              },
                                                              child: Text(
                                                                "Skip",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  size.height *
                                                                      0.05),
                                                          ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .grey),
                                                            onPressed: () {
                                                              //try co-share modal
                                                              //second popup modal

                                                              log("---is_co_share:true");
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              showModalBottomSheet<
                                                                  void>(
                                                                isScrollControlled:
                                                                    true,
                                                                context:
                                                                    context,
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            15),
                                                                    topRight: Radius
                                                                        .circular(
                                                                      15,
                                                                    ),
                                                                  ),
                                                                ),
                                                                builder: (_) {
                                                                  int coShareMaxSeats =
                                                                      1;
                                                                  return BlocProvider
                                                                      .value(
                                                                    value: context
                                                                        .read<
                                                                            BookingBloc>(),
                                                                    child: StatefulBuilder(builder:
                                                                        (context,
                                                                            setState) {
                                                                      return Stack(
                                                                        children: [
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 20).copyWith(top: 40),
                                                                            height: MediaQuery.of(context).viewInsets.bottom == 0
                                                                                ? size.height * 0.4
                                                                                : size.height * 0.4,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    MyText(
                                                                                      text: "Number of co-sharer",
                                                                                      textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 10),
                                                                                Divider(),
                                                                                SizedBox(height: 20),
                                                                                MyText(
                                                                                  text: "How many co-sharer do you want on this trip?",
                                                                                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                ),
                                                                                SizedBox(height: 20),

                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          if (coShareMaxSeats > 1) coShareMaxSeats--;
                                                                                        });
                                                                                        // context.read<BookingBloc>().add(
                                                                                        //       AdjustMaxSeatEvent(
                                                                                        //         isAdd: false,
                                                                                        //       ),
                                                                                        //     );
                                                                                      },
                                                                                      child: Container(
                                                                                        padding: EdgeInsets.all(2),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(2),
                                                                                          border: Border.all(color: Colors.red),
                                                                                          color: Colors.red.withOpacity(
                                                                                            0.4,
                                                                                          ),
                                                                                        ),
                                                                                        child: Icon(
                                                                                          Icons.remove,
                                                                                          color: Colors.red,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(width: 10),
                                                                                    MyText(
                                                                                      text: "${coShareMaxSeats}", //this is not updating
                                                                                      textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 20,
                                                                                          ),
                                                                                    ),
                                                                                    SizedBox(width: 10),
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        // context.read<BookingBloc>().add(
                                                                                        //       AdjustMaxSeatEvent(
                                                                                        //         isAdd: true,
                                                                                        //       ),
                                                                                        //     );

                                                                                        setState(() {
                                                                                          if (coShareMaxSeats < 3) coShareMaxSeats++;
                                                                                        });
                                                                                      },
                                                                                      child: Container(
                                                                                        padding: EdgeInsets.all(2),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(2),
                                                                                          border: Border.all(color: Colors.green),
                                                                                          color: Colors.green.withOpacity(
                                                                                            0.4,
                                                                                          ),
                                                                                        ),
                                                                                        child: Icon(
                                                                                          Icons.add,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                //   DropdownExample(
                                                                                //  onchanged:   (val){

                                                                                //  }
                                                                                //   ),

                                                                                SizedBox(
                                                                                  height: size.height * 0.025,
                                                                                ),
                                                                                // SizedBox(
                                                                                //     height:
                                                                                //         20),
                                                                                Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: ElevatedButton(
                                                                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                                                                        //#609400 green //#FFD700 yellow //purple #5700C2 blue #2D7CD0 red #C20000 //brown #CD7F32
                                                                                        onPressed: () {
                                                                                          context.read<BookingBloc>().add(
                                                                                          MaxCoShareSeatEvent(
                                                                                            coShareMaxSeats: coShareMaxSeats,
                                                                                          ),

                                                                                          );
                                                                                          context.read<BookingBloc>().add(
                                                                                                BiddingCreateRequestEvent(
                                                                                                  userData: widget.arg.userData,
                                                                                                  vehicleData: context.read<BookingBloc>().isMultiTypeVechiles ? context.read<BookingBloc>().sortedEtaDetailsList[context.read<BookingBloc>().selectedVehicleIndex] : context.read<BookingBloc>().etaDetailsList[context.read<BookingBloc>().selectedVehicleIndex],
                                                                                                  pickupAddressList: widget.arg.pickupAddressList,
                                                                                                  dropAddressList: widget.arg.stopAddressList,
                                                                                                  selectedTransportType: widget.arg.transportType,
                                                                                                  paidAt: context.read<BookingBloc>().payAtDrop ? 'Receiver' : 'Sender',
                                                                                                  selectedPaymentType: context.read<BookingBloc>().selectedPaymentType,
                                                                                                  scheduleDateTime: context.read<BookingBloc>().scheduleDateTime,
                                                                                                  goodsTypeId: context.read<BookingBloc>().selectedGoodsTypeId.toString(),
                                                                                                  goodsQuantity: context.read<BookingBloc>().goodsQtyController.text,
                                                                                                  offeredRideFare: context.read<BookingBloc>().farePriceController.text,
                                                                                                  polyLine: context.read<BookingBloc>().polyLine,
                                                                                                  isPetAvailable: context.read<BookingBloc>().petPreference,
                                                                                                  isLuggageAvailable: context.read<BookingBloc>().luggagePreference,
                                                                                                  isOutstationRide: widget.arg.isOutstationRide,
                                                                                                  isRoundTrip: context.read<BookingBloc>().isRoundTrip,
                                                                                                  scheduleDateTimeForReturn: context.read<BookingBloc>().scheduleDateTimeForReturn,
                                                                                                ),
                                                                                              );
                                                                                          Navigator.of(context).pop();
                                                                                          // context.read<BookingBloc>().add(BiddingCreateRequestEvent(userData: widget.arg.userData, vehicleData: context.read<BookingBloc>().isMultiTypeVechiles ? context.read<BookingBloc>().sortedEtaDetailsList[context.read<BookingBloc>().selectedVehicleIndex] : context.read<BookingBloc>().etaDetailsList[context.read<BookingBloc>().selectedVehicleIndex], pickupAddressList: widget.arg.pickupAddressList, dropAddressList: widget.arg.stopAddressList, selectedTransportType: widget.arg.transportType, paidAt: context.read<BookingBloc>().payAtDrop ? 'Receiver' : 'Sender', selectedPaymentType: context.read<BookingBloc>().selectedPaymentType, scheduleDateTime: context.read<BookingBloc>().scheduleDateTime, goodsTypeId: context.read<BookingBloc>().selectedGoodsTypeId.toString(), goodsQuantity: context.read<BookingBloc>().goodsQtyController.text, offeredRideFare: context.read<BookingBloc>().farePriceController.text, polyLine: context.read<BookingBloc>().polyLine, isPetAvailable: context.read<BookingBloc>().petPreference, isLuggageAvailable: context.read<BookingBloc>().luggagePreference, isOutstationRide: widget.arg.isOutstationRide, isRoundTrip: context.read<BookingBloc>().isRoundTrip, scheduleDateTimeForReturn: context.read<BookingBloc>().scheduleDateTimeForReturn));
                                                                                        },
                                                                                        child: Text(
                                                                                          "Proceed",
                                                                                          style: TextStyle(color: Colors.white),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                            right:
                                                                                20,
                                                                            top:
                                                                                20,
                                                                            child:
                                                                                InkWell(
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
                                                            child: Text(
                                                              "Try co share",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                                                      Navigator.of(context)
                                                          .pop();
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
                                      },
                                    );

                                    ///

                                    //===end======//

                                    // context.read<BookingBloc>().add(BiddingCreateRequestEvent(
                                    //     userData: arg.userData,
                                    //     vehicleData: context.read<BookingBloc>().isMultiTypeVechiles
                                    //         ? context.read<BookingBloc>().sortedEtaDetailsList[context
                                    //             .read<BookingBloc>()
                                    //             .selectedVehicleIndex]
                                    //         : context.read<BookingBloc>().etaDetailsList[context
                                    //             .read<BookingBloc>()
                                    //             .selectedVehicleIndex],
                                    //     pickupAddressList: arg.pickupAddressList,
                                    //     dropAddressList: arg.stopAddressList,
                                    //     selectedTransportType: arg.transportType,
                                    //     paidAt: context.read<BookingBloc>().payAtDrop
                                    //         ? 'Receiver'
                                    //         : 'Sender',
                                    //     selectedPaymentType:
                                    //         context.read<BookingBloc>().selectedPaymentType,
                                    //     scheduleDateTime:
                                    //         context.read<BookingBloc>().scheduleDateTime,
                                    //     goodsTypeId: context
                                    //         .read<BookingBloc>()
                                    //         .selectedGoodsTypeId
                                    //         .toString(),
                                    //     goodsQuantity: context
                                    //         .read<BookingBloc>()
                                    //         .goodsQtyController
                                    //         .text,
                                    //     offeredRideFare: context
                                    //         .read<BookingBloc>()
                                    //         .farePriceController
                                    //         .text,
                                    //     polyLine: context.read<BookingBloc>().polyLine,
                                    //     isPetAvailable:
                                    //         context.read<BookingBloc>().petPreference,
                                    //     isLuggageAvailable:
                                    //         context.read<BookingBloc>().luggagePreference,
                                    //     isOutstationRide: arg.isOutstationRide,
                                    //     isRoundTrip: context.read<BookingBloc>().isRoundTrip,
                                    //     scheduleDateTimeForReturn: context.read<BookingBloc>().scheduleDateTimeForReturn));
                                  } else {
                                    log("---Please select credentials error");
                                    showToast(
                                        message: "Please select credentials");
                                  }
                                } else {
                                  showModalBottomSheet(
                                    context: context,
                                    isDismissible: true,
                                    enableDrag: false,
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.0),
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    builder: (_) {
                                      return BlocProvider.value(
                                        value: context.read<BookingBloc>(),
                                        child: Container(
                                          width: size.width,
                                          height: size.width * 0.5,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          )),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                MyText(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .minimumRideFareError,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .error),
                                                ),
                                                SizedBox(
                                                    height: size.width * 0.1),
                                                CustomButton(
                                                  width: size.width,
                                                  buttonName:
                                                      AppLocalizations.of(
                                                              context)!
                                                          .okText,
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height: size.width * 0.05),
                        ],
                      ),
                    ),
                  ),
                );

                ///////////biddingPriceOffer end//////
              },
            );
          } else if (state is BiddingCreateRequestSuccessState) {
            log("--BiddingCreateRequestSuccessState here===");

            context.read<BookingBloc>().timerCount(context,
                isNormalRide: false,
                duration: int.parse(widget
                    .arg.userData.maximumTimeForFindDriversForRegularRide));
          } else if (state is BookingCreateRequestSuccessState) {
            log("--BookingCreateRequestSuccessState here===");
            context.read<BookingBloc>().timerCount(context,
                isNormalRide: true,
                duration: int.parse(widget
                    .arg.userData.maximumTimeForFindDriversForRegularRide));
          } else if (state is BookingNoDriversFoundState) {
            log("---no driver found here===");
            final bookingBloc = context.read<BookingBloc>();
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              elevation: 0,
              barrierColor: Theme.of(context).shadowColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              builder: (_) {
                return BlocProvider.value(
                  value: bookingBloc,
                  child: const NoDriverFoundWidget(),
                );
              },
            );
          } else if (state is BookingLaterCreateRequestSuccessState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return PopScope(
                  canPop: false,
                  child: CustomSingleButtonDialoge(
                    title: AppLocalizations.of(context)!.success,
                    content:
                        AppLocalizations.of(context)!.rideScheduledSuccessfully,
                    btnName: AppLocalizations.of(context)!.okText,
                    onTap: () {
                      context
                          .read<BookingBloc>()
                          .nearByVechileSubscription
                          ?.cancel();
                      Navigator.pop(context);
                      if (state.isOutstation) {
                        Navigator.pushNamed(
                            context, OutstationHistoryPage.routeName,
                            arguments: OutstationHistoryPageArguments(
                                isFromBooking: true));
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomePage.routeName, (route) => false);
                      }
                    },
                  ),
                );
              },
            );
          } else if (state is BookingOnTripRequestState) {
            Navigator.pop(context);
          } else if (state is CancelReasonState) {
            final bookingBloc = context.read<BookingBloc>();
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              isScrollControlled: true,
              showDragHandle: false,
              elevation: 0,
              barrierColor: AppColors.transparent,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              builder: (_) {
                return BlocProvider.value(
                  value: bookingBloc,
                  child: const SelectCancelReasonList(),
                );
              },
            );
          } else if (state is ChatWithDriverState) {
            final bookingBloc = context.read<BookingBloc>();
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              isScrollControlled: true,
              showDragHandle: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              barrierColor: AppColors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              builder: (_) {
                return BlocProvider.value(
                  value: bookingBloc,
                  child: const ChatWithDriverWidget(),
                );
              },
            );
          } else if (state is TripRideCancelState) {
            if (state.isCancelByDriver) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return PopScope(
                    canPop: false,
                    child: CustomSingleButtonDialoge(
                      title: AppLocalizations.of(context)!.rideCancelled,
                      content:
                          AppLocalizations.of(context)!.rideCancelledByDriver,
                      btnName: AppLocalizations.of(context)!.okText,
                      onTap: () {
                        context
                            .read<BookingBloc>()
                            .nearByVechileSubscription
                            ?.cancel();
                        Navigator.pop(context);
                        context.read<BookingBloc>().isTripStart = false;
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomePage.routeName, (route) => false);
                      },
                    ),
                  );
                },
              );
            } else if (!state.isCancelByDriver) {
              context.read<BookingBloc>().nearByVechileSubscription?.cancel();
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            }
          } else if (state is SosState) {
            final bookingBloc = context.read<BookingBloc>();
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              useRootNavigator: true,
              isScrollControlled: true,
              elevation: 0,
              barrierColor: Theme.of(context).shadowColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              builder: (_) {
                return BlocProvider.value(
                    value: bookingBloc, child: const SOSAlertWidget());
              },
            );
          } else if (state is TripCompletedState) {
            context.read<BookingBloc>().nearByVechileSubscription?.cancel();
            Navigator.pushNamedAndRemoveUntil(
                context,
                TripSummaryPage.routeName,
                arguments: TripSummaryPageArguments(
                    requestData: context.read<BookingBloc>().requestData!,
                    requestBillData:
                        context.read<BookingBloc>().requestBillData!,
                    driverData: context.read<BookingBloc>().driverData!),
                (route) => false);
          } else if (state is EtaNotAvailableState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return PopScope(
                  canPop: false,
                  child: CustomSingleButtonDialoge(
                    title: AppLocalizations.of(context)!.noDataAvailable,
                    content: AppLocalizations.of(context)!.noDriverFound,
                    btnName: AppLocalizations.of(context)!.okText,
                    onTap: () {
                      context
                          .read<BookingBloc>()
                          .nearByVechileSubscription
                          ?.cancel();
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomePage.routeName, (route) => false);
                    },
                  ),
                );
              },
            );
          } else if (state is RentalPackageSelectState) {
            final bookingBloc = context.read<BookingBloc>();
            bookingBloc.add(BookingRentalEtaRequestEvent(
              picklat: widget.arg.picklat,
              picklng: widget.arg.picklng,
              transporttype: bookingBloc.transportType,
            ));
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: true,
                  barrierColor: Theme.of(context).shadowColor,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  builder: (_) {
                    return BlocProvider.value(
                      value: bookingBloc,
                      child: PopScope(
                          canPop: false,
                          child: packageList(context, widget.arg)),
                    );
                  },
                ).whenComplete(
                  () {
                    if (bookingBloc.rentalEtaDetailsList.isEmpty) {
                      bookingBloc.add(BookingNavigatorPopEvent());
                    }
                  },
                );
              },
            );
          } else if (state is RentalPackageConfirmState) {
            if (context.read<BookingBloc>().rentalEtaDetailsList.isNotEmpty) {
              Navigator.pop(context);
            } else {
              log("----:no driver found");

              showToast(message: AppLocalizations.of(context)!.noDriverFound);
            }
          } else if (state is BookingRequestCancelState) {
            log("---state is BookingRequestCancelState");
            context.read<BookingBloc>().nearByVechileSubscription?.cancel();
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (route) => false);
          }
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            final size = MediaQuery.sizeOf(context);
            if (widget.arg.mapType == 'google_map') {
              if (Theme.of(context).brightness == Brightness.dark) {
                if (context.read<BookingBloc>().googleMapController != null) {
                  context
                      .read<BookingBloc>()
                      .googleMapController!
                      .setMapStyle(context.read<BookingBloc>().darkMapString);
                }
              } else {
                if (context.read<BookingBloc>().googleMapController != null) {
                  context
                      .read<BookingBloc>()
                      .googleMapController!
                      .setMapStyle(context.read<BookingBloc>().lightMapString);
                }
              }
            }
            return Material(
              child: Directionality(
                textDirection:
                    context.read<BookingBloc>().textDirection == 'rtl'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                child: PopScope(
                  canPop: true,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    // body: Center(
                    //   child: Text("datadsv lkdsa vdk"),
                    // ),
                    body: bodyWidget(size, context),
                    bottomNavigationBar: (context
                                .read<BookingBloc>()
                                .isNormalRideSearching ||
                            context.read<BookingBloc>().isBiddingRideSearching)
                        ? null
                        : (!context.read<BookingBloc>().isTripStart)
                            ? ((!context.read<BookingBloc>().isRentalRide &&
                                        context
                                            .read<BookingBloc>()
                                            .etaDetailsList
                                            .isNotEmpty) ||
                                    (context.read<BookingBloc>().isRentalRide &&
                                        context
                                            .read<BookingBloc>()
                                            .rentalEtaDetailsList
                                            .isNotEmpty))
                                ? confirmButtonWidget(size, context)
                                : null
                            : null,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget bodyWidget(Size size, BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            (widget.arg.mapType == 'google_map')
                // GOOGLE MAP
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: size.height,
                        width: size.width,
                        child: GoogleMap(
                          padding: EdgeInsets.fromLTRB(
                              size.width * 0.05,
                              (context.read<BookingBloc>().requestData != null)
                                  ? size.width * 0.10 +
                                      MediaQuery.of(context).padding.top
                                  : size.width * 0.05 +
                                      MediaQuery.of(context).padding.top,
                              size.width * 0.05,
                              size.width * 0.8),
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
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
                          markers: (context
                                      .read<BookingBloc>()
                                      .isNormalRideSearching ||
                                  context
                                      .read<BookingBloc>()
                                      .isBiddingRideSearching)
                              ? {}
                              : Set.from(
                                  context.read<BookingBloc>().markerList),
                          polylines: (context
                                      .read<BookingBloc>()
                                      .isNormalRideSearching ||
                                  context
                                      .read<BookingBloc>()
                                      .isBiddingRideSearching)
                              ? {}
                              : context.read<BookingBloc>().polylines,
                          rotateGesturesEnabled: (context
                                      .read<BookingBloc>()
                                      .isNormalRideSearching ||
                                  context
                                      .read<BookingBloc>()
                                      .isBiddingRideSearching)
                              ? false
                              : true,
                          zoomGesturesEnabled: (context
                                      .read<BookingBloc>()
                                      .isNormalRideSearching ||
                                  context
                                      .read<BookingBloc>()
                                      .isBiddingRideSearching)
                              ? false
                              : true,
                          scrollGesturesEnabled: (context
                                      .read<BookingBloc>()
                                      .isNormalRideSearching ||
                                  context
                                      .read<BookingBloc>()
                                      .isBiddingRideSearching)
                              ? false
                              : true,
                        ),
                      ),
                      if (context.read<BookingBloc>().isNormalRideSearching ||
                          context.read<BookingBloc>().isBiddingRideSearching)
                        AvatarGlow(
                          glowColor: AppColors.green,
                          glowRadiusFactor: 2.5,
                          glowCount: 8,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: Image.asset(
                              AppImages.confirmationPin,
                              height: 30,
                            ),
                          ),
                        ),
                    ],
                  )

                // OPEN STREET
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: size.height,
                        width: size.width,
                        child: fm.FlutterMap(
                          mapController:
                              context.read<BookingBloc>().fmController,
                          options: fm.MapOptions(
                            onTap: (tapPosition, latLng) {},
                            onMapEvent: (v) async {},
                            onPositionChanged: (p, l) async {},
                            initialCenter: fmlt.LatLng(
                                AppConstants.currentLocations.latitude,
                                AppConstants.currentLocations.longitude),
                            initialZoom: 16,
                            minZoom: 5,
                            maxZoom: 20,
                          ),
                          children: [
                            fm.TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            if (!context
                                    .read<BookingBloc>()
                                    .isNormalRideSearching &&
                                !context
                                    .read<BookingBloc>()
                                    .isBiddingRideSearching)
                              fm.MarkerLayer(
                                markers: List.generate(
                                    context
                                        .read<BookingBloc>()
                                        .markerList
                                        .length, (index) {
                                  final marker = context
                                      .read<BookingBloc>()
                                      .markerList
                                      .elementAt(index);
                                  return fm.Marker(
                                    point: fmlt.LatLng(marker.position.latitude,
                                        marker.position.longitude),
                                    alignment: Alignment.topCenter,
                                    child: RotationTransition(
                                      turns: AlwaysStoppedAnimation(
                                          marker.rotation / 360),
                                      child: Image.asset(
                                        marker.markerId.value.toString() ==
                                                'pick'
                                            ? AppImages.pickPin
                                            : (marker.markerId.value
                                                            .toString() ==
                                                        'drop' ||
                                                    marker.markerId.value
                                                        .toString()
                                                        .contains('drop'))
                                                ? AppImages.dropPin
                                                : (marker.markerId.value
                                                        .toString()
                                                        .contains('truck'))
                                                    ? AppImages.truck
                                                    : marker.markerId.value
                                                            .toString()
                                                            .contains(
                                                                'motor_bike')
                                                        ? AppImages.bike
                                                        : marker.markerId.value
                                                                .toString()
                                                                .contains(
                                                                    'auto')
                                                            ? AppImages.auto
                                                            : marker.markerId
                                                                    .value
                                                                    .toString()
                                                                    .contains(
                                                                        'lcv')
                                                                ? AppImages.lcv
                                                                : marker.markerId
                                                                        .value
                                                                        .toString()
                                                                        .contains(
                                                                            'ehcv')
                                                                    ? AppImages
                                                                        .ehcv
                                                                    : marker.markerId
                                                                            .value
                                                                            .toString()
                                                                            .contains('hatchback')
                                                                        ? AppImages.hatchBack
                                                                        : marker.markerId.value.toString().contains('hcv')
                                                                            ? AppImages.hcv
                                                                            : marker.markerId.value.toString().contains('mcv')
                                                                                ? AppImages.mcv
                                                                                : marker.markerId.value.toString().contains('luxury')
                                                                                    ? AppImages.luxury
                                                                                    : marker.markerId.value.toString().contains('premium')
                                                                                        ? AppImages.premium
                                                                                        : marker.markerId.value.toString().contains('suv')
                                                                                            ? AppImages.suv
                                                                                            : (marker.markerId.value.toString().contains('car'))
                                                                                                ? AppImages.car
                                                                                                : '',
                                        width: 16,
                                        height: 30,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const SizedBox();
                                        },
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            if (!context
                                    .read<BookingBloc>()
                                    .isNormalRideSearching &&
                                !context
                                    .read<BookingBloc>()
                                    .isBiddingRideSearching)
                              fm.PolylineLayer(
                                polylines: [
                                  fm.Polyline(
                                      points:
                                          context.read<BookingBloc>().fmpoly,
                                      color: Theme.of(context).primaryColor,
                                      strokeWidth: 4),
                                ],
                              ),
                            const fm.RichAttributionWidget(
                              attributions: [],
                            ),
                          ],
                        ),
                      ),
                      if (context.read<BookingBloc>().isNormalRideSearching ||
                          context.read<BookingBloc>().isBiddingRideSearching)
                        AvatarGlow(
                          glowColor: AppColors.green,
                          glowRadiusFactor: 2.0,
                          glowCount: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: Image.asset(
                              AppImages.confirmationPin,
                              height: 30,
                            ),
                          ),
                        ),
                    ],
                  ),
            if (!context.read<BookingBloc>().isNormalRideSearching &&
                !context.read<BookingBloc>().isBiddingRideSearching)

              ///arrow back button
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.05),
                  child: Row(
                    children: [
                      if ((widget.arg.isRentalRide != null &&
                              widget.arg.isRentalRide! &&
                              context
                                  .read<BookingBloc>()
                                  .rentalEtaDetailsList
                                  .isNotEmpty) ||
                          widget.arg.isRentalRide == null ||
                          !widget.arg.isRentalRide!)
                        NavigationIconWidget(
                          onTap: () {
                            context
                                .read<BookingBloc>()
                                .add(BookingNavigatorPopEvent());
                          },
                          icon: Icon(Icons.arrow_back_ios_new_rounded,
                              size: 20,
                              color: Theme.of(context).primaryColorDark),
                          isShadowWidget: true,
                        ),
                    ],
                  ),
                ),
              ),
            Positioned(
              bottom: size.height * 0.55,
              right: size.width * 0.03,
              child: Column(
                children: [
                  if (!context.read<BookingBloc>().isNormalRideSearching &&
                      !context.read<BookingBloc>().isBiddingRideSearching)
                    InkWell(
                      onTap: () {
                        if (context.read<BookingBloc>().googleMapController !=
                                null &&
                            context.read<BookingBloc>().bound != null) {
                          context
                              .read<BookingBloc>()
                              .googleMapController
                              ?.animateCamera(CameraUpdate.newLatLngBounds(
                                  context.read<BookingBloc>().bound!, 100));
                        }
                      },
                      child: Container(
                        height: size.width * 0.11,
                        width: size.width * 0.11,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          border: Border.all(
                            width: 1.2,
                            color: AppColors.black.withOpacity(0.8),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.my_location,
                            size: size.width * 0.05,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: size.width * 0.02),
                  if (context.read<BookingBloc>().requestData != null &&
                      context.read<BookingBloc>().requestData!.isTripStart ==
                          1) ...[
                    InkWell(
                      onTap: () async {
                        await Share.share(
                            'Your Driver is ${context.read<BookingBloc>().driverData!.name}. ${context.read<BookingBloc>().driverData!.carColor} ${context.read<BookingBloc>().driverData!.carMakeName} ${context.read<BookingBloc>().driverData!.carModelName}, Vehicle Number: ${context.read<BookingBloc>().driverData!.carNumber}. Track with link: ${AppConstants.baseUrl}track/request/${context.read<BookingBloc>().requestData!.id}');
                      },
                      child: Container(
                        height: size.width * 0.11,
                        width: size.width * 0.11,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          border: Border.all(
                            width: 1.2,
                            color: AppColors.black.withOpacity(0.8),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.share,
                          size: size.width * 0.05,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<BookingBloc>().add(SOSEvent());
                      },
                      child: Container(
                        height: size.width * 0.18,
                        width: size.width * 0.18,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(AppImages.sosImage),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        (context.read<BookingBloc>().isBiddingRideSearching)
            ? AnimatedPositioned(
                bottom: 0,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 100),
                child: GestureDetector(
                  onVerticalDragStart: (details) {
                    context.read<BookingBloc>().onRideBottomCurrentHeight =
                        details.globalPosition.dy;
                  },
                  onVerticalDragUpdate: (details) {
                    double deltaY = details.globalPosition.dy -
                        context.read<BookingBloc>().onRideBottomCurrentHeight;
                    double newPosition =
                        context.read<BookingBloc>().onRideBottomPosition -
                            deltaY;

                    // Set bounds for the new position
                    if (newPosition > 0) {
                      newPosition = 0; // Prevent going above screen
                    }
                    if (newPosition > size.height * 0.6) {
                      newPosition = size.height * 0.3; // Max height
                    }

                    context.read<BookingBloc>().onRideBottomPosition =
                        newPosition;

                    context.read<BookingBloc>().onRideBottomCurrentHeight =
                        details.globalPosition
                            .dy; // Update the drag start position
                    context.read<BookingBloc>().add(UpdateEvent());
                  },
                  onVerticalDragEnd: (details) {
                    log('${context.read<BookingBloc>().onRideBottomPosition} < ${-size.height * 0.35}');
                    // Optional: snap to positions if needed
                    if (context.read<BookingBloc>().onRideBottomPosition <
                        -size.height * 0.35) {
                      context.read<BookingBloc>().onRideBottomPosition =
                          -size.height * 0.33; // Snap to the top
                      context.read<BookingBloc>().add(UpdateEvent());
                    } else {
                      context.read<BookingBloc>().onRideBottomPosition =
                          0.0; // Snap to the bottom
                      context.read<BookingBloc>().add(UpdateEvent());
                    }
                  },
                  child: BiddingWaitingForDriverConfirmation(
                    maximumTime: double.parse(widget
                        .arg.userData.maximumTimeForFindDriversForRegularRide),
                  ),
                ),
              )
            : (context.read<BookingBloc>().isNormalRideSearching)
                ? AnimatedPositioned(
                    bottom: context.read<BookingBloc>().onRideBottomPosition,
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 100),
                    child: GestureDetector(
                      onVerticalDragStart: (details) {
                        context.read<BookingBloc>().onRideBottomCurrentHeight =
                            details.globalPosition.dy;
                      },
                      onVerticalDragUpdate: (details) {
                        double deltaY = details.globalPosition.dy -
                            context
                                .read<BookingBloc>()
                                .onRideBottomCurrentHeight;
                        double newPosition =
                            context.read<BookingBloc>().onRideBottomPosition -
                                deltaY;

                        // Set bounds for the new position
                        if (newPosition > 0) {
                          newPosition = 0; // Prevent going above screen
                        }
                        if (newPosition > size.height * 0.6) {
                          newPosition = size.height * 0.3; // Max height
                        }

                        context.read<BookingBloc>().onRideBottomPosition =
                            newPosition;

                        context.read<BookingBloc>().onRideBottomCurrentHeight =
                            details.globalPosition
                                .dy; // Update the drag start position
                        context.read<BookingBloc>().add(UpdateEvent());
                      },
                      onVerticalDragEnd: (details) {
                        debugPrint(
                            '${context.read<BookingBloc>().onRideBottomPosition} < ${-size.height * 0.35}');
                        // Optional: snap to positions if needed
                        if (context.read<BookingBloc>().onRideBottomPosition <
                            -size.height * 0.35) {
                          context.read<BookingBloc>().onRideBottomPosition =
                              -size.height * 0.33; // Snap to the top
                          context.read<BookingBloc>().add(UpdateEvent());
                        } else {
                          context.read<BookingBloc>().onRideBottomPosition =
                              0.0; // Snap to the bottom
                          context.read<BookingBloc>().add(UpdateEvent());
                        }
                      },
                      child: WaitingForDriverConfirmation(
                        maximumTime: double.parse(widget.arg.userData
                            .maximumTimeForFindDriversForRegularRide),
                      ),
                    ),
                  )
                : (context.read<BookingBloc>().isTripStart)
                    ? AnimatedPositioned(
                        bottom:
                            context.read<BookingBloc>().onRideBottomPosition,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 100),
                        child: GestureDetector(
                          onVerticalDragStart: (details) {
                            context
                                    .read<BookingBloc>()
                                    .onRideBottomCurrentHeight =
                                details.globalPosition.dy;
                          },
                          onVerticalDragUpdate: (details) {
                            double deltaY = details.globalPosition.dy -
                                context
                                    .read<BookingBloc>()
                                    .onRideBottomCurrentHeight;
                            double newPosition = context
                                    .read<BookingBloc>()
                                    .onRideBottomPosition -
                                deltaY;

                            // Set bounds for the new position
                            if (newPosition > 0) {
                              newPosition = 0; // Prevent going above screen
                            }
                            if (newPosition > size.height * 0.6) {
                              newPosition = size.height * 0.3; // Max height
                            }

                            context.read<BookingBloc>().onRideBottomPosition =
                                newPosition;

                            context
                                    .read<BookingBloc>()
                                    .onRideBottomCurrentHeight =
                                details.globalPosition
                                    .dy; // Update the drag start position
                            context.read<BookingBloc>().add(UpdateEvent());
                          },
                          onVerticalDragEnd: (details) {
                            debugPrint(
                                '${context.read<BookingBloc>().onRideBottomPosition} < ${-size.height * 0.35}');
                            // Optional: snap to positions if needed
                            if (context
                                    .read<BookingBloc>()
                                    .onRideBottomPosition <
                                -size.height * 0.35) {
                              context.read<BookingBloc>().onRideBottomPosition =
                                  -size.height * 0.33; // Snap to the top
                              context.read<BookingBloc>().add(UpdateEvent());
                            } else {
                              context.read<BookingBloc>().onRideBottomPosition =
                                  0.0; // Snap to the bottom
                              context.read<BookingBloc>().add(UpdateEvent());
                            }
                          },
                          child: const OnRideBottomSheet(),
                        ),
                      )
                    : ((!context.read<BookingBloc>().isRentalRide &&
                                context
                                    .read<BookingBloc>()
                                    .etaDetailsList
                                    .isNotEmpty) ||
                            (context.read<BookingBloc>().isRentalRide &&
                                context
                                    .read<BookingBloc>()
                                    .rentalEtaDetailsList
                                    .isNotEmpty))
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: BlocBuilder<BookingBloc, BookingState>(
                              builder: (context, state) {
                                return StatefulBuilder(
                                  builder:
                                      (BuildContext context, StateSetter set) {
                                    return GestureDetector(
                                      onVerticalDragUpdate: (details) {
                                        final dragAmount =
                                            details.primaryDelta!;

                                        set(() {
                                          if (context
                                              .read<BookingBloc>()
                                              .detailView) {
                                            if (dragAmount > 0) {
                                              context
                                                  .read<BookingBloc>()
                                                  .detailView = false;
                                              context
                                                  .read<BookingBloc>()
                                                  .add(UpdateEvent());
                                            }
                                          } else {
                                            if (widget.arg.stopAddressList
                                                    .length ==
                                                1) {
                                              context
                                                  .read<BookingBloc>()
                                                  .currentSize = (context
                                                          .read<BookingBloc>()
                                                          .currentSize -
                                                      (dragAmount /
                                                          size.height))
                                                  .clamp(
                                                      context
                                                          .read<BookingBloc>()
                                                          .minChildSize,
                                                      context
                                                          .read<BookingBloc>()
                                                          .maxChildSize);
                                            } else if (widget.arg
                                                    .stopAddressList.length ==
                                                2) {
                                              context
                                                  .read<BookingBloc>()
                                                  .currentSizeTwo = (context
                                                          .read<BookingBloc>()
                                                          .currentSizeTwo -
                                                      (dragAmount /
                                                          size.height))
                                                  .clamp(
                                                      context
                                                          .read<BookingBloc>()
                                                          .minChildSizeTwo,
                                                      context
                                                          .read<BookingBloc>()
                                                          .maxChildSize);
                                            } else {
                                              context
                                                  .read<BookingBloc>()
                                                  .currentSizeThree = (context
                                                          .read<BookingBloc>()
                                                          .currentSizeThree -
                                                      (dragAmount /
                                                          size.height))
                                                  .clamp(
                                                      context
                                                          .read<BookingBloc>()
                                                          .minChildSizeThree,
                                                      context
                                                          .read<BookingBloc>()
                                                          .maxChildSize);
                                            }
                                          }
                                        });
                                      },
                                      onVerticalDragEnd: (details) {
                                        set(() {
                                          // Snap to position logic for non-detail view
                                          if (!context
                                              .read<BookingBloc>()
                                              .detailView) {
                                            if (widget.arg.stopAddressList
                                                    .length ==
                                                1) {
                                              context
                                                      .read<BookingBloc>()
                                                      .currentSize =
                                                  context
                                                      .read<BookingBloc>()
                                                      .snapToPosition(
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .currentSize,
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .minChildSize,
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .maxChildSize);
                                            } else if (widget.arg
                                                    .stopAddressList.length ==
                                                2) {
                                              context
                                                      .read<BookingBloc>()
                                                      .currentSizeTwo =
                                                  context
                                                      .read<BookingBloc>()
                                                      .snapToPosition(
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .currentSizeTwo,
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .minChildSizeTwo,
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .maxChildSize);
                                            } else {
                                              context
                                                      .read<BookingBloc>()
                                                      .currentSizeThree =
                                                  context
                                                      .read<BookingBloc>()
                                                      .snapToPosition(
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .currentSizeThree,
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .minChildSizeThree,
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .maxChildSize);
                                            }
                                          }
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        height: (context
                                                .read<BookingBloc>()
                                                .detailView)
                                            ? size.height *
                                                context
                                                    .read<BookingBloc>()
                                                    .maxChildSize
                                            : widget.arg.stopAddressList
                                                        .length ==
                                                    1
                                                ? (size.height *
                                                    (context
                                                            .read<BookingBloc>()
                                                            .currentSize +
                                                        (widget.arg
                                                                .isOutstationRide
                                                            ? 0.14
                                                            : 0)))
                                                : widget.arg.stopAddressList
                                                            .length ==
                                                        2
                                                    ? size.height *
                                                        context
                                                            .read<BookingBloc>()
                                                            .currentSizeTwo
                                                    : size.height *
                                                        context
                                                            .read<BookingBloc>()
                                                            .currentSizeThree,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(20.0),
                                          ),
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     color:
                                          //         Theme.of(context).shadowColor,
                                          //     blurRadius: 4.0,
                                          //     spreadRadius: 2.0,
                                          //   ),
                                          // ],
                                        ),
                                        child: SingleChildScrollView(
                                          physics: !context
                                                  .read<BookingBloc>()
                                                  .detailView
                                              ? const NeverScrollableScrollPhysics()
                                              : const AlwaysScrollableScrollPhysics(),
                                          child: (!context
                                                  .read<BookingBloc>()
                                                  .detailView)
                                              ? ridePreviewWidget(size, context)
                                              : rideDetailsExpandedWidget(
                                                  size,
                                                  context,
                                                  (context
                                                          .read<BookingBloc>()
                                                          .isRentalRide
                                                      ? context
                                                              .read<BookingBloc>()
                                                              .rentalEtaDetailsList[
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .selectedVehicleIndex]
                                                      : context
                                                              .read<
                                                                  BookingBloc>()
                                                              .isMultiTypeVechiles
                                                          ? context
                                                                  .read<
                                                                      BookingBloc>()
                                                                  .sortedEtaDetailsList[
                                                              context
                                                                  .read<
                                                                      BookingBloc>()
                                                                  .selectedVehicleIndex]
                                                          : context
                                                                  .read<
                                                                      BookingBloc>()
                                                                  .etaDetailsList[
                                                              context
                                                                  .read<
                                                                      BookingBloc>()
                                                                  .selectedVehicleIndex]),
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        : Align(
                            alignment: Alignment.bottomCenter,
                            child: EtaListShimmer(size: size))
      ],
    );
  }

  Widget ridePreviewWidget(Size size, BuildContext context) {
    return Container(
      height: size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(-1, -2),
            blurRadius: 10,
            spreadRadius: 2,
            color: Theme.of(context).shadowColor,
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: !context.read<BookingBloc>().showBiddingVehicles
                        ? size.width * 0.05
                        : size.width * 0.05),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CustomDivider()),
                  ],
                ),
                if (widget.arg.userData.enableModulesForApplications ==
                        'both' &&
                    widget.arg.isOutstationRide)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                      children: [
                        if (widget.arg.userData.showTaxiOutstationRideFeature ==
                            '1')
                          SizedBox(
                            width: size.width * 0.25,
                            child: Theme(
                              data: ThemeData(
                                  listTileTheme: const ListTileThemeData(
                                    contentPadding: EdgeInsets.zero,
                                    horizontalTitleGap: 0,
                                  ),
                                  unselectedWidgetColor:
                                      Theme.of(context).primaryColorDark),
                              child: RadioListTile(
                                value: 'taxi',
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                activeColor: Theme.of(context).primaryColorDark,
                                groupValue:
                                    context.read<BookingBloc>().transportType,
                                onChanged: (value) {
                                  context
                                      .read<BookingBloc>()
                                      .selectedPackageIndex = 0;
                                  context.read<BookingBloc>().transportType =
                                      value!;
                                  context.read<BookingBloc>().add(
                                      BookingEtaRequestEvent(
                                          picklat: widget.arg.picklat,
                                          picklng: widget.arg.picklng,
                                          droplat: widget.arg.droplat,
                                          droplng: widget.arg.droplng,
                                          ridetype: 1,
                                          transporttype: value,
                                          distance: context
                                              .read<BookingBloc>()
                                              .distance,
                                          duration: context
                                              .read<BookingBloc>()
                                              .duration,
                                          polyLine: widget.arg.polyString,
                                          pickupAddressList: context
                                              .read<BookingBloc>()
                                              .pickUpAddressList,
                                          dropAddressList: context
                                              .read<BookingBloc>()
                                              .dropAddressList,
                                          isOutstationRide:
                                              widget.arg.isOutstationRide,
                                          isWithoutDestinationRide: widget.arg
                                                  .isWithoutDestinationRide ??
                                              false));
                                  context
                                      .read<BookingBloc>()
                                      .add(UpdateEvent());
                                },
                                title: MyText(
                                    text: AppLocalizations.of(context)!.taxi,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge),
                              ),
                            ),
                          ),
                        if (widget.arg.userData
                                .showDeliveryOutstationRideFeature ==
                            '1')
                          SizedBox(
                            width: size.width * 0.35,
                            child: Theme(
                              data: ThemeData(
                                  listTileTheme: const ListTileThemeData(
                                    contentPadding: EdgeInsets.zero,
                                    horizontalTitleGap: 0,
                                  ),
                                  unselectedWidgetColor:
                                      Theme.of(context).primaryColorDark),
                              child: RadioListTile(
                                value: 'delivery',
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                activeColor: Theme.of(context).primaryColorDark,
                                groupValue:
                                    context.read<BookingBloc>().transportType,
                                onChanged: (value) {
                                  context
                                      .read<BookingBloc>()
                                      .selectedPackageIndex = 0;
                                  context.read<BookingBloc>().transportType =
                                      value!;
                                  context.read<BookingBloc>().add(
                                      BookingEtaRequestEvent(
                                          picklat: widget.arg.picklat,
                                          picklng: widget.arg.picklng,
                                          droplat: widget.arg.droplat,
                                          droplng: widget.arg.droplng,
                                          ridetype: 1,
                                          transporttype: value,
                                          distance: context
                                              .read<BookingBloc>()
                                              .distance,
                                          duration: context
                                              .read<BookingBloc>()
                                              .duration,
                                          polyLine: widget.arg.polyString,
                                          pickupAddressList: context
                                              .read<BookingBloc>()
                                              .pickUpAddressList,
                                          dropAddressList: context
                                              .read<BookingBloc>()
                                              .dropAddressList,
                                          isOutstationRide:
                                              widget.arg.isOutstationRide,
                                          isWithoutDestinationRide: widget.arg
                                                  .isWithoutDestinationRide ??
                                              false));
                                  context
                                      .read<BookingBloc>()
                                      .add(UpdateEvent());
                                },
                                title: MyText(
                                    text:
                                        AppLocalizations.of(context)!.delivery,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                SizedBox(height: size.width * 0.04),
                ////pick up addr starts here ===================
                ListView.builder(
                    itemCount: widget.arg.pickupAddressList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final address =
                          widget.arg.pickupAddressList.elementAt(index);
                      return Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.018),
                            child: const PickupIcon(),
                          ),
                          Expanded(
                            child: MyText(
                              text: address.address,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 13),
                            ),
                          ),
                        ],
                      );
                    }),

                ////pick up addr ends here ===================

                ////////drop off addr  start here
                if (widget.arg.stopAddressList.isNotEmpty) ...[
                  SizedBox(height: size.width * 0.02),
                  Divider(
                      indent: size.width * 0.12,
                      endIndent: size.width * 0.05,
                      color: Theme.of(context).dividerColor.withOpacity(0.4)),
                  ListView.separated(
                    itemCount: widget.arg.stopAddressList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final address =
                          widget.arg.stopAddressList.elementAt(index);
                      return Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.015),
                            child: const DropIcon(),
                          ),
                          Expanded(
                            child: MyText(
                              text: address.address,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 13),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                          indent: size.width * 0.073,
                          endIndent: size.width * 0.01,
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.4));
                    },
                  ),
                  SizedBox(height: size.width * 0.02),
                  Divider(
                      indent: size.width * 0.12,
                      endIndent: size.width * 0.05,
                      color: Theme.of(context).dividerColor.withOpacity(0.4)),
                  SizedBox(height: size.width * 0.03),
                ],
                ////////drop off addr  ends here=============================

                if (!context.read<BookingBloc>().isRentalRide &&
                    context.read<BookingBloc>().etaDetailsList.isNotEmpty) ...[
                  etaListViewWidget(size, context, widget.arg, this),
                ],

                //this is for rental=============

                if (context.read<BookingBloc>().isRentalRide &&
                    context
                        .read<BookingBloc>()
                        .rentalEtaDetailsList
                        .isNotEmpty) ...[
                  SizedBox(height: size.width * 0.02),
                  rentalEtaListViewWidget(size, context, widget.arg, this),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rideDetailsExpandedWidget(
      Size size, BuildContext context, dynamic eta) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        // color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        // boxShadow: [
        //   BoxShadow(
        //       offset: const Offset(-1, -2),
        //       blurRadius: 10,
        //       spreadRadius: 2,
        //       color: Theme.of(context).splashColor)
        // ],
      ),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          // color: Colors.grey,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: size.width * 0.05),
              const Center(child: CustomDivider()),
              SizedBox(height: size.width * 0.06),
              MyText(
                  text: widget.arg.title,
                  textStyle: Theme.of(context).textTheme.displayMedium),
              SizedBox(height: size.width * 0.06),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomContainer(
                      color: AppColors.primary.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Column(
                          children: [
                            // Text("pick upp===="),
                            ListView.builder(
                                itemCount: widget.arg.pickupAddressList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  final address = widget.arg.pickupAddressList
                                      .elementAt(index);
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .disabledColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.01),
                                            child: const PickupIcon(),
                                          ),
                                          Expanded(
                                            child: MyText(
                                              text: address.address,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            SizedBox(height: size.width * 0.01),
                            ListView.builder(
                                itemCount: widget.arg.stopAddressList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  final address = widget.arg.stopAddressList
                                      .elementAt(index);
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .disabledColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.width * 0.005),
                                              child: const DropIcon()),
                                          Expanded(
                                            child: MyText(
                                              text: address.address,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.width * 0.04),
                    CustomContainer(
                      color: AppColors.primary.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: CachedNetworkImage(
                                        imageUrl: (context
                                                .read<BookingBloc>()
                                                .isRentalRide)
                                            ? eta.icon
                                            : eta.vehicleIcon,
                                        height: size.width * 0.15,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: Loader(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                          child: Text(""),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.04),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          text: eta.name,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (context
                                          .read<BookingBloc>()
                                          .nearByEtaVechileList
                                          .isNotEmpty)
                                        MyText(
                                          text: context
                                              .read<BookingBloc>()
                                              .nearByEtaVechileList
                                              .elementAt(context
                                                  .read<BookingBloc>()
                                                  .nearByEtaVechileList
                                                  .indexWhere((element) =>
                                                      element.typeId ==
                                                      eta.typeId))
                                              .duration,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                context
                                    .read<BookingBloc>()
                                    .draggableScrollableController
                                    .animateTo(
                                        context
                                            .read<BookingBloc>()
                                            .draggableScrollableController
                                            .size,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeIn);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30))),
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.info_outline_rounded,
                                          size: 15),
                                      MyText(
                                        text: AppLocalizations.of(context)!
                                            .loadingUnloadingTimeInfo
                                            .replaceAll('**',
                                                '${(context.read<BookingBloc>().isRentalRide) ? (eta.freeMin) : (eta.freeWaitingTimeInMinsBeforeTripStart + eta.freeWaitingTimeInMinsAfterTripStart)}'),
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.width * 0.04),
                    if (!context.read<BookingBloc>().isRentalRide &&
                        !eta.enableBidding) ...[
                      InkWell(
                        onTap: () {
                          context.read<BookingBloc>().promoErrorText = '';
                          context.read<BookingBloc>().add(UpdateEvent());
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            barrierColor: Theme.of(context).shadowColor,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                            ),
                            builder: (_) {
                              return BlocProvider.value(
                                  value: context.read<BookingBloc>(),
                                  child: ApplyCouponWidget(arg: widget.arg));
                            },
                          );
                        },
                        child: CustomContainer(
                          color: AppColors.primary.withOpacity(0.2),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.percent_rounded,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                    MyText(
                                      text: AppLocalizations.of(context)!
                                          .applyCoupon,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColorDark),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    if (eta.hasDiscount)
                                      MyText(
                                        text: AppLocalizations.of(context)!
                                            .remove,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: AppColors.red),
                                      ),
                                    if (!eta.hasDiscount)
                                      const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 20)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.width * 0.04),
                    ],
                    CustomContainer(
                      color: AppColors.primary.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  text: AppLocalizations.of(context)!.tripFare,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color:
                                              Theme.of(context).disabledColor),
                                ),
                                MyText(
                                  text: AppLocalizations.of(context)!
                                      .amountPayable,
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                MyText(
                                    text:
                                        '${eta.currency} ${!context.read<BookingBloc>().isRentalRide ? eta.total.toStringAsFixed(1) : eta.fareAmount}',
                                    textStyle:
                                        Theme.of(context).textTheme.bodyMedium)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.width * 0.04),
                    CustomContainer(
                      color: AppColors.primary.withOpacity(0.2),
                      child: InkWell(
                        onTap: () {
                          context.read<BookingBloc>().add(GetGoodsTypeEvent());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: size.width * 0.7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: AppLocalizations.of(context)!
                                          .goodsType,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .disabledColor),
                                    ),
                                    Wrap(
                                      children: [
                                        MyText(
                                          text: (context
                                                      .read<BookingBloc>()
                                                      .selectedGoodsTypeId ==
                                                  0)
                                              ? AppLocalizations.of(context)!
                                                  .selectGoodsType
                                              : '${context.read<BookingBloc>().goodsTypeList.firstWhere((element) => element.id == context.read<BookingBloc>().selectedGoodsTypeId).goodsTypeName} ',
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!,
                                        ),
                                        if (context
                                                .read<BookingBloc>()
                                                .goodsTypeQtyOrLoose ==
                                            'Qty')
                                          MyText(
                                              text:
                                                  '| ${context.read<BookingBloc>().goodsQtyController.text}',
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!),
                                        if (context
                                                    .read<BookingBloc>()
                                                    .selectedGoodsTypeId !=
                                                0 &&
                                            context
                                                    .read<BookingBloc>()
                                                    .goodsTypeQtyOrLoose !=
                                                'Qty')
                                          MyText(
                                              text:
                                                  '| ${AppLocalizations.of(context)!.loose}',
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              MyText(
                                  text: (context
                                              .read<BookingBloc>()
                                              .selectedGoodsTypeId !=
                                          0)
                                      ? AppLocalizations.of(context)!
                                          .changeLower
                                      : AppLocalizations.of(context)!.select,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontWeight: FontWeight.w600))
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!context.read<BookingBloc>().isRentalRide) ...[
                      SizedBox(height: size.width * 0.04),
                      CustomContainer(
                        color: AppColors.primary.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    text: AppLocalizations.of(context)!.payment,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .disabledColor),
                                  ),
                                  MyText(
                                      text: AppLocalizations.of(context)!.payAt,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (context
                                                  .read<BookingBloc>()
                                                  .transportType ==
                                              'delivery' &&
                                          widget.arg.title == 'Send Parcel') {
                                        context
                                            .read<BookingBloc>()
                                            .showPaymentChange = true;
                                      } else {
                                        context
                                            .read<BookingBloc>()
                                            .showPaymentChange = false;
                                        context
                                            .read<BookingBloc>()
                                            .selectedPaymentType = 'cash';
                                      }
                                      context.read<BookingBloc>().payAtDrop =
                                          false;
                                      context
                                          .read<BookingBloc>()
                                          .add(UpdateEvent());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      decoration: BoxDecoration(
                                          color: (!context
                                                  .read<BookingBloc>()
                                                  .payAtDrop)
                                              ? AppColors.primary
                                                  .withOpacity(0.8)
                                              : null,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: MyText(
                                          text: AppLocalizations.of(context)!
                                              .sender,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: (!context
                                                        .read<BookingBloc>()
                                                        .payAtDrop)
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.01),
                                  if (widget.arg.stopAddressList.length == 1)
                                    InkWell(
                                      onTap: () {
                                        if (context
                                                    .read<BookingBloc>()
                                                    .transportType ==
                                                'delivery' &&
                                            widget.arg.title ==
                                                'Receive Parcel') {
                                          context
                                              .read<BookingBloc>()
                                              .showPaymentChange = true;
                                        } else {
                                          context
                                              .read<BookingBloc>()
                                              .showPaymentChange = false;
                                          context
                                              .read<BookingBloc>()
                                              .selectedPaymentType = 'cash';
                                        }
                                        context.read<BookingBloc>().payAtDrop =
                                            true;
                                        context
                                            .read<BookingBloc>()
                                            .add(UpdateEvent());
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        decoration: BoxDecoration(
                                            color: (context
                                                    .read<BookingBloc>()
                                                    .payAtDrop)
                                                ? AppColors.primary
                                                : null,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: MyText(
                                            text: AppLocalizations.of(context)!
                                                .receiver,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: (!context
                                                          .read<BookingBloc>()
                                                          .payAtDrop)
                                                      ? Colors.black
                                                      : Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: size.width * 0.04),
                    CustomContainer(
                      color: AppColors.primary.withOpacity(0.2),
                      child: InkWell(
                        onTap: () {
                          if (context.read<BookingBloc>().showPaymentChange) {
                            showModalBottomSheet(
                                context: context,
                                barrierColor: Theme.of(context).shadowColor,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                builder: (_) {
                                  return choosePaymentMethod(context, size);
                                });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    text: AppLocalizations.of(context)!
                                        .paymentMethod,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .disabledColor),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                          context
                                                      .read<BookingBloc>()
                                                      .selectedPaymentType ==
                                                  'cash'
                                              ? Icons.payments_outlined
                                              : context
                                                          .read<BookingBloc>()
                                                          .selectedPaymentType ==
                                                      'card'
                                                  ? Icons.credit_card_rounded
                                                  : Icons
                                                      .account_balance_wallet_outlined,
                                          size: 20,
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      SizedBox(width: size.width * 0.02),
                                      MyText(
                                        text: context
                                            .read<BookingBloc>()
                                            .selectedPaymentType,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (context.read<BookingBloc>().showPaymentChange)
                                MyText(
                                    text: AppLocalizations.of(context)!
                                        .changeLower,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .primaryColorDark))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.width * 0.04),
                    CustomContainer(
                      color: AppColors.primary.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text: AppLocalizations.of(context)!
                                  .readBeforeBooking,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context).disabledColor),
                            ),
                            SizedBox(height: size.width * 0.02),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: size.width * 0.02,
                                  width: size.width * 0.02,
                                  margin:
                                      EdgeInsets.only(top: size.width * 0.015),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorDark,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                SizedBox(
                                  width: size.width * 0.8,
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .deliveryInfoLoadingTime
                                        .replaceAll('**',
                                            '${context.read<BookingBloc>().isRentalRide ? eta.freeMin : eta.freeWaitingTimeInMinsBeforeTripStart + eta.freeWaitingTimeInMinsAfterTripStart}'),
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.width * 0.02),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: size.width * 0.02,
                                  width: size.width * 0.02,
                                  margin:
                                      EdgeInsets.only(top: size.width * 0.015),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorDark,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                SizedBox(
                                  width: size.width * 0.8,
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .deliveryInfoLoadingCharged
                                        .replaceAll('***',
                                            '${eta.currency} ${context.read<BookingBloc>().isRentalRide ? eta.timePricePerMin : eta.waitingCharge}'),
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.width * 0.02),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: size.width * 0.02,
                                  width: size.width * 0.02,
                                  margin:
                                      EdgeInsets.only(top: size.width * 0.015),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorDark,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                SizedBox(
                                  width: size.width * 0.8,
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .deliveryInfoFare,
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.width * 0.02),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: size.width * 0.02,
                                  width: size.width * 0.02,
                                  margin:
                                      EdgeInsets.only(top: size.width * 0.015),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorDark,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                SizedBox(
                                  width: size.width * 0.8,
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .deliveryInfoParkingCharge,
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.width * 0.02),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: size.width * 0.02,
                                  width: size.width * 0.02,
                                  margin:
                                      EdgeInsets.only(top: size.width * 0.015),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorDark,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                SizedBox(
                                  width: size.width * 0.8,
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .deliveryInfoOverloading,
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.width * 0.02),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget confirmButtonWidget(Size size, BuildContext context) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.only(top: 1),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
              offset: const Offset(-1, -2),
              blurRadius: 10,
              spreadRadius: 1,
              color: Theme.of(context).splashColor)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: size.width * 0.03),
            Row(
              mainAxisAlignment:
                  context.read<BookingBloc>().transportType == 'taxi'
                      ? MainAxisAlignment.spaceAround
                      : MainAxisAlignment.start,
              children: [
                // PAYMENT
                if (context.read<BookingBloc>().transportType == 'taxi')
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          barrierColor: Theme.of(context).shadowColor,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                  20.0), // Adjust the radius to your linking
                            ),
                          ),
                          builder: (_) {
                            return choosePaymentMethod(context, size);
                          });
                    },
                    child: Row(
                      children: [
                        Icon(
                            context.read<BookingBloc>().selectedPaymentType ==
                                    'cash'
                                ? Icons.payments_outlined
                                : context
                                            .read<BookingBloc>()
                                            .selectedPaymentType ==
                                        'card'
                                    ? Icons.credit_card_rounded
                                    : Icons.account_balance_wallet_outlined,
                            color: Theme.of(context).primaryColorDark),
                        SizedBox(width: size.width * 0.05),
                        MyText(
                            text:
                                context.read<BookingBloc>().selectedPaymentType,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                if (context.read<BookingBloc>().transportType == 'taxi') ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                        height: 20,
                        width: 1,
                        color: Theme.of(context).disabledColor),
                  ),
                  // PREFERENCE
                  InkWell(
                    onTap: () {
                      if (context
                                  .read<BookingBloc>()
                                  .userData!
                                  .enablePetPreferenceForUser ==
                              '1' ||
                          context
                                  .read<BookingBloc>()
                                  .userData!
                                  .enableLuggagePreferenceForUser ==
                              '1') {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: false,
                            enableDrag: false,
                            isDismissible: true,
                            barrierColor: Theme.of(context).shadowColor,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(
                                    20.0), // Adjust the radius to your liking
                              ),
                            ),
                            builder: (_) {
                              return selectPreference(context, size);
                            });
                      } else {
                        log("----:Unavailable");
                        showToast(message: "Unavailable");
                      }
                    },
                    child: Row(children: [
                      Icon(Icons.tune,
                          size: 20, color: Theme.of(context).primaryColorDark),
                      SizedBox(width: size.width * 0.03),
                      Column(
                        children: [
                          MyText(
                              text: AppLocalizations.of(context)!.preference,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              if (context
                                      .read<BookingBloc>()
                                      .luggagePreference ==
                                  true)
                                Icon(
                                  Icons.luggage,
                                  size: 15,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              SizedBox(width: size.width * 0.01),
                              if (context.read<BookingBloc>().petPreference ==
                                  true)
                                Icon(
                                  Icons.pets,
                                  size: 15,
                                  color: Theme.of(context).primaryColorDark,
                                )
                            ],
                          )
                        ],
                      )
                    ]),
                  ),
                ],
                if ((context.read<BookingBloc>().transportType == 'taxi' &&
                        !context.read<BookingBloc>().showBiddingVehicles &&
                        !context.read<BookingBloc>().isRentalRide) ||
                    (context.read<BookingBloc>().transportType == 'taxi' &&
                        context.read<BookingBloc>().isRentalRide)) ...[
                  if (context.read<BookingBloc>().transportType == 'taxi')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                          height: 20,
                          width: 1,
                          color: Theme.of(context).disabledColor),
                    ),
                  // COUPONS
                  InkWell(
                    onTap: () {
                      context.read<BookingBloc>().promoErrorText = '';
                      context.read<BookingBloc>().add(UpdateEvent());
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        barrierColor: Theme.of(context).shadowColor,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.0),
                          ),
                        ),
                        builder: (_) {
                          return BlocProvider.value(
                              value: context.read<BookingBloc>(),
                              child: ApplyCouponWidget(arg: widget.arg));
                        },
                      );
                    },
                    child: Row(children: [
                      Icon(Icons.percent,
                          size: 20, color: Theme.of(context).primaryColorDark),
                      SizedBox(width: size.width * 0.03),
                      MyText(
                          text: AppLocalizations.of(context)!.coupon,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold))
                    ]),
                  )
                ]
              ],
            ),
            SizedBox(height: size.width * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (context.read<BookingBloc>().detailView)
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(width: size.width * 0.1))),
                Center(
                  child: CustomButton(
                    buttonColor: Theme.of(context).primaryColor,
                    buttonName: (context.read<BookingBloc>().transportType ==
                                'delivery' &&
                            !context.read<BookingBloc>().detailView)
                        ? AppLocalizations.of(context)!.continueN
                        : (context.read<BookingBloc>().scheduleDateTime.isEmpty)
                            ? AppLocalizations.of(context)!.rideNow
                            : AppLocalizations.of(context)!.scheduleRide,
                    isLoader: context.read<BookingBloc>().isLoading,
                    onTap: () {
                      if (context.read<BookingBloc>().selectedVehicleIndex !=
                          999) {
                        if (context.read<BookingBloc>().transportType ==
                                'delivery' &&
                            !context.read<BookingBloc>().detailView) {
                          log("----:1");

                          ///
                          // Update detail view state using DetailViewUpdateEvent
                          context
                              .read<BookingBloc>()
                              .add(DetailViewUpdateEvent(true));
                          Future.delayed(const Duration(milliseconds: 301), () {
                            if (!context.mounted) return;
                            context.read<BookingBloc>().detailView = true;
                            context.read<BookingBloc>().add(UpdateEvent());
                          });
                        } else {
                          log("----:2");

                          ///
                          if ((widget.arg.isOutstationRide &&
                                  context.read<BookingBloc>().isRoundTrip &&
                                  context
                                      .read<BookingBloc>()
                                      .scheduleDateTimeForReturn
                                      .isNotEmpty) ||
                              ((widget.arg.isOutstationRide &&
                                      !context
                                          .read<BookingBloc>()
                                          .isRoundTrip) ||
                                  (!widget.arg.isOutstationRide))) {
                            if (context.read<BookingBloc>().transportType ==
                                    'taxi' ||
                                (context.read<BookingBloc>().transportType ==
                                        'delivery' &&
                                    context
                                            .read<BookingBloc>()
                                            .selectedGoodsTypeId !=
                                        0)) {
                              context.read<BookingBloc>().detailView = false;
                              bool biddingDispatch =
                                  !context.read<BookingBloc>().isRentalRide
                                      ? context
                                              .read<BookingBloc>()
                                              .isMultiTypeVechiles
                                          ? context
                                                  .read<BookingBloc>()
                                                  .sortedEtaDetailsList[context
                                                      .read<BookingBloc>()
                                                      .selectedVehicleIndex]
                                                  .dispatchType !=
                                              'normal'
                                          : context
                                                  .read<BookingBloc>()
                                                  .etaDetailsList[context
                                                      .read<BookingBloc>()
                                                      .selectedVehicleIndex]
                                                  .dispatchType !=
                                              'normal'
                                      : false;
                              if ((!context
                                          .read<BookingBloc>()
                                          .isMultiTypeVechiles &&
                                      biddingDispatch) ||
                                  (context
                                          .read<BookingBloc>()
                                          .isMultiTypeVechiles &&
                                      context
                                          .read<BookingBloc>()
                                          .showBiddingVehicles &&
                                      biddingDispatch)) {
                                log("----:3");

                                ///
                                context
                                    .read<BookingBloc>()
                                    .add(EnableBiddingEvent());
                              } else {
                                final bookingBloc = context.read<BookingBloc>();
                                //fixed rate

                                //first popup modal

                                context.read<BookingBloc>().add(
                                      BookingCreateRequestEvent(
                                          userData: widget.arg.userData,
                                          vehicleData: !context
                                                  .read<BookingBloc>()
                                                  .isRentalRide
                                              ? context
                                                      .read<BookingBloc>()
                                                      .isMultiTypeVechiles
                                                  ? context.read<BookingBloc>().sortedEtaDetailsList[context
                                                      .read<BookingBloc>()
                                                      .selectedVehicleIndex]
                                                  : context.read<BookingBloc>().etaDetailsList[
                                                      context
                                                          .read<BookingBloc>()
                                                          .selectedVehicleIndex]
                                              : context.read<BookingBloc>().rentalEtaDetailsList[
                                                  context
                                                      .read<BookingBloc>()
                                                      .selectedVehicleIndex],
                                          pickupAddressList:
                                              widget.arg.pickupAddressList,
                                          dropAddressList:
                                              widget.arg.stopAddressList,
                                          selectedTransportType: context
                                              .read<BookingBloc>()
                                              .transportType,
                                          paidAt: context.read<BookingBloc>().payAtDrop
                                              ? 'Receiver'
                                              : 'Sender',
                                          selectedPaymentType: context
                                              .read<BookingBloc>()
                                              .selectedPaymentType,
                                          scheduleDateTime: context
                                              .read<BookingBloc>()
                                              .scheduleDateTime,
                                          goodsTypeId: context
                                              .read<BookingBloc>()
                                              .selectedGoodsTypeId
                                              .toString(),
                                          goodsQuantity: context
                                              .read<BookingBloc>()
                                              .goodsQtyController
                                              .text,
                                          polyLine: context.read<BookingBloc>().polyLine,
                                          isPetAvailable: context.read<BookingBloc>().petPreference,
                                          isLuggageAvailable: context.read<BookingBloc>().luggagePreference,
                                          isRentalRide: context.read<BookingBloc>().isRentalRide),
                                    );
                              }
                            } else {
                              log("----:5");

                              ///
                              showToast(
                                  message: AppLocalizations.of(context)!
                                      .pleaseSelectGoodsType);
                            }
                          } else {
                            log("----:6");

                            ///
                            showToast(
                                message: AppLocalizations.of(context)!
                                    .pleaseSelectReturnDate);
                          }
                        }
                      } else {
                        log("----:7");

                        ///
                        showToast(
                            message: AppLocalizations.of(context)!
                                .pleaseSelectVehicle);
                      }
                    },
                  ),
                ),
                if (context.read<BookingBloc>().detailView)
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          context.read<BookingBloc>().add(
                                DetailViewUpdateEvent(
                                    context.read<BookingBloc>().detailView
                                        ? false
                                        : true),
                              );
                        },
                        child: Icon(
                          context.read<BookingBloc>().detailView
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.tune,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: size.width * 0.05)
          ],
        ),
      ),
    );
  }
}
