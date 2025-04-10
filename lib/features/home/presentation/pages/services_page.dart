import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kororyde_user/common/app_colors.dart';
import 'package:kororyde_user/core/utils/custom_text.dart';
import 'package:kororyde_user/features/bill_payment/presentation/customer_wallet.dart';
import 'package:kororyde_user/features/home/application/home_bloc.dart';
import 'package:kororyde_user/l10n/app_localizations.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.01),
              MyText(
                text: 'Our service',
                // text: 'Delivery',
                textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              MyText(
                text: 'Choose how we can best serve you today',
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
              ),
              SizedBox(height: size.height * 0.05),
              SizedBox(
                height: size.height * 0.5,
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  children: [
                    InkWell(
                      onTap: () {
                        context
                            .read<HomeBloc>()
                            .add(ServiceTypeChangeEvent(serviceTypeIndex: 0));
                        context
                            .read<HomeBloc>()
                            .add(DestinationSelectEvent(isPickupChange: false));
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: size.width * 0.22,
                                height: size.height * 0.09,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.serviceGreen),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Image.asset(
                                  'assets/png/rideIcon.png',
                                  height: size.width * 0.05,
                                ),
                              ),
                              const SizedBox(height: 10),
                              MyText(
                                text: AppLocalizations.of(context)!.taxi,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context
                            .read<HomeBloc>()
                            .add(ServiceTypeChangeEvent(serviceTypeIndex: 1));
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: size.width * 0.22,
                                height: size.height * 0.09,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.serviceYellow),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Image.asset(
                                  'assets/png/deliveryIcon.png',
                                  height: size.width * 0.05,
                                ),
                              ),
                              const SizedBox(height: 10),
                              MyText(
                                text: AppLocalizations.of(context)!.delivery,
                                // text: 'Delivery',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context
                            .read<HomeBloc>()
                            .add(ServiceTypeChangeEvent(serviceTypeIndex: 2));
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: size.width * 0.22,
                                height: size.height * 0.09,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.servicePurple),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Image.asset(
                                  'assets/png/rentalIcon.png',
                                  height: size.width * 0.05,
                                ),
                              ),
                              const SizedBox(height: 10),
                              MyText(
                                text: AppLocalizations.of(context)!.rental,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<HomeBloc>(),
                              child: CustomerWalletScreen(),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: size.width * 0.22,
                                height: size.height * 0.09,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.serviceRed),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Image.asset(
                                  'assets/png/invest.png',
                                  height: size.width * 0.11,
                                ),
                              ),
                              const SizedBox(height: 10),
                              MyText(
                                text: "Bill payment",
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: size.width * 0.22,
                                height: size.height * 0.09,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.serviceBrown),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Image.asset(
                                  'assets/png/advertIcon.png',
                                  height: size.width * 0.11,
                                ),
                              ),
                              const SizedBox(height: 10),
                              MyText(
                                text: "Advertise",
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
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
}
