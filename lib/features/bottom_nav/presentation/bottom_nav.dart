// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kororyde_user/features/account/presentation/pages/account_page.dart';
import 'package:kororyde_user/features/account/presentation/pages/history_page.dart';
import 'package:kororyde_user/features/account/presentation/pages/wallet_page.dart';
import 'package:kororyde_user/features/auth/presentation/pages/auth_page.dart';
import 'package:kororyde_user/features/bill_payment/presentation/customer_wallet.dart';
import 'package:kororyde_user/features/bookingpage/presentation/page/booking_page.dart';
import 'package:kororyde_user/features/bookingpage/presentation/page/trip_summary_page.dart';
import 'package:kororyde_user/features/bottom_nav/presentation/show_page.dart';
import 'package:kororyde_user/features/home/application/home_bloc.dart';
import 'package:kororyde_user/features/home/domain/models/stop_address_model.dart';
import 'package:kororyde_user/features/home/presentation/pages/confirm_location_page.dart';
import 'package:kororyde_user/features/home/presentation/pages/destination_page.dart';
import 'package:kororyde_user/features/home/presentation/pages/home_page.dart';
import 'package:kororyde_user/features/home/presentation/pages/on_going_rides.dart';
import 'package:kororyde_user/features/home/presentation/pages/services_page.dart';
import 'package:kororyde_user/features/home/presentation/widgets/send_receive_delivery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kororyde_user/core/utils/custom_button.dart';
import 'package:kororyde_user/l10n/app_localizations.dart';
import '../../../../core/utils/custom_loader.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/homePage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(GetDirectionEvent())
        ..add(GetUserDetailsEvent()) ,//method the fetch user data
        // ..add(GetAllCoShareTripEvent()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          try {
            if (state is HomeInitialState) {
              CustomLoader.loader(context);
            } else if (state is HomeLoadingStartState) {
              Center(child: Text(""));
              // CustomLoader.loader(context);
            } else if (state is HomeLoadingStopState) {
              CustomLoader.dismiss(context);
            } else if (state is VechileStreamMarkerState) {
              context.read<HomeBloc>().nearByVechileCheckStream(context, this);
              dev.log("nearByVechileCheckStream===============");
              context.read<HomeBloc>().nearByVechileCheckStream(context, this);
            } else if (state is LogoutState) {
              if (context.read<HomeBloc>().nearByVechileSubscription != null) {
                context.read<HomeBloc>().nearByVechileSubscription?.cancel();
                context.read<HomeBloc>().nearByVechileSubscription = null;
              }
              Navigator.pushNamedAndRemoveUntil(
                  context, AuthPage.routeName, (route) => false);
              await AppSharedPreference.setLoginStatus(false);
            } else if (state is GetLocationPermissionState) {
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
                                child: Icon(Icons.cancel_outlined,
                                    color: Theme.of(context).primaryColor))),
                        MyText(
                            text: AppLocalizations.of(context)!.locationAccess,
                            maxLines: 4),
                      ],
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              await openAppSettings();
                            },
                            child: MyText(
                                text: AppLocalizations.of(context)!.openSetting,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor)),
                          ),
                          InkWell(
                            onTap: () async {
                              PermissionStatus status =
                                  await Permission.location.status;
                              if (status.isGranted || status.isLimited) {
                                if (!context.mounted) return;
                                Navigator.pop(context);
                                context.read<HomeBloc>().add(LocateMeEvent(
                                    mapType: context.read<HomeBloc>().mapType));
                              } else {
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              }
                            },
                            child: MyText(
                                text: AppLocalizations.of(context)!.done,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor)),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            } else if (state is NavigateToOnGoingRidesPageState) {
              Navigator.pushNamed(context, OnGoingRidesPage.routeName,
                      arguments: OnGoingRidesPageArguments(
                          userData: context.read<HomeBloc>().userData!,
                          mapType: context.read<HomeBloc>().mapType))
                  .then(
                (value) {
                  if (!context.mounted) return;
                  context.read<HomeBloc>().add(GetUserDetailsEvent());
                },
              );
            } else if (state is UserOnTripState

                // &&
                //  state.tripData.acceptedAt == ''
                ) {
              if (context.read<HomeBloc>().nearByVechileSubscription != null) {
                context.read<HomeBloc>().nearByVechileSubscription?.cancel();
                context.read<HomeBloc>().nearByVechileSubscription = null;
              }
              dev.log("BookingPage.routeName ---1");

              //  if (context.mounted)

              Navigator.pushNamedAndRemoveUntil(
                context,
                BookingPage.routeName,
                (route) => false,
                arguments: BookingPageArguments(
                    picklat: state.tripData.pickLat,
                    picklng: state.tripData.pickLng,
                    droplat: state.tripData.dropLat,
                    droplng: state.tripData.dropLng,
                    pickupAddressList:
                        context.read<HomeBloc>().pickupAddressList,
                    stopAddressList: context.read<HomeBloc>().stopAddressList,
                    userData: context.read<HomeBloc>().userData!,
                    transportType: state.tripData.transportType,
                    polyString: state.tripData.polyLine,
                    distance:
                        (double.parse(state.tripData.totalDistance) * 1000)
                            .toString(),
                    duration: state.tripData.totalTime.toString(),
                    isRentalRide: state.tripData.isRental,
                    isWithoutDestinationRide:
                        ((state.tripData.dropLat.isEmpty &&
                                    state.tripData.dropLng.isEmpty) &&
                                !state.tripData.isRental)
                            ? true
                            : false,
                    isOutstationRide: state.tripData.isOutStation == "1",
                    mapType: context.read<HomeBloc>().mapType),
              );
            } else if (state is DeliverySelectState) {
              final homeBloc = context.read<HomeBloc>();
              showModalBottomSheet(
                context: context,
                isDismissible: true,
                enableDrag: false,
                isScrollControlled: true,
                builder: (_) {
                  return BlocProvider.value(
                    value: homeBloc,
                    child: const SendOrReceiveDelivery(),
                  );
                },
              );
            } else if (state is DestinationSelectState) {
              Navigator.pushNamed(
                context,
                DestinationPage.routeName,
                arguments: DestinationPageArguments(
                    title: context.read<HomeBloc>().selectedServiceType == 0
                        ? 'Taxi'
                        : 'Delivery',
                    pickupAddress: context.read<HomeBloc>().currentLocation,
                    pickupLatLng: context.read<HomeBloc>().currentLatLng,
                    dropAddress: state.dropAddress,
                    dropLatLng: state.dropLatLng,
                    userData: context.read<HomeBloc>().userData!,
                    pickUpChange: state.isPickupChange,
                    transportType:
                        context.read<HomeBloc>().selectedServiceType == 0
                            ? 'taxi'
                            : 'delivery',
                    isOutstationRide: false,
                    mapType: context.read<HomeBloc>().mapType),
              );
            } else if (state is RecentSearchPlaceSelectState) {
              context.read<HomeBloc>().add(ServiceLocationVerifyEvent(
                  address: [state.address], rideType: state.transportType));
            } else if (state is ConfirmRideAddressState) {
              if (context.read<HomeBloc>().nearByVechileSubscription != null) {
                context.read<HomeBloc>().nearByVechileSubscription?.cancel();
                context.read<HomeBloc>().nearByVechileSubscription = null;
              }
              if (context.read<HomeBloc>().pickupAddressList.isNotEmpty &&
                  context.read<HomeBloc>().stopAddressList.length == 1) {
                dev.log("BookingPage.routeName ---22");
                Navigator.pushNamed(
                  context,
                  BookingPage.routeName,
                  arguments: BookingPageArguments(
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
                      userData: context.read<HomeBloc>().userData!,
                      transportType:
                          context.read<HomeBloc>().selectedServiceType == 0
                              ? 'taxi'
                              : 'delivery',
                      pickupAddressList:
                          context.read<HomeBloc>().pickupAddressList,
                      stopAddressList: context.read<HomeBloc>().stopAddressList,
                      polyString: '',
                      distance: '',
                      duration: '',
                      isOutstationRide: false,
                      mapType: context.read<HomeBloc>().mapType),
                );
              } else {
                context.read<HomeBloc>().stopAddressList.clear();
              }
            } else if (state is RentalSelectState) {
              Navigator.pushNamed(context, ConfirmLocationPage.routeName,
                      arguments: ConfirmLocationPageArguments(
                          userData: context.read<HomeBloc>().userData!,
                          isPickupEdit: true,
                          isEditAddress: false,
                          mapType: context.read<HomeBloc>().mapType,
                          transportType: ''))
                  .then(
                (value) {
                  if (!context.mounted) return;
                  if (value != null) {
                    if (context.read<HomeBloc>().nearByVechileSubscription !=
                        null) {
                      context
                          .read<HomeBloc>()
                          .nearByVechileSubscription
                          ?.cancel();
                      context.read<HomeBloc>().nearByVechileSubscription = null;
                    }
                    context.read<HomeBloc>().pickupAddressList.clear();
                    final add = value as AddressModel;
                    context.read<HomeBloc>().pickupAddressList.add(add);
                    dev.log("BookingPage.routeName ---33");
                    Navigator.pushNamed(
                      context,
                      BookingPage.routeName,
                      arguments: BookingPageArguments(
                          picklat: context
                              .read<HomeBloc>()
                              .pickupAddressList[0]
                              .lat
                              .toString(),
                          picklng: context
                              .read<HomeBloc>()
                              .pickupAddressList[0]
                              .lng
                              .toString(),
                          droplat: '',
                          droplng: '',
                          userData: context.read<HomeBloc>().userData!,
                          transportType: '',
                          pickupAddressList:
                              context.read<HomeBloc>().pickupAddressList,
                          stopAddressList: [],
                          polyString: '',
                          distance: '',
                          duration: '',
                          mapType: context.read<HomeBloc>().mapType,
                          isOutstationRide: false,
                          isRentalRide: true),
                    );
                  }
                },
              );
            } else if (state is RideWithoutDestinationState) {
              Navigator.pushNamed(context, ConfirmLocationPage.routeName,
                      arguments: ConfirmLocationPageArguments(
                          userData: context.read<HomeBloc>().userData!,
                          isPickupEdit: true,
                          isEditAddress: false,
                          mapType: context.read<HomeBloc>().mapType,
                          transportType: ''))
                  .then(
                (value) {
                  if (!context.mounted) return;
                  if (value != null) {
                    if (context.read<HomeBloc>().nearByVechileSubscription !=
                        null) {
                      context
                          .read<HomeBloc>()
                          .nearByVechileSubscription
                          ?.cancel();
                      context.read<HomeBloc>().nearByVechileSubscription = null;
                    }
                    context.read<HomeBloc>().pickupAddressList.clear();
                    final add = value as AddressModel;
                    context.read<HomeBloc>().pickupAddressList.add(add);
                    dev.log("BookingPage.routeName ---44");
                    Navigator.pushNamed(
                      context,
                      BookingPage.routeName,
                      arguments: BookingPageArguments(
                          picklat: context
                              .read<HomeBloc>()
                              .pickupAddressList[0]
                              .lat
                              .toString(),
                          picklng: context
                              .read<HomeBloc>()
                              .pickupAddressList[0]
                              .lng
                              .toString(),
                          droplat: '',
                          droplng: '',
                          userData: context.read<HomeBloc>().userData!,
                          transportType: 'taxi',
                          pickupAddressList:
                              context.read<HomeBloc>().pickupAddressList,
                          stopAddressList: [],
                          polyString: '',
                          distance: '',
                          duration: '',
                          mapType: context.read<HomeBloc>().mapType,
                          isRentalRide: false,
                          isOutstationRide: false,
                          isWithoutDestinationRide: true),
                    );
                  }
                },
              );
            } else if (state is UserOnTripState) {
              if (context.read<HomeBloc>().nearByVechileSubscription != null) {
                context.read<HomeBloc>().nearByVechileSubscription?.cancel();
                context.read<HomeBloc>().nearByVechileSubscription = null;
              }
              dev.log("BookingPage.routeName ---55");
              Navigator.pushNamedAndRemoveUntil(
                  context, BookingPage.routeName, (route) => false,
                  arguments: BookingPageArguments(
                      picklat: state.tripData.pickLat,
                      picklng: state.tripData.pickLng,
                      droplat: state.tripData.dropLat,
                      droplng: state.tripData.dropLng,
                      pickupAddressList:
                          context.read<HomeBloc>().pickupAddressList,
                      stopAddressList: context.read<HomeBloc>().stopAddressList,
                      userData: context.read<HomeBloc>().userData!,
                      transportType: state.tripData.transportType,
                      polyString: state.tripData.polyLine,
                      distance: state.tripData.totalDistance,
                      duration: state.tripData.totalTime.toString(),
                      requestId: state.tripData.id,
                      mapType: context.read<HomeBloc>().mapType,
                      isOutstationRide: state.tripData.isOutStation == "1"));
            } else if (state is UserTripSummaryState) {
              if (context.read<HomeBloc>().nearByVechileSubscription != null) {
                context.read<HomeBloc>().nearByVechileSubscription?.cancel();
                context.read<HomeBloc>().nearByVechileSubscription = null;
              }
              Navigator.pushNamedAndRemoveUntil(
                context,
                TripSummaryPage.routeName,
                (route) => false,
                arguments: TripSummaryPageArguments(
                    requestData: state.requestData,
                    requestBillData: state.requestBillData,
                    driverData: state.driverData),
              );
            } else if (state is ServiceNotAvailableState) {
              context.read<HomeBloc>().stopAddressList.clear();
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
                                child: Icon(Icons.cancel_outlined,
                                    color: Theme.of(context).primaryColor))),
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
            }
          } catch (e) {
            log("Error in BlocListener: $e");
          }
        },

        ///////////
        child: Scaffold(
          body: BlocBuilder<BottomNavCubit, int>(
            builder: (context, selectedIndex) {
              return BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                final homeBloc = context.read<HomeBloc>();
                return Stack(
                  children: [
                    Opacity(
                      opacity: selectedIndex == 0 ? 1.0 : 0.0,
                      child: IgnorePointer(
                        ignoring: selectedIndex != 0,
                        child: HomePageContent(),
                      ),
                    ),
                    Builder(builder: (context) {
                      return BlocProvider.value(
                        value: homeBloc,
                        child: Opacity(
                          opacity: selectedIndex == 1 ? 1.0 : 0.0,
                          child: IgnorePointer(
                            ignoring: selectedIndex != 1,
                            child: ServicesPage(),
                          ),
                        ),
                      );
                    }),
                    Builder(builder: (context) {
                      return BlocProvider.value(
                        value: homeBloc,
                        child: Opacity(
                          opacity: selectedIndex == 2 ? 1.0 : 0.0,
                          child: IgnorePointer(
                            ignoring: selectedIndex != 2,
                            child: HistoryPage(),
                          ),
                        ),
                      );
                    }),
                    Builder(builder: (context) {
                      return BlocProvider.value(
                        value: homeBloc,
                        child: Opacity(
                          opacity: selectedIndex == 3 ? 1.0 : 0.0,
                          child: IgnorePointer(
                            ignoring: selectedIndex != 3,
                            child: BlocBuilder<HomeBloc, HomeState>(
                              builder: (context, state) {
                                if (state is HomeUserDataState) {
                                  // log("state.userData:${state.userData}");
                                  return WalletHistoryPage(
                                      arg: WalletPageArguments(
                                          userData: state.userData));
                                }
                                return Center(
                                  child: Text(""),
                                ); // Fallback in case userData is not available yet
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                    Builder(builder: (context) {
                      return BlocProvider.value(
                        value: homeBloc,
                        child: Opacity(
                          opacity: selectedIndex == 4 ? 1.0 : 0.0,
                          child: IgnorePointer(
                            ignoring: selectedIndex != 4,
                            child: BlocBuilder<HomeBloc, HomeState>(
                              builder: (context, state) {
                                if (state is HomeUserDataState) {
                                  return AccountPage(
                                      arg: AccountPageArguments(
                                          userData: state.userData));
                                }
                                return Center(
                                  child: Text(""),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              });
            },
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: BlocBuilder<BottomNavCubit, int>(
                builder: (context, selectedIndex) {
                  return GNav(
                    gap: 8,
                    selectedIndex: selectedIndex,
                    onTabChange: (index) {
                      context.read<BottomNavCubit>().setSelectedIndex(index);
                      final homeBloc = context.read<HomeBloc>();

                      if (index == 3 || index == 4) {
                        if (homeBloc.state is! HomeUserDataState) {
                          final userData = homeBloc.userData;
                          homeBloc
                              .add(UpdateUserDataEvent(userData: userData!));
                        }

                        // context.read<BottomNavCubit>().setSelectedIndex(4);
                      }
                    },
                    backgroundColor: AppColors.black,
                    color: AppColors.grey,
                    activeColor: AppColors.grey,
                    tabBackgroundColor: AppColors.primary,
                    padding: const EdgeInsets.all(16),
                    tabs: [
                      GButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        icon: Icons.directions_car_filled_outlined,
                        text: 'Ride',
                      ),
                      GButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        icon: Icons.difference_outlined,
                        text: 'Services',
                      ),
                      GButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        icon: Icons.assignment_sharp,
                        text: 'History',
                      ),
                      GButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        icon: Icons.currency_exchange,
                        text: 'Payment',
                      ),
                      GButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        icon: Icons.account_circle,
                        text: 'Profile',
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
