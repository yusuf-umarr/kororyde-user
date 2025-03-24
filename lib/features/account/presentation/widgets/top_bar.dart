import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kororyde_user/l10n/app_localizations.dart';
import '../../../../common/app_colors.dart';
import '../../application/acc_bloc.dart';
import '../../../../common/app_images.dart';
import '../../../../core/utils/custom_text.dart';

class TopBarDesign extends StatelessWidget {
  final String title;
  final bool isHistoryPage;
  final bool? isOngoingPage;
  final Widget? child;
  final Function()? onTap;
  final ScrollController? controller;

  const TopBarDesign(
      {super.key,
      this.child,
      required this.isHistoryPage,
      required this.title,
      this.onTap,
      this.isOngoingPage,
      this.controller});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
          height: size.height,
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                Container(
                  height: size.height * 0.25,
                ),
                if (isHistoryPage) SizedBox(height: size.width * 0.03),
                (isOngoingPage == true)
                    ? Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                          ),
                        ),
                        child: child,
                      )
                    : BlocBuilder<AccBloc, AccState>(
                        builder: (context, state) {
                          return Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                              ),
                            ),
                            child: child,
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
        ClipPath(
          clipper: ShapePainter(),
          child: Container(
              height: size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: const DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage(AppImages.map),
                ),
              )),
        ),
        SafeArea(
          child: SizedBox(
            height: size.width * 0.37,
            width: size.width,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.all(20.0),
                          //   child: Container(
                          //     height: size.height * 0.08,
                          //     width: size.width * 0.08,
                          //     decoration: const BoxDecoration(
                          //       // color:
                          //       //     Theme.of(context).scaffoldBackgroundColor,
                          //       color: AppColors.whiteText,
                          //       shape: BoxShape.circle,
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.black26,
                          //           offset: Offset(5.0, 5.0),
                          //           blurRadius: 10.0,
                          //           spreadRadius: 2.0,
                          //         ),
                          //       ],
                          //     ),
                          //     child: InkWell(
                          //         onTap: () {
                          //           Future.delayed(
                          //               const Duration(milliseconds: 100), () {
                          //             if (onTap != null) {
                          //               onTap!();
                          //             }
                          //           });
                          //         },
                          //         highlightColor: Theme.of(context)
                          //             .disabledColor
                          //             .withOpacity(0.1),
                          //         splashColor: Theme.of(context)
                          //             .disabledColor
                          //             .withOpacity(0.2),
                          //         hoverColor: Theme.of(context)
                          //             .disabledColor
                          //             .withOpacity(0.05),
                          //         child: const Icon(
                          //           CupertinoIcons.back,
                          //           size: 20,
                          //           // color: Theme.of(context).primaryColor,
                          //           color: AppColors.blackText,
                          //         )),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 20),
                            child: MyText(
                              text: title,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 20,
                                    // color: Theme.of(context).primaryColorLight,
                                    color: AppColors.whiteText,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      // if it is History page
                      if (isHistoryPage) ...[
                        BlocBuilder<AccBloc, AccState>(
                          builder: (context, state) {
                            final selectedIndex =
                                context.read<AccBloc>().selectedHistoryType;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildTab(
                                    context: context,
                                    title:
                                        AppLocalizations.of(context)!.completed,
                                    index: 0,
                                    selectedIndex: selectedIndex),
                                _buildTab(
                                    context: context,
                                    title:
                                        AppLocalizations.of(context)!.upcoming,
                                    index: 1,
                                    selectedIndex: selectedIndex),
                                _buildTab(
                                    context: context,
                                    title:
                                        AppLocalizations.of(context)!.cancelled,
                                    index: 2,
                                    selectedIndex: selectedIndex),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: size.width * 0.02),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }

//  History Ontap
  Widget _buildTab(
      {required BuildContext context,
      required String title,
      required int index,
      required int selectedIndex}) {
    return InkWell(
      onTap: () {
        if (index != selectedIndex && !context.read<AccBloc>().isLoading) {
          context.read<AccBloc>().history.clear();
          context.read<AccBloc>().add(AccUpdateEvent());
          context
              .read<AccBloc>()
              .add(HistoryTypeChangeEvent(historyTypeIndex: index));
        }
      },
      child: Stack(
        children: [
          MyText(
            text: title,
            textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                // color: index == selectedIndex
                //     ? Theme.of(context).scaffoldBackgroundColor
                //     : Theme.of(context).primaryColorLight,
                color: AppColors.whiteText),
          ),
          if (index == selectedIndex)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: 15,
                  height: 2,
                  // color: Theme.of(context).scaffoldBackgroundColor,
                  color: AppColors.white.withOpacity(0.8)),
            ),
        ],
      ),
    );
  }
}

class ShapePainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.675);
    path.quadraticBezierTo(size.width * 0.0, size.height * 0.5,
        size.width * 0.15, size.height * 0.5);
    path.lineTo(size.width, size.height * 0.5);
    path.quadraticBezierTo(
        size.width, size.height * 0.5, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
