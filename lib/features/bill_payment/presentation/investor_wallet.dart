// import 'package:flutter/material.dart';
// import 'package:koropey/core/utils/custom_util.dart';
// import 'package:koropey/ui/shared/shared.dart';

// class InvestorWallet extends StatefulWidget {
//   const InvestorWallet({super.key});

//   @override
//   State<InvestorWallet> createState() => _InvestorWalletState();
// }

// class _InvestorWalletState extends State<InvestorWallet> {
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TransactionHeaderCard(),
//                 CustomSpacer(
//                   flex: 4,
//                 ),
//                 Text(
//                   "Transaction History",
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                       ),
//                 ),
//                 CustomSpacer(
//                   flex: 3,
//                 ),
//                 Container(
//                   width: size.width,
//                   height: size.height * 0.18,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                       color: AppColors.green,
//                       borderRadius: BorderRadius.circular(20)),
//                   child: Text(
//                     "No Transaction",
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 15,
//                           color: AppColors.blue,
//                         ),
//                   ),
//                 ),
//                 // TransactionCard(size: size),
//                 // TransactionCard(size: size),
//                 // TransactionCard(size: size),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TransactionCard extends StatelessWidget {
//   const TransactionCard({
//     super.key,
//     required this.size,
//   });

//   final Size size;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           title: Text(
//             "Transfer to Polarise bank",
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 14,
//                 ),
//           ),
//           subtitle: Text(
//             "🗓️ Yesterday at 16:34",
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 fontWeight: FontWeight.w400,
//                 fontSize: 12,
//                 color: AppColors.black.withOpacity(0.8)),
//           ),
//           trailing: Text(
//             "${getCurrency()}+60,000",
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16,
//                 color: AppColors.green2),
//           ),
//         ),
//         Row(
//           children: [
//             SizedBox(width: size.width * 0.2),
//             Expanded(child: Divider())
//           ],
//         )
//       ],
//     );
//   }
// }

// class TransactionHeaderCard extends StatelessWidget {
//   const TransactionHeaderCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
//       decoration: BoxDecoration(
//           color: AppColors.blue, borderRadius: BorderRadius.circular(20)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Wallet Balance",
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 14,
//                   color: AppColors.white,
//                 ),
//           ),
//           Text(
//             "****", //${getCurrency()}556,000.00
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 17,
//                   color: AppColors.white,
//                 ),
//           ),
//           const CustomSpacer(
//             flex: 5,
//           ),
//           Row(
//             children: [
//               btn(context, () {}, "RECEIVE", AppColors.green2, AppColors.green),
//               CustomSpacer(
//                 horizontal: true,
//                 flex: 4,
//               ),
//               btn(context, () {}, "WITHDRAW", AppColors.white, AppColors.blue),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Expanded btn(BuildContext context, onTap, text, textColor, bgColor) {
//     return Expanded(
//       child: InkWell(
//         onTap: onTap,
//         child: Container(
//             alignment: Alignment.center,
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//             decoration: BoxDecoration(
//                 border: Border.all(color: AppColors.white),
//                 color: bgColor,
//                 borderRadius: BorderRadius.circular(20)),
//             child: Text(
//               text,
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 10,
//                     color: textColor,
//                   ),
//             )),
//       ),
//     );
//   }
// }
