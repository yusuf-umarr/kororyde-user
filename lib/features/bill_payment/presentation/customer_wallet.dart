import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kororyde_user/common/app_colors.dart';
import 'package:kororyde_user/common/custom_spacer.dart';
import 'package:kororyde_user/core/utils/utils.dart';
import 'package:kororyde_user/features/bill_payment/presentation/buy_airtime.dart';
import 'package:kororyde_user/features/bill_payment/presentation/buy_data.dart';
import 'package:kororyde_user/features/bill_payment/presentation/buy_electricity.dart';
import 'package:kororyde_user/features/bill_payment/presentation/cable_tv.dart';
import 'package:kororyde_user/features/bill_payment/presentation/education.dart';

// import 'package:provider/provider.dart';

class CustomerWalletScreen extends StatelessWidget {
  const CustomerWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          WalletHeader(),
          PaymentList(),
          TopUpCard(),
        ],
      ),
    );
  }
}

class WalletHeader extends StatefulWidget {
  const WalletHeader({
    super.key,
  });

  @override
  State<WalletHeader> createState() => _WalletHeaderState();
}

class _WalletHeaderState extends State<WalletHeader> {
  bool visibility = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: size.height * 0.06),
        child: Container(
          height: size.height * 0.4,
          width: size.width,
          decoration: BoxDecoration(
            // color: AppColors.blue,
            image: DecorationImage(
              image: AssetImage(
                "assets/png/walletBg.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    const CustomSpacer(
                      flex: 10,
                    ),
                    Text(
                      "Your Balance",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 14, color: AppColors.white),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          visibility ? "${getCurrency()}0:0" : "*****",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize: 22,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                visibility = !visibility;
                              });
                            },
                            icon: Icon(
                              visibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.white,
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Row(
                  children: [
                    Container(
                      height: size.height * 0.08,
                      width: size.width * 0.08,
                      margin: EdgeInsets.only(
                          left: size.width * 0.05, right: size.width * 0.05),
                      decoration: const BoxDecoration(
                        color: AppColors.whiteText,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(5.0, 5.0),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          CupertinoIcons.back,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                // InkWell(
                //   onTap: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: Container(
                //     alignment: Alignment.center,
                //     padding: EdgeInsets.all(5),
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle, color: Colors.white),
                //     child: Icon(
                //       Icons.arrow_back_ios,
                //       color: AppColors.primary,
                //     ),
                //   ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentList extends StatelessWidget {
  const PaymentList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.all(20),
        width: size.width,
        height: size.height * 0.58,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSpacer(
              flex: 6,
            ),
            Text(
              "Services",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: size.height * 0.45,
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                children: [
                  ServiceCard(
                    icon: "assets/svg/data.svg",
                    name: "Airtime",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuyAirtime(),
                        ),
                      );
                    },
                  ),
                  ServiceCard(
                    icon: "assets/svg/internet.svg",
                    name: "Data",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuyMobileData(),
                        ),
                      );
                    },
                  ),
                  ServiceCard(
                    icon: "assets/svg/streaming.svg",
                    name: "Cable Tv",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CableTV(),
                        ),
                      );
                    },
                  ),
                  ServiceCard(
                    icon: "assets/svg/electricity.svg",
                    name: "Electricity",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuyElectricity(),
                        ),
                      );
                    },
                  ),

                  ServiceCard(
                    icon: "assets/svg/education.svg",
                    name: "Education",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Education(),
                        ),
                      );
                    },
                  ),

                  // ServiceCard(
                  //   icon: "assets/svg/invest.svg",
                  //   name: "Invest",
                  //   onTap: () {
                  //     // cus.showConfirmDialogCustom(
                  //     //   isTwoBtn: true,
                  //     //   context,
                  //     //   positiveText: "Continue",
                  //     //   title:
                  //     //       "You are about to switch to the investor's portal. Do you want to proceed?",
                  //     //   subTitle: "",
                  //     //   dialogType: DialogType.ACCEPT,
                  //     //   onAccept: () {
                  //     //     context.read<AuthViewModel>().logOut();
                  //     //     // Navigator.of(context).pop();
                  //     //   },
                  //     //   onCancel: () {},
                  //     //   primaryColor: AppColors.blue,
                  //     // );
                  //   },
                  // ),
                ],
              ),
            ),
            //
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String icon;
  final String name;
  final void Function()? onTap;
  const ServiceCard({
    super.key,
    required this.icon,
    required this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(icon),
          const CustomSpacer(),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class TopUpCard extends StatelessWidget {
  const TopUpCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Positioned(
      top: size.height * 0.355,
      left: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: size.width,
        height: size.height * 0.08,
        decoration: BoxDecoration(),
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/svg/iconWallet.svg"),
                const CustomSpacer(
                  horizontal: true,
                ),
                Text(
                  "Top Up",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
