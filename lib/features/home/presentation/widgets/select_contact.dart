import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/contact_model.dart';
import '../../../home/application/home_bloc.dart';


// Select Contacts
class SelectFromContactList extends StatelessWidget {
  const SelectFromContactList({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.width * 0.15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                            text: AppLocalizations.of(context)!.selectReceiver,
                            textStyle: Theme.of(context).textTheme.bodyLarge),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: MyText(
                              text: AppLocalizations.of(context)!.cancel,
                              textStyle: Theme.of(context).textTheme.bodyLarge),
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * 0.03),
                    SizedBox(
                      height: size.height * 0.73,
                      child: RawScrollbar(
                        child: ListView.builder(
                          itemCount:
                              context.read<HomeBloc>().contactsList.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 16),
                          itemBuilder: (context, index) {
                            final contact = context
                                .read<HomeBloc>()
                                .contactsList
                                .elementAt(index);
                            return Theme(
                              data: ThemeData(
                                unselectedWidgetColor:
                                    Theme.of(context).primaryColorDark,
                              ),
                              child: RadioListTile(
                                value: contact,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                activeColor: Theme.of(context).primaryColorDark,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                groupValue:
                                    context.read<HomeBloc>().selectedContact,
                                onChanged: (value) {
                                  context.read<HomeBloc>().selectedContact =
                                      contact;
                                  context.read<HomeBloc>().add(UpdateEvent());
                                },
                                title: MyText(
                                  text: contact.name,
                                  maxLines: 2,
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                                subtitle:
                                    MyText(
                                    text: contact.number,
                                    maxLines: 1,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyMedium),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: size.width * 0.03),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 0),
                    spreadRadius: 2,
                    blurRadius: 2,
                    color: Theme.of(context).shadowColor,
                  )
                ]),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.width * 0.03),
                  CustomButton(
                    width: size.width,
                    buttonColor: Theme.of(context).primaryColor,
                    buttonName: AppLocalizations.of(context)!.confirm,
                    onTap: () {
                      if (context
                          .read<HomeBloc>()
                          .selectedContact
                          .number
                          .isNotEmpty) {
                        context.read<HomeBloc>().receiverNameController.text =
                            context.read<HomeBloc>().selectedContact.name;
                        context.read<HomeBloc>().receiverMobileController.text =
                            context.read<HomeBloc>().selectedContact.number;
                        context.read<HomeBloc>().selectedContact =
                            ContactsModel(name: '', number: '');
                        Navigator.pop(context);
                      } else {
                        showToast(message: AppLocalizations.of(context)!.pleaseSelectReceiver);
                      }
                    },
                  ),
                  SizedBox(height: size.width * 0.1),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
