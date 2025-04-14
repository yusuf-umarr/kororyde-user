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
                    OurServiceCard(
                      onTap: () {
                        context
                            .read<HomeBloc>()
                            .add(ServiceTypeChangeEvent(serviceTypeIndex: 0));
                        context
                            .read<HomeBloc>()
                            .add(DestinationSelectEvent(isPickupChange: false));
                      },
                      bg: AppColors.serviceGreen,
                      title: "Ride",
                      icon: 'assets/png/rideIcon.png',
                    ),
                    OurServiceCard(
                      onTap: () {
                        context
                            .read<HomeBloc>()
                            .add(ServiceTypeChangeEvent(serviceTypeIndex: 1));
                      },
                      bg: AppColors.serviceYellow,
                      title: "Delievry",
                      icon: 'assets/png/deliveryIcon.png',
                    ),
                    OurServiceCard(
                      onTap: () {
                        context
                            .read<HomeBloc>()
                            .add(ServiceTypeChangeEvent(serviceTypeIndex: 2));
                      },
                      bg: AppColors.servicePurple,
                      title: "Rental",
                      icon: 'assets/png/rentalIcon.png',
                    ),
                    OurServiceCard(
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
                      bg: AppColors.serviceRed,
                      title: "Bill payment ",
                      icon: 'assets/png/invest.png',
                    ),
                    OurServiceCard(
                      onTap: () {},
                      bg: AppColors.serviceBrown,
                      title: "Adverts",
                      icon: 'assets/png/advertIcon.png',
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

class OurServiceCard extends StatelessWidget {
  final void Function()? onTap;
  final Color bg;
  final String title;
  final String icon;
  const OurServiceCard({
    super.key,
    this.onTap,
    required this.bg,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: bg.withOpacity(0.5), 
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              width: size.width * 0.22,
              height: size.height * 0.09,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white),
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Image.asset(
                icon,
                height: size.width * 0.05,
              ),
            ),
            const SizedBox(height: 10),
            MyText(
              text: title,
              textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
