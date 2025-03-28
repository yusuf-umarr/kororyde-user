import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                height: size.height * 0.45,
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  children: [
                    GestureDetector(
                      onTap: () {
                        // context
                        //     .read<HomeBloc>()
                        //     .add(ServiceTypeChangeEvent(serviceTypeIndex: 0));

                        context
                            .read<HomeBloc>()
                            .add(DestinationSelectEvent(isPickupChange: false));
                      },
                      child: Card(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/png/ride.png',
                                height: size.width * 0.10,
                              ),
                              const SizedBox(height: 10),
                              MyText(
                                text: AppLocalizations.of(context)!.taxi,
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
                    GestureDetector(
                      onTap: () {
                        context
                            .read<HomeBloc>()
                            .add(ServiceTypeChangeEvent(serviceTypeIndex: 1));
                      },
                      child: Card(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/png/delivery.png',
                                height: size.width * 0.10,
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
                    GestureDetector(
                      onTap: () {
                        context
                            .read<HomeBloc>()
                            .add(ServiceTypeChangeEvent(serviceTypeIndex: 2));
                      },
                      child: Card(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/png/rental.png',
                                height: size.width * 0.10,
                              ),
                              const SizedBox(height: 10),
                              MyText(
                                text: AppLocalizations.of(context)!.rental,
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
                    Card(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/png/advertise.png',
                              height: size.width * 0.10,
                            ),
                            const SizedBox(height: 10),
                            MyText(
                              text: "Adverts",
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerWalletScreen(),
                          ),
                        );
                      },
                      child: Card(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/png/invest.png',
                                height: size.width * 0.10,
                              ),
                              const SizedBox(height: 10),
                              MyText(
                                text: 'Payment',
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
                    // Card(
                    //   child: Container(
                    //     padding:
                    //         EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         Image.asset(
                    //           'assets/png/delivery.png',
                    //           height: size.width * 0.10,
                    //         ),
                    //         const SizedBox(height: 10),
                    //         MyText(
                    //           text: AppLocalizations.of(context)!.delivery,
                    //           // text: 'Delivery',
                    //           textStyle: Theme.of(context)
                    //               .textTheme
                    //               .bodySmall!
                    //               .copyWith(
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
