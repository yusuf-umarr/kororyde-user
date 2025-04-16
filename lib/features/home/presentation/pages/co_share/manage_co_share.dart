import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kororyde_user/common/app_colors.dart';
import 'package:kororyde_user/core/utils/custom_button.dart';
import 'package:kororyde_user/core/utils/custom_text.dart';
import 'package:kororyde_user/features/bottom_nav/presentation/bottom_nav.dart';
import 'package:kororyde_user/features/home/application/home_bloc.dart';
import 'package:kororyde_user/features/home/domain/models/incoming_coshare_request_model.dart';
import 'package:kororyde_user/features/home/presentation/pages/co_share/cosharer_detail.dart';
import 'dart:developer';

class ManageCoSharePage extends StatefulWidget {
  const ManageCoSharePage({super.key});

  @override
  State<ManageCoSharePage> createState() => _ManageCoSharePageState();
}

class _ManageCoSharePageState extends State<ManageCoSharePage> {
  @override
  void initState() {
    context.read<HomeBloc>().add(GetIncomingCoShareEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          text: "Manage Co-Share",
          textStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is IncomingCoshareState && state.data.length > 0) {
          log("--state.data.length:${state.data.length}");
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10).copyWith(top: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    manageCoShareHeaderCard(size,
                        title: 'Expected Co-Sharers', value: '5'),
                    SizedBox(width: 10),
                    manageCoShareHeaderCard(size,
                        title: 'Confirmed Co-Sharers', value: '2'),
                    SizedBox(width: 10),
                    manageCoShareHeaderCard(size,
                        title: 'Total Requests',
                        value:
                            '${state.data.isNotEmpty ? state.data.first.totalRequests : "0"}'),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Builder(builder: (context) {
                      final notPending =
                          state.data.every((item) => item.status != "pending");

                      return Column(
                        children: notPending
                            ? [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 20),
                                    Image.asset("assets/png/emptyState.png"),
                                    Text("No incoming co-share request"),
                                  ],
                                )
                              ]
                            : [
                                ...state.data.map((item) {
                                  if (item.status == "pending") {
                                    return IncomingRequestCard(request: item);
                                  }
                                  return const SizedBox.shrink();
                                }).toList(),
                              ],
                      );
                    }),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        } else if (state is SendOfferDoneState) {
          final homeBloc = context.read<HomeBloc>();

          WidgetsBinding.instance.addPostFrameCallback((_) {
  showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    builder: (_) {
      final Size size = MediaQuery.of(context).size;
      return BlocProvider.value(
        value: homeBloc,
        child: sendOfferPopUp(size),
      );
    },
  );
});


       
        }
        return FutureBuilder(
          future: Future.delayed(const Duration(seconds: 2)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/png/emptyState.png"),
                  Text("No incoming co-share request"),
                  Row()
                ],
              );
            }
          },
        );
      }),
    );
  }

  StatefulBuilder sendOfferPopUp(Size size) {
    return StatefulBuilder(builder: (context, setState) {
      return Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 40),
            height: size.height * 0.40,
            child: Column(
              children: [
                Image.asset("assets/png/accept.png"),
                SizedBox(height: 20),
                MyText(
                  text: "Offer sent ",
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                ),
                SizedBox(height: 10),
                MyText(
                  text:
                      "Your offer has been sent successfully. Please wait for their response.",
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  buttonName: "Go Home",
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomePage.routeName, (route) => false);
                  },
                )
              ],
            ),
          ),
        ],
      );
    });
  }

  Expanded manageCoShareHeaderCard(Size size,
      {required String title, required String value}) {
    return Expanded(
      child: Container(
        height: size.height * 0.08,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.primary,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$title",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 9,
                ),
              ),
              Text(
                "$value",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IncomingRequestCard extends StatefulWidget {
  final IncomingCoShareData request;
  const IncomingRequestCard({
    super.key,
    required this.request,
  });

  @override
  State<IncomingRequestCard> createState() => _IncomingRequestCardState();
}

class _IncomingRequestCardState extends State<IncomingRequestCard> {
  final TextEditingController _offerController =
      TextEditingController(text: '100');
  int coShareMaxSeats = 100;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(10),
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
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: "${widget.request.user!.name}",
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
                              text: "${widget.request.pickupAddress}",
                              maxLines: 4,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
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
                              text: "${widget.request.pickupAddress}",
                              maxLines: 4,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<HomeBloc>(),
                              child: CosharerDetail(
                                isRequest: true,
                                request: widget.request,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.primary.withOpacity(0.1)),
                        child: Row(
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
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.primary.withOpacity(0.1)),
                        child: Row(
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
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
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
                            final Size size = MediaQuery.of(context).size;
                            return BlocProvider.value(
                              value: context.read<HomeBloc>(),
                              child:
                                  StatefulBuilder(builder: (context, setState) {
                                return Stack(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20)
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
                                                text: "Your offer",
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
                                          Row(
                                            children: [
                                              MyText(
                                                text:
                                                    "Input how much you would like to charge",
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          SizedBox(height: 30),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  width: size.width * 0.20,
                                                  child: Center(
                                                    child: TextFormField(
                                                      controller:
                                                          _offerController,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          final parsedVal =
                                                              int.tryParse(val);
                                                          if (parsedVal !=
                                                              null) {
                                                            coShareMaxSeats =
                                                                parsedVal;
                                                            _offerController
                                                                    .text =
                                                                parsedVal
                                                                    .toString();
                                                          }
                                                        });
                                                      },
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (coShareMaxSeats > 100)
                                                      coShareMaxSeats -= 100;
                                                    _offerController.text =
                                                        coShareMaxSeats
                                                            .toString();
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Colors.red),
                                                    color:
                                                        Colors.red.withOpacity(
                                                      0.4,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "-100",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    coShareMaxSeats += 100;
                                                    _offerController.text =
                                                        coShareMaxSeats
                                                            .toString();
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Colors.green),
                                                    color: Colors.green
                                                        .withOpacity(
                                                      0.4,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "+100",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.025,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors
                                                                  .primary),
                                                  onPressed: () {
                                                    final bloc = context
                                                        .read<HomeBloc>();
                                                    bloc.add(
                                                      SendCoShareOfferEvent(
                                                        amount: _offerController
                                                            .text,
                                                        coShareRequestId: widget
                                                            .request.id
                                                            .toString(),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Send offer",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
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
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.primary.withOpacity(0.1)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.currency_exchange,
                              color: AppColors.primary,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Text(
                                "Offer",
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
                ],
              )
              //////
            ],
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: InkWell(
            onTap: () {
              final bloc = context.read<HomeBloc>();
              bloc.add(AcceptRejectCoshareRequestEvent(
                  status: "reject",
                  coShareRequestId: widget.request.id.toString()));
              //AcceptRejectCoshareRequestEvent
              log("--request id:${widget.request.id}");
            },
            child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.1)),
                child: Icon(Icons.cancel_outlined, color: Colors.red)),
          ),
        )
      ],
    );
  }

  StatefulBuilder declineOfferMethod(Size size) {
    return StatefulBuilder(builder: (context, setState) {
      return Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 40),
            height: size.height * 0.38,
            child: Column(
              children: [
                Image.asset("assets/png/accept.png"),
                SizedBox(height: 20),
                MyText(
                  text: "You've declined Adam's offer and he has been notified",
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  buttonName: "Go Home",
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomePage.routeName, (route) => false);
                  },
                )
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
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.red,
              ),
            ),
          )
        ],
      );
    });
  }
}
//

/*

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
                            final Size size = MediaQuery.of(context).size;
                            return BlocProvider.value(
                              value: context.read<HomeBloc>(),
                              child:
                                  StatefulBuilder(builder: (context, setState) {
                                return Stack(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20)
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
                                                text: "Your offer",
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
                                          Row(
                                            children: [
                                              MyText(
                                                text:
                                                    "Input how much you would like to charge",
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          SizedBox(height: 30),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  width: size.width * 0.20,
                                                  child: Center(
                                                    child: TextFormField(
                                                      controller:
                                                          _offerController,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          final parsedVal =
                                                              int.tryParse(val);
                                                          if (parsedVal !=
                                                              null) {
                                                            coShareMaxSeats =
                                                                parsedVal;
                                                            _offerController
                                                                    .text =
                                                                parsedVal
                                                                    .toString();
                                                          }
                                                        });
                                                      },
                                                      keyboardType: TextInputType.number,
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (coShareMaxSeats > 100)
                                                      coShareMaxSeats -= 100;
                                                    _offerController.text =
                                                        coShareMaxSeats
                                                            .toString();
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Colors.red),
                                                    color:
                                                        Colors.red.withOpacity(
                                                      0.4,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "-100",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    coShareMaxSeats += 100;
                                                    _offerController.text =
                                                        coShareMaxSeats
                                                            .toString();
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Colors.green),
                                                    color: Colors.green
                                                        .withOpacity(
                                                      0.4,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "+100",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.025,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors
                                                                  .primary),
                                                  onPressed: () {
                                                    //acceptOfferMethod
                                                    final bloc = context
                                                        .read<HomeBloc>();
                                                    bloc.add(
                                                      SendCoShareOfferEvent(
                                                        amount: _offerController
                                                            .text,
                                                        coShareRequestId: widget
                                                            .request.id
                                                            .toString(),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Send offer",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
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
*/