import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kororyde_user/common/app_colors.dart';
import 'package:kororyde_user/common/custom_spacer.dart';
import 'package:kororyde_user/core/extensions/validator_extension.dart';
import 'package:kororyde_user/core/utils/custom_button.dart';
import 'package:kororyde_user/core/utils/custom_textfield.dart';
import 'package:kororyde_user/core/utils/utils.dart';
import 'package:kororyde_user/features/bill_payment/application/home_view_model.dart';
// import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
// import 'package:flutter_native_contact_picker/model/contact.dart';

import 'package:provider/provider.dart';

class Education extends StatefulWidget {
  const Education({super.key});

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _networkController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // final FlutterNativeContactPicker _contactPicker =
  //     FlutterNativeContactPicker();
  // List<Contact>? _contacts;

  final _formkey = GlobalKey<FormState>();

  bool isOpen = false;

  List<String> networkType = [
    'JAMB',
    'WAEC',
    'NECO',
  ];

  bool isChecked = false;

  void setDataType() {
    // final homeVM = context.read<HomeViewModel>();
    // networkType = homeVM.dataTypeModel!.network;
  }

  @override
  void initState() {
    setDataType();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _networkController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          "Education",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
        ),
      ),
      body: SafeArea(
        child: Builder(builder: (context) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   children: [
                              //     Column(
                              //       children: [
                              //         Container(
                              //           padding: const EdgeInsets.all(10),
                              //           decoration: BoxDecoration(
                              //             color: AppColors.white,
                              //             borderRadius:
                              //                 BorderRadius.circular(12),
                              //           ),
                              // child: Image.asset(
                              //   "assets/pngs/mtn.png",
                              // ),
                              //         )
                              //       ],
                              //     ),
                              //     const SizedBox(width: 10),
                              //     Expanded(
                              //       child: Column(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: [
                              //           Text(
                              //             "Buy Airtime",
                              //             textAlign: TextAlign.start,
                              //             style: Theme.of(context)
                              //                 .textTheme
                              //                 .bodyMedium
                              //                 ?.copyWith(
                              //                   fontWeight: FontWeight.w500,
                              //                   fontSize: 20,
                              //                 ),
                              //           ),
                              //           const SizedBox(height: 5),
                              //           Text(
                              //             "Buy airtime fast ⚡️ and easy",
                              //             style: Theme.of(context)
                              //                 .textTheme
                              //                 .bodyMedium
                              //                 ?.copyWith(
                              //                   fontWeight: FontWeight.w400,
                              //                 ),
                              //           ),
                              //           const SizedBox(height: 20),
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // const DottedLineWidget(),
                              SizedBox(height: size.height * 0.03),

                              // const SizedBox(height: 8),
                              // InkWell(
                              //   onTap: () async {
                              //     Contact? contact =
                              //         await _contactPicker.selectContact();
                              //     setState(() {
                              //       _contacts =
                              //           contact == null ? null : [contact];

                              //       _phoneController.text = _contacts
                              //           .toString()
                              //           .split(":")[1]
                              //           .replaceAll("[", "")
                              //           .replaceAll("]", "");
                              //     });
                              //   },
                              //   child: Text(
                              //     "Choose from contact",
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .bodyMedium
                              //         ?.copyWith(
                              //           fontWeight: FontWeight.w500,
                              //           color: AppColors.primary,
                              //           decoration: TextDecoration.underline,
                              //         ),
                              //   ),
                              // ),
                              // SizedBox(height: size.height * 0.03),
                              Text(
                                "Service Provider",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              const SizedBox(height: 5),
                              CustomTextField(
                                onTap: () {
                                  setState(() {
                                    isOpen = true;
                                  });
                                },
                                readOnly: true,
                                hintText: "Choose a provider",
                                controller: _networkController,
                                suffixIcon:
                                    const Icon(Icons.keyboard_arrow_down),
                                validator: context.validateNotEmpty,
                              ),
                              if (isOpen)
                                Card(
                                  color: AppColors.primary.withOpacity(0.3),
                                  child: Column(
                                      children: List.generate(
                                          networkType.length, (int index) {
                                    return ListTile(
                                      onTap: () {
                                        _networkController.text =
                                            networkType[index];
                                        setState(() {
                                          isOpen = false;
                                        });
                                      },
                                      title: Text(
                                        networkType[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    );
                                  })),
                                ),
                              SizedBox(height: size.height * 0.03),
                              Text(
                                "Package ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              const SizedBox(height: 5),
                              CustomTextField(
                                onTap: () {
                                  setState(() {
                                    isOpen = true;
                                  });
                                },
                                readOnly: true,
                                hintText: "Choose a package",
                                controller: _networkController,
                                suffixIcon:
                                    const Icon(Icons.keyboard_arrow_down),
                                validator: context.validateNotEmpty,
                              ),
                              if (isOpen)
                                Card(
                                  color: AppColors.primary.withOpacity(0.3),
                                  child: Column(
                                      children: List.generate(
                                          networkType.length, (int index) {
                                    return ListTile(
                                      onTap: () {
                                        _networkController.text =
                                            networkType[index];
                                        setState(() {
                                          isOpen = false;
                                        });
                                      },
                                      title: Text(
                                        networkType[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    );
                                  })),
                                ),
                              SizedBox(height: size.height * 0.03),
                              Text(
                                "Phone Number  ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              const SizedBox(height: 5),
                              CustomTextField(
                                keyboardType: TextInputType.number,
                                hintText: "Enter Phone Number ",
                                controller: _phoneController,
                                validator: context.validateNotEmpty,
                                // formatters: [
                                //   FilteringTextInputFormatter.allow(
                                //       RegExp(r'[^\+\-\s\.\(\)\/\#\*\N\;\,]')),
                                // ],
                              ),
                              SizedBox(height: size.height * 0.03),
                              Text(
                                "Profile Code  ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              const SizedBox(height: 5),
                              CustomTextField(
                                keyboardType: TextInputType.number,
                                hintText: "Enter Profile Code ",
                                controller: _phoneController,
                                validator: context.validateNotEmpty,
                                // formatters: [
                                //   FilteringTextInputFormatter.allow(
                                //       RegExp(r'[^\+\-\s\.\(\)\/\#\*\N\;\,]')),
                                // ],
                              ),
                              SizedBox(height: size.height * 0.03),
                              Text(
                                "Amount ${getCurrency()}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              const SizedBox(height: 5),
                              Consumer<HomeViewModel>(
                                  builder: (context, homeVM, _) {
                                // bool readOnly = homeVM.validateRes.isNotEmpty;
                                return CustomTextField(
                                  onTap: () {
                                    // homeVM.clearMeterName();
                                  },
                                  // readOnly: readOnly,
                                  keyboardType: TextInputType.number,
                                  hintText: "${getCurrency()}0.00",
                                  controller: _amountController,
                                  validator: context.validateNotEmpty,
                                  // formatters: [
                                  //   FilteringTextInputFormatter.allow(
                                  //       RegExp(r'[^\+\-\s\.\(\)\/\#\*\N\;\,]')),
                                  // ],
                                );
                              }),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.1),
                        Consumer<HomeViewModel>(builder: (context, homeVM, _) {
                          return CustomButton(
                            buttonName: "Next",
                            onTap: () async {},
                          );
                        }),
                        const CustomSpacer(flex: 4),
                      ],
                    ),
                  ),
                ),
              ),
              // LoaderWidget(),
            ],
          );
        }),
      ),
    );
  }

  PersistentBottomSheetController paymentDialog(
      BuildContext context, Size size) {
    return showBottomSheet(
      enableDrag: true,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(
                20,
              ),
            )),
        padding: EdgeInsets.all(15),
        height: size.height * 0.46,
        width: size.width,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${getCurrency()}1,000.00",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 23,
                      ),
                ),
                const CustomSpacer(flex: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Biller",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.grey4),
                    ),
                    Text(
                      "MTN Data",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.grey4),
                    ),
                  ],
                ),
                const CustomSpacer(flex: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.grey4,
                          ),
                    ),
                    Text(
                      "2.5GB for 30 Days",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.grey4),
                    ),
                  ],
                ),
                const CustomSpacer(flex: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recipent",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.grey4),
                    ),
                    Text(
                      "091234567890",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.grey4),
                    ),
                  ],
                ),
                const CustomSpacer(flex: 6),
             CustomButton(
                            buttonName: "Wallet Balance",
                            onTap: () async {},
                          ),
                const CustomSpacer(
                  flex: 4,
                ),
               CustomButton(
                            buttonName: "Bank transfer",
                            onTap: () async {},
                          ),
              ],
            ),
            Positioned(
              right: 1,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.1)),
                    child: const Icon(
                      Icons.cancel,
                      color: AppColors.red,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
