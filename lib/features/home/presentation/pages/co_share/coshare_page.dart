import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kororyde_user/common/pickup_icon.dart';
import 'package:kororyde_user/core/utils/custom_divider.dart';
import 'package:kororyde_user/core/utils/custom_snack_bar.dart';
import 'package:kororyde_user/features/home/domain/models/my_coshare_request.dart';
import 'package:kororyde_user/features/home/presentation/pages/co_share/available_coshare_ride.dart';
import 'package:kororyde_user/features/home/presentation/pages/co_share/cosharer_detail.dart';
import 'package:kororyde_user/l10n/app_localizations.dart';

import '../../../../../common/common.dart';
import '../../../../../core/utils/custom_button.dart';
import '../../../../../core/utils/custom_loader.dart';
import '../../../../../core/utils/custom_navigation_icon.dart';
import '../../../../../core/utils/custom_text.dart';
import '../../../../../core/utils/custom_textfield.dart';
import '../../../../auth/presentation/pages/auth_page.dart';
import '../../../application/home_bloc.dart';
import '../../../domain/models/stop_address_model.dart';
import '../../../domain/models/user_details_model.dart';
import '../../widgets/leave_instruction.dart';
import '../../widgets/select_contact.dart';
import '../confirm_location_page.dart';

class CosharePage extends StatefulWidget {
  static const String routeName = '/coshare';
  final DestinationPageArguments arg;

  const CosharePage({super.key, required this.arg});

  @override
  State<CosharePage> createState() => _CosharePageState();
}

class _CosharePageState extends State<CosharePage> {
  List<MyCoshareRequestData> _coShareList = [];

  @override
  void initState() {
    super.initState();
    // Wait until the first frame is rendered before accessing context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(GetMyCoShareRequestEvent(
        onSuccess: (data) {
          // log("--coshare data here:${data}");
          setState(() {
            _coShareList = data;
          });
          log("--coshare data here:${_coShareList}");
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builderWidget(size);
  }

  Widget builderWidget(Size size) {
    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(GetDirectionEvent())
        ..add(DesinationPageInitEvent(arg: widget.arg)),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          if (state is HomeInitialState) {
            CustomLoader.loader(context);
          } else if (state is HomeLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is HomeLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is LogoutState) {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          } else if (state is SelectFromMapState) {
            Navigator.pushNamed(context, ConfirmLocationPage.routeName,
                    arguments: ConfirmLocationPageArguments(
                        userData: widget.arg.userData,
                        isPickupEdit: state.isPickUpEdit,
                        isEditAddress: false,
                        mapType: widget.arg.mapType,
                        transportType: context.read<HomeBloc>().transportType))
                .then(
              (value) {
                if (value != null) {
                  if (!context.mounted) return;
                  final address = value as AddressModel;
                  final homeBloc = context.read<HomeBloc>();
                  if (context.read<HomeBloc>().transportType.toLowerCase() ==
                      'delivery') {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      enableDrag: false,
                      isScrollControlled: true,
                      barrierColor: Theme.of(context).shadowColor,
                      builder: (_) {
                        return BlocProvider.value(
                          value: homeBloc,
                          child: LeaveInstructions(
                            address: address,
                            isReceiveParcel:
                                widget.arg.title == 'Receive Parcel',
                            name: widget.arg.userData.name,
                            number: widget.arg.userData.mobile,
                            transportType: widget.arg.transportType,
                          ),
                        );
                      },
                    );
                  } else {
                    context.read<HomeBloc>().add(AddOrEditStopAddressEvent(
                          isPickUpEdit: state.isPickUpEdit,
                          choosenAddressIndex:
                              context.read<HomeBloc>().choosenAddressIndex,
                          newAddress: address,
                        ));
                  }
                }
              },
            );
          } else if (state is RecentSearchPlaceSelectState) {
            if (context.read<HomeBloc>().transportType.toLowerCase() ==
                'delivery') {
              final homeBloc = context.read<HomeBloc>();
              showModalBottomSheet(
                context: context,
                isDismissible: true,
                enableDrag: true,
                isScrollControlled: true,
                barrierColor: Theme.of(context).shadowColor,
                builder: (_) {
                  return PopScope(
                    canPop: false,
                    child: BlocProvider.value(
                      value: homeBloc,
                      child: LeaveInstructions(
                        address: state.address,
                        isReceiveParcel: widget.arg.title == 'Receive Parcel',
                        name: widget.arg.userData.name,
                        number: widget.arg.userData.mobile,
                        transportType: widget.arg.transportType,
                      ),
                    ),
                  );
                },
              );
            } else {
              context.read<HomeBloc>().addressList[
                  context.read<HomeBloc>().choosenAddressIndex] = state.address;
              context
                  .read<HomeBloc>()
                  .addressTextControllerList[
                      context.read<HomeBloc>().choosenAddressIndex]
                  .text = state.address.address;
              if (!context
                  .read<HomeBloc>()
                  .addressList
                  .any((element) => element.address.isEmpty)) {
                context.read<HomeBloc>().add(ConfirmRideAddressEvent(
                    rideType:
                        widget.arg.isOutstationRide ? 'outstation' : 'taxi',
                    addressList: context.read<HomeBloc>().addressList));
              }
            }
          } else if (state is AddOrEditAddressState) {
            if (!context
                .read<HomeBloc>()
                .addressList
                .any((element) => element.address.isEmpty)) {
              context.read<HomeBloc>().add(ConfirmRideAddressEvent(
                  rideType: widget.arg.isOutstationRide ? 'outstation' : 'taxi',
                  addressList: context.read<HomeBloc>().addressList));
            }
          } else if (state is ReceiverDetailsState) {
            final homeBloc = context.read<HomeBloc>();
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              isScrollControlled: true,
              barrierColor: Theme.of(context).shadowColor,
              builder: (_) {
                return BlocProvider.value(
                  value: homeBloc,
                  child: LeaveInstructions(
                      address: state.address,
                      transportType: widget.arg.transportType,
                      isReceiveParcel: widget.arg.title == 'Receive Parcel',
                      name: widget.arg.userData.name,
                      number: widget.arg.userData.mobile),
                );
              },
            );
          } else if (state is SelectContactDetailsState) {
            final homeBloc = context.read<HomeBloc>();
            context.read<HomeBloc>().isMyself = false;
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (_) {
                return BlocProvider.value(
                  value: homeBloc,
                  child: const SelectFromContactList(),
                );
              },
            );
          } else if (state is ConfirmRideAddressState) {
            log("ConfirmRideAddressState ----in destination");
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              log("ConfirmRideAddressState --000--in destination");
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }
            // context.read<HomeBloc>().add(GetAllCoShareTripEvent());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<HomeBloc>(),
                  child: AvailableCoshareRidePage(
                    arg: BookingPageArguments(
                        picklat: context
                            .read<HomeBloc>()
                            .pickupAddressList
                            .first
                            .lat
                            .toString(),
                        picklng: context
                            .read<HomeBloc>()
                            .pickupAddressList
                            .first
                            .lng
                            .toString(),
                        droplat: context
                            .read<HomeBloc>()
                            .stopAddressList
                            .last
                            .lat
                            .toString(),
                        droplng: context
                            .read<HomeBloc>()
                            .stopAddressList
                            .last
                            .lng
                            .toString(),
                        userData: widget.arg.userData,
                        transportType: widget.arg.transportType,
                        pickupAddressList:
                            context.read<HomeBloc>().pickupAddressList,
                        stopAddressList:
                            context.read<HomeBloc>().stopAddressList,
                        title: widget.arg.title,
                        polyString: '',
                        distance: '',
                        duration: '',
                        isOutstationRide: widget.arg.isOutstationRide,
                        mapType: widget.arg.mapType),
                  ),
                ),
              ),
            );

            log("ConfirmRideAddressState ---11111-in destination");
          } else if (state is RecentRouteSelectState) {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }

            // context.read<HomeBloc>().add(GetAllCoShareTripEvent());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<HomeBloc>(),
                  child: AvailableCoshareRidePage(
                    arg: BookingPageArguments(
                        picklat: context
                            .read<HomeBloc>()
                            .pickupAddressList
                            .first
                            .lat
                            .toString(),
                        picklng: context
                            .read<HomeBloc>()
                            .pickupAddressList
                            .first
                            .lng
                            .toString(),
                        droplat: context
                            .read<HomeBloc>()
                            .stopAddressList
                            .last
                            .lat
                            .toString(),
                        droplng: context
                            .read<HomeBloc>()
                            .stopAddressList
                            .last
                            .lng
                            .toString(),
                        userData: widget.arg.userData,
                        transportType: widget.arg.transportType,
                        pickupAddressList:
                            context.read<HomeBloc>().pickupAddressList,
                        stopAddressList:
                            context.read<HomeBloc>().stopAddressList,
                        title: widget.arg.title,
                        polyString: '',
                        distance: '',
                        duration: '',
                        isOutstationRide: widget.arg.isOutstationRide,
                        mapType: widget.arg.mapType),
                  ),
                ),
              ),
            );
          } else if (state is ServiceNotAvailableState) {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                          alignment:
                              context.read<HomeBloc>().textDirection == 'rtl'
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.cancel_outlined,
                                color: Theme.of(context).primaryColor,
                              ))),
                      Center(
                        child: MyText(
                            text: state.message,
                            // AppLocalizations.of(context)!.serviceNotAvailable,
                            maxLines: 4),
                      ),
                    ],
                  ),
                  actions: [
                    Center(
                      child: CustomButton(
                        buttonName: AppLocalizations.of(context)!.okText,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                );
              },
            );
          } else if (state is AcceptOfferState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<HomeBloc>().add(GetMyCoShareRequestEvent(
                onSuccess: (data) {
                  setState(() {
                    _coShareList = data;
                  });
                },
              ));
              showToast(message: "You have successfuly accepted the offer");
              Navigator.pop(context);
            });
          } else if (state is RejectOfferState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<HomeBloc>().add(GetMyCoShareRequestEvent(
                onSuccess: (data) {
                  setState(() {
                    _coShareList = data;
                  });
                },
              ));
              showToast(message: "Offer Declined");
              Navigator.pop(context);
            });
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Directionality(
              textDirection: context.read<HomeBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      "Join Co share",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    automaticallyImplyLeading: false,
                    leadingWidth: size.width * 0.2,
                    surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 3),
                      child: NavigationIconWidget(
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: Theme.of(context).primaryColorDark),
                        isShadowWidget: true,
                      ),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: MyText(
                              text:
                                  'Please fill-out the form below to find a ride going along your destination',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontSize: 13,
                                      color: Theme.of(context).disabledColor),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis),
                        ),
                        buildLocationSelect(context, size),
                        if (context
                            .read<HomeBloc>()
                            .searchInfoMessage
                            .isEmpty) ...[
                          SizedBox(height: size.width * 0.03),
                          if (context.read<HomeBloc>().userData != null)
                            buildFavoriteLocations(
                                context,
                                context
                                    .read<HomeBloc>()
                                    .userData!
                                    .favouriteLocations
                                    .data,
                                size),
                          SizedBox(height: size.width * 0.03),
                          if (context
                              .read<HomeBloc>()
                              .recentSearchPlaces
                              .isNotEmpty) ...[
                            if (context
                                    .read<HomeBloc>()
                                    .recentRoutes
                                    .isNotEmpty &&
                                context.read<HomeBloc>().recentRoutes.any(
                                    (element) =>
                                        element.transportType ==
                                        widget.arg.transportType))
                              // buildRecentRoutes(context, size),
                              SizedBox(height: size.width * 0.02),
                            // buildRecentSearchLocations(context, size)
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 8, 8,
                                  MediaQuery.of(context).viewInsets.bottom + 8),
                              child: CustomButton(
                                width: size.width,
                                buttonName: "Search for ride",
                                buttonColor: !context
                                        .read<HomeBloc>()
                                        .addressList
                                        .any((element) =>
                                            element.address.isEmpty)
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5),
                                onTap: () {
                                  if (!context.read<HomeBloc>().addressList.any(
                                      (element) => element.address.isEmpty)) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<HomeBloc>(),
                                          child: AvailableCoshareRidePage(
                                            arg: BookingPageArguments(
                                                picklat: context
                                                    .read<HomeBloc>()
                                                    .pickupAddressList
                                                    .first
                                                    .lat
                                                    .toString(),
                                                picklng: context
                                                    .read<HomeBloc>()
                                                    .pickupAddressList
                                                    .first
                                                    .lng
                                                    .toString(),
                                                droplat: context
                                                    .read<HomeBloc>()
                                                    .stopAddressList
                                                    .last
                                                    .lat
                                                    .toString(),
                                                droplng: context
                                                    .read<HomeBloc>()
                                                    .stopAddressList
                                                    .last
                                                    .lng
                                                    .toString(),
                                                userData: widget.arg.userData,
                                                transportType:
                                                    widget.arg.transportType,
                                                pickupAddressList: context
                                                    .read<HomeBloc>()
                                                    .pickupAddressList,
                                                stopAddressList: context
                                                    .read<HomeBloc>()
                                                    .stopAddressList,
                                                title: widget.arg.title,
                                                polyString: '',
                                                distance: '',
                                                duration: '',
                                                isOutstationRide:
                                                    widget.arg.isOutstationRide,
                                                mapType: widget.arg.mapType),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  // log("done clickkkk");
                                  // if (!context
                                  //     .read<HomeBloc>()
                                },
                              ),
                            ),

                            const SizedBox(height: 20),

                            // if (_coShareList.isNotEmpty) ...[
                            //   Padding(
                            //     padding: const EdgeInsets.all(16.0),
                            //     child: Text("Pending CoShare request:",
                            //         style: Theme.of(context)
                            //             .textTheme
                            //             .titleMedium),
                            //   ),
                            //   ListView.builder(
                            //     padding:
                            //         const EdgeInsets.symmetric(horizontal: 10),
                            //     shrinkWrap: true,
                            //     physics: const NeverScrollableScrollPhysics(),
                            //     itemCount: _coShareList.length,
                            //     itemBuilder: (context, index) {
                            //       final request = _coShareList[index];
                            //       return MyCoShareRequestCard(request: request);
                            //     },
                            //   ),
                            // ]
                          ],
                        ],

                        //////////////my co share///////////////////
                        ///
                        Builder(builder: (context) {
                          final pendingRequests = _coShareList
                              .where((request) =>
                                  (request.coShareRequest?.status ==
                                      'pending') ||
                                  (request.coShareRequest?.status ==
                                      'accepted'))
                              .toList();

                          log("--pendingRequests:${pendingRequests.length}");
                          log("--_coShareList:${_coShareList.length}");

                          return Column(
                            children: [
                              if (pendingRequests.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "Pending CoShare request:",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: pendingRequests.length,
                                  itemBuilder: (context, index) {
                                    log("--co-share length:${pendingRequests.length}");
                                    final request = pendingRequests[index];
                                    return MyCoShareRequestCard(
                                        request: request);

                                    // return SizedBox.fromSize();
                                  },
                                ),
                              ]
                            ],
                          );
                        }),
                        if (context
                            .read<HomeBloc>()
                            .searchInfoMessage
                            .isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 16),
                            child: MyText(
                                text:
                                    context.read<HomeBloc>().searchInfoMessage),
                          ),
                        if (context
                            .read<HomeBloc>()
                            .autoSearchPlaces
                            .isNotEmpty) ...[
                          SizedBox(height: size.width * 0.03),
                          autoSearchPlacesWidget(context, size)
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget autoSearchPlacesWidget(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SizedBox(
        child: GestureDetector(
          onVerticalDragStart: (details) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ListView.separated(
                    itemCount: context.read<HomeBloc>().autoSearchPlaces.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final autoAddres = context
                          .read<HomeBloc>()
                          .autoSearchPlaces
                          .elementAt(index);
                      return InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          context.read<HomeBloc>().add(
                              RecentSearchPlaceSelectEvent(
                                  transportType: widget.arg.transportType,
                                  address: autoAddres,
                                  isPickupSelect:
                                      context.read<HomeBloc>().isPickupSelect));
                        },
                        child: Row(
                          children: [
                            Container(
                              height: size.height * 0.075,
                              width: size.width * 0.075,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.25),
                                  shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.location_pin,
                                size: 20,
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.75),
                              ),
                            ),
                            SizedBox(width: size.width * 0.025),
                            SizedBox(
                              width: size.width * 0.8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                      text: autoAddres.address,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .disabledColor),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(color: Theme.of(context).dividerColor);
                    },
                  ),
                  SizedBox(height: size.width * 0.15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLocationSelect(BuildContext context, Size size) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor,
                offset: const Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 1)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (context.read<HomeBloc>().addressList.isNotEmpty) ...[
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.white,
                  shadowColor: Colors.transparent,
                ),
                child: ReorderableListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  onReorder: (oldIndex, newIndex) {
                    context.read<HomeBloc>().add(
                        ReorderEvent(oldIndex: oldIndex, newIndex: newIndex));
                  },
                  children: List.generate(
                    context.read<HomeBloc>().addressList.length,
                    (index) {
                      TextEditingController controller = context
                          .read<HomeBloc>()
                          .addressTextControllerList
                          .elementAt(index);
                      return Padding(
                        key: Key('$index'),
                        padding: EdgeInsets.only(bottom: size.width * 0.02),
                        child: Row(
                          children: [
                            if (index != 0 &&
                                index !=
                                    context
                                            .read<HomeBloc>()
                                            .addressList
                                            .length -
                                        1) ...[
                              Container(
                                height: size.width * 0.05,
                                width: size.width * 0.05,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 0.3,
                                        color:
                                            Theme.of(context).disabledColor)),
                                child: Center(
                                  child: MyText(
                                      text: '$index',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                            ],
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: const BoxDecoration(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        borderRadius: 50,
                                        controller: controller,
                                        enabled: true,
                                        filled: true,
                                        autofocus: context
                                                .read<HomeBloc>()
                                                .recentSearchPlaces
                                                .isEmpty
                                            ? (!widget.arg.pickUpChange &&
                                                    index == 1)
                                                ? true
                                                : (widget.arg.pickUpChange &&
                                                        index == 0)
                                                    ? true
                                                    : false
                                            : false,
                                        keyboardType: TextInputType.text,
                                        fillColor: Colors.grey.withOpacity(0.2),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        hintText: (index ==
                                                context
                                                        .read<HomeBloc>()
                                                        .addressList
                                                        .length -
                                                    1)
                                            ? AppLocalizations.of(context)!
                                                .destinationAddress
                                            : (index == 0)
                                                ? AppLocalizations.of(context)!
                                                    .pickupAddress
                                                : AppLocalizations.of(context)!
                                                    .addStopAddress,
                                        hintTextStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        prefixConstraints: BoxConstraints(
                                            maxWidth: size.width * 0.065),
                                        prefixIcon: (index == 0 ||
                                                index ==
                                                    context
                                                            .read<HomeBloc>()
                                                            .addressList
                                                            .length -
                                                        1)
                                            ? Center(
                                                child: (index == 0)
                                                    ? SvgPicture.asset(
                                                        'assets/svg/sourceAddr.svg')
                                                    : SvgPicture.asset(
                                                        'assets/svg/destinationAddr.svg',
                                                      ),
                                              )
                                            : null,
                                        suffixConstraints: BoxConstraints(
                                            maxWidth: size.width * 0.2),
                                        suffixIcon: controller.text.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10, left: 10),
                                                child: InkWell(
                                                  onTap: () {
                                                    context
                                                            .read<HomeBloc>()
                                                            .addressList[index] =
                                                        AddressModel(
                                                            orderId: '',
                                                            address: '',
                                                            lat: 0,
                                                            lng: 0,
                                                            name: '',
                                                            number: '',
                                                            pickup: false);
                                                    context
                                                        .read<HomeBloc>()
                                                        .addressTextControllerList[
                                                            index]
                                                        .text = '';
                                                    if (context
                                                        .read<HomeBloc>()
                                                        .autoSearchPlaces
                                                        .isNotEmpty) {
                                                      context
                                                          .read<HomeBloc>()
                                                          .searchInfoMessage = '';
                                                      context
                                                          .read<HomeBloc>()
                                                          .autoSearchPlaces
                                                          .clear();
                                                    }
                                                    context
                                                        .read<HomeBloc>()
                                                        .add(UpdateEvent());
                                                  },
                                                  child: Icon(
                                                    Icons.cancel,
                                                    size: 20,
                                                    color: Theme.of(context)
                                                        .disabledColor
                                                        .withOpacity(0.4),
                                                  ),
                                                ),
                                              )
                                            : null,
                                        onTap: () {
                                          context
                                                  .read<HomeBloc>()
                                                  .isPickupSelect =
                                              (index == 0) ? true : false;
                                          context
                                              .read<HomeBloc>()
                                              .choosenAddressIndex = index;
                                          context
                                              .read<HomeBloc>()
                                              .add(UpdateEvent());
                                        },
                                        onChange: (value) {
                                          context
                                              .read<HomeBloc>()
                                              .debouncer
                                              .run(() {
                                            if (value.isEmpty) {
                                              context
                                                      .read<HomeBloc>()
                                                      .addressList[index] =
                                                  AddressModel(
                                                      orderId: '',
                                                      address: '',
                                                      lat: 0,
                                                      lng: 0,
                                                      name: '',
                                                      number: '',
                                                      pickup: false);
                                            }
                                            context.read<HomeBloc>().add(
                                                SearchPlacesEvent(
                                                    context: context,
                                                    mapType: widget.arg.mapType,
                                                    countryCode: widget.arg
                                                        .userData.countryCode,
                                                    latLng: (widget.arg
                                                                .pickupLatLng !=
                                                            null)
                                                        ? widget
                                                            .arg.pickupLatLng!
                                                        : (widget.arg
                                                                    .dropLatLng !=
                                                                null)
                                                            ? widget
                                                                .arg.dropLatLng!
                                                            : const LatLng(
                                                                0, 0),
                                                    enbleContryRestrictMap: widget
                                                        .arg
                                                        .userData
                                                        .enableCountryRestrictOnMap,
                                                    searchText: value));
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildFavoriteLocations(BuildContext context,
      List<FavoriteLocationData> favLocations, Size size) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                favLocations.length,
                (index) {
                  final location = favLocations.elementAt(index);
                  return Padding(
                    padding: EdgeInsets.only(right: size.width * 0.02),
                    child: InkWell(
                      onTap: () {
                        context.read<HomeBloc>().add(FavLocationSelectEvent(
                            address: location,
                            isPickupSelect:
                                context.read<HomeBloc>().isPickupSelect));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          child: Row(
                            children: [
                              Icon(
                                (location.addressName.toLowerCase() == 'home')
                                    ? Icons.home_outlined
                                    : (location.addressName.toLowerCase() ==
                                            'work')
                                        ? Icons.business_center_outlined
                                        : Icons.home_work_outlined,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                text: location.addressName,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRecentRoutes(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.recentSearchRoutes,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).disabledColor,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
            ),
            SizedBox(height: size.width * 0.02),
            SizedBox(
              width: size.width,
              height: size.width * (context.read<HomeBloc>().recentRouteHeight),
              child: PageView.builder(
                controller: context.read<HomeBloc>().recentRoutesPageController,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: context
                    .read<HomeBloc>()
                    .recentRoutes
                    .where((element) =>
                        element.transportType == widget.arg.transportType)
                    .length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      context.read<HomeBloc>().add(RecentRouteSelectEvent(
                          selectedRoute:
                              context.read<HomeBloc>().recentRoutes[index]));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.1)),
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.018),
                                  child: const PickupIcon(),
                                ),
                                Expanded(
                                  child: MyText(
                                    text: context
                                        .read<HomeBloc>()
                                        .recentRoutes[index]
                                        .pickShortAddress,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            if (context
                                .read<HomeBloc>()
                                .recentRoutes[index]
                                .searchStops
                                .data
                                .isNotEmpty) ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: VerticalDotDividerWidget(),
                              ),
                              ListView.separated(
                                itemCount: context
                                    .read<HomeBloc>()
                                    .recentRoutes[index]
                                    .searchStops
                                    .data
                                    .length,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemBuilder: (context, ind) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.023),
                                        child: Container(
                                          height: 16,
                                          width: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          child: Center(
                                            child: MyText(
                                              text: '${ind + 1}',
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: AppColors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: MyText(
                                          text: context
                                              .read<HomeBloc>()
                                              .recentRoutes[index]
                                              .searchStops
                                              .data[ind]
                                              .shortAddress,
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
                                  return const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: VerticalDotDividerWidget(),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: VerticalDotDividerWidget(),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.015),
                                  child: const DropIcon(),
                                ),
                                Expanded(
                                  child: MyText(
                                    text: context
                                        .read<HomeBloc>()
                                        .recentRoutes[index]
                                        .dropShortAddress,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                onPageChanged: (value) {
                  context
                      .read<HomeBloc>()
                      .add(RecentRoutesChangeIndex(routesIndex: value));
                },
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                context
                    .read<HomeBloc>()
                    .recentRoutes
                    .where((element) =>
                        element.transportType == widget.arg.transportType)
                    .length,
                (index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 5),
                    height:
                        context.read<HomeBloc>().routesIndex == index ? 10 : 8,
                    width:
                        context.read<HomeBloc>().routesIndex == index ? 10 : 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.read<HomeBloc>().routesIndex == index
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).splashColor),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRecentSearchLocations(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: AppLocalizations.of(context)!.searchPlaces,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
              ),
              SizedBox(height: size.width * 0.02),
              ListView.separated(
                itemCount: context.read<HomeBloc>().recentSearchPlaces.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) {
                  final recentPlace = context
                      .read<HomeBloc>()
                      .recentSearchPlaces
                      .elementAt(index);
                  return InkWell(
                    onTap: () {
                      context.read<HomeBloc>().add(
                            RecentSearchPlaceSelectEvent(
                                transportType: widget.arg.transportType,
                                address: recentPlace,
                                isPickupSelect:
                                    context.read<HomeBloc>().isPickupSelect),
                          );
                    },
                    child: SizedBox(
                      height: size.width * 0.14,
                      child: Row(
                        children: [
                          Container(
                            height: size.height * 0.075,
                            width: size.width * 0.075,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.location_pin,
                              size: 20,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.75),
                            ),
                          ),
                          SizedBox(width: size.width * 0.025),
                          SizedBox(
                            width: size.width * 0.75,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyText(
                                  text: recentPlace.address.split(',')[0],
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                ),
                                MyText(
                                  text: recentPlace.address,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color:
                                              Theme.of(context).disabledColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                      color: Theme.of(context).dividerColor.withOpacity(0.5));
                },
              ),
              SizedBox(height: size.width * 0.15),
            ],
          ),
        ),
      ),
    );
  }

  Container buildSelectFromMap(Size size, BuildContext context) {
    return Container(
      height: size.width * 0.1,
      width: double.infinity,
      decoration:
          BoxDecoration(color: Theme.of(context).primaryColor, boxShadow: [
        BoxShadow(
          offset: const Offset(0, -1),
          color: Theme.of(context).shadowColor,
        )
      ]),
      child: InkWell(
        onTap: () {
          context.read<HomeBloc>().add(SelectFromMapEvent(
              selectedAddressIndex:
                  context.read<HomeBloc>().choosenAddressIndex,
              isPickUpEdit:
                  context.read<HomeBloc>().isPickupSelect ? true : false));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.pin_drop_outlined,
              color: AppColors.white,
            ),
            MyText(
              text: AppLocalizations.of(context)!.selectFromMap,
              textStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCoShareRequestCard extends StatefulWidget {
  final MyCoshareRequestData request;
  const MyCoShareRequestCard({
    super.key,
    required this.request,
  });

  @override
  State<MyCoShareRequestCard> createState() => _MyCoShareRequestCardState();
}

class _MyCoShareRequestCardState extends State<MyCoShareRequestCard> {
  final TextEditingController _offerController =
      TextEditingController(text: '100');
  int coShareMaxSeats = 100;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withOpacity(
              0.1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "assets/images/default_profile.png",
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: widget.request.requestUser != null
                            ? widget.request.requestUser!.name!
                            : "user",
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child:
                                SvgPicture.asset("assets/svg/sourceAddr.svg"),
                          ),
                          SizedBox(
                            width: size.width * 0.6,
                            child: MyText(
                              text: "ikeja lagos nigeria",
                              maxLines: 4,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: SvgPicture.asset(
                                "assets/svg/destinationAddr.svg"),
                          ),
                          SizedBox(
                            width: size.width * 0.6,
                            child: MyText(
                                text: "20 adeniran surulere lagos",
                                maxLines: 4,
                                textStyle:
                                    Theme.of(context).textTheme.bodySmall!),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => BlocProvider.value(
                        //       value: context.read<HomeBloc>(),
                        //       child: CosharerDetail(
                        //         request: widget.request,
                        //       ),
                        //     ),
                        //   ),
                        // );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.primary.withOpacity(0.1)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person,
                              color: AppColors.primary,
                            ),
                            Text(
                              "View profile",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.primary.withOpacity(0.1)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat,
                              color: AppColors.primary,
                            ),
                            Text(
                              "Message",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (widget.request.coShareRequest!.status == "accepted") ...[
                    Expanded(
                        child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 9),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.primary.withOpacity(0.1)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: Text(
                                  "Offer Accepted",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ))
                  ] else ...[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          final homeBloc = context.read<HomeBloc>();
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
                                value: context.read<HomeBloc>(),
                                child: StatefulBuilder(
                                    builder: (context, setState) {
                                  return Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                                horizontal: 20)
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
                                                  text: "Offer request",
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
                                            const Row(
                                              children: [
                                                // MyText(
                                                //   text:
                                                //       "Francis has offered you £500",
                                                //   textStyle: Theme.of(context)
                                                //       .textTheme
                                                //       .bodySmall!
                                                //       .copyWith(
                                                //         fontWeight:
                                                //             FontWeight.w400,
                                                //       ),
                                                // ),
                                              ],
                                            ),
                                            const Divider(),
                                            const SizedBox(height: 30),
                                            if (widget.request.coShareRequest!
                                                    .negotiationAmount !=
                                                null) ...[
                                              Column(
                                                children: [
                                                  MyText(
                                                    text:
                                                        "You have has offered",
                                                    textStyle:
                                                        GoogleFonts.roboto(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      // fontStyle: style,
                                                    ),
                                                  ),
                                                  MyText(
                                                    text:
                                                        "₦ ${widget.request.coShareRequest!.negotiationAmount != null ? widget.request.coShareRequest!.negotiationAmount! : "0"}",
                                                    textStyle:
                                                        GoogleFonts.roboto(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: AppColors
                                                                .primary
                                                            // fontStyle: style,
                                                            ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              SizedBox(
                                                height: size.height * 0.025,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  AppColors
                                                                      .red),
                                                      onPressed: () {
                                                        final bloc = context
                                                            .read<HomeBloc>();

                                                        bloc.add(AcceptRejectCoshareRequestEvent(
                                                            status: "reject",
                                                            coShareRequestId: widget
                                                                .request
                                                                .coShareRequest!
                                                                .id
                                                                .toString()));
                                                      },
                                                      child: const Text(
                                                        "Decline offer",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  AppColors
                                                                      .primary),
                                                      onPressed: () {
                                                        final bloc = context
                                                            .read<HomeBloc>();

                                                        bloc.add(AcceptRejectCoshareRequestEvent(
                                                            status: "accept",
                                                            coShareRequestId: widget
                                                                .request
                                                                .coShareRequest!
                                                                .id
                                                                .toString()));
                                                      },
                                                      child: const Text(
                                                        "Accept offer",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ] else ...[
                                              MyText(
                                                text:
                                                    "The rider is yet to send his offer",
                                                textStyle: GoogleFonts.roboto(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  // fontStyle: style,
                                                ),
                                              ),
                                            ],
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
                                          child: const Icon(
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
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.primary.withOpacity(0.1)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.currency_exchange,
                                color: AppColors.primary,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: Text(
                                  "View Offer",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              )
              //////
            ],
          ),
        ),
        if (widget.request.coShareRequest!.status == "accepted") ...[
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: const BoxDecoration(color: AppColors.darkGreen),
              child: const Text(
                "Accepted",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ],
    );
  }

  StatefulBuilder acceptOfferPOp(Size size) {
    return StatefulBuilder(builder: (context, setState) {
      return Stack(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 40),
            height: size.height * 0.38,
            child: Column(
              children: [
                Image.asset("assets/png/accept.png"),
                const SizedBox(height: 20),
                MyText(
                  text: "You've Accepted Adam's offer and he has been notified",
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  buttonName: "Done",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}
