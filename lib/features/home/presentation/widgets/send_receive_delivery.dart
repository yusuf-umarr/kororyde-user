import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kororyde_user/l10n/app_localizations.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/home_bloc.dart';
import '../pages/destination_page.dart';

class SendOrReceiveDelivery extends StatelessWidget {
  const SendOrReceiveDelivery({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Container(
          width: size.width,
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: size.width * 0.05),
              Image.asset(AppImages.parcel, height: size.width * 0.2),
              SizedBox(height: size.width * 0.01),
              MyText(
                  text: AppLocalizations.of(context)!.sendAndReceive,
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: size.width * 0.01),
              MyText(
                text: AppLocalizations.of(context)!.ourParcelService,
                maxLines: 2,
                textAlign: TextAlign.center,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.width * 0.1),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          DestinationPage.routeName,
                          arguments: DestinationPageArguments(
                              title: 'Send Parcel',
                              pickupAddress:
                                  context.read<HomeBloc>().currentLocation,
                              pickupLatLng:
                                  context.read<HomeBloc>().currentLatLng,
                              userData: context.read<HomeBloc>().userData!,
                              pickUpChange: false,
                              mapType: context.read<HomeBloc>().mapType,
                              isOutstationRide: false,
                              transportType: 'delivery'),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: AppColors.primary),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/sendParcel.svg",
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Send Parcel",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          DestinationPage.routeName,
                          arguments: DestinationPageArguments(
                              title: 'Receive Parcel',
                              dropAddress:
                                  context.read<HomeBloc>().currentLocation,
                              dropLatLng:
                                  context.read<HomeBloc>().currentLatLng,
                              userData: context.read<HomeBloc>().userData!,
                              pickUpChange: true,
                              mapType: context.read<HomeBloc>().mapType,
                              isOutstationRide: false,
                              transportType: 'delivery'),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: AppColors.primary.withOpacity(0.1)),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/receiveParcel.svg",
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Receive Parcel",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.width * 0.1),
            ],
          ),
        );
      },
    );
  }
}
