// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tikect/Data/Firebase.dart';

import '../Colors/Colors.dart';
import '../Funcations/Funcation.dart';
import '../Icons/Icons.dart';
import '../Messag/Messages.dart';


class UpdateUser extends StatefulWidget {
  String name;
  String phone;

  String docId;
  UpdateUser(
      {Key? key,
      required this.name,
      required this.phone,

      required this.docId})
      : super(key: key);
  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? type;
  GlobalKey<FormState> addKey = GlobalKey();

  @override
  //عبيها من القيم الي في الداتا بيز
  void initState() {
    super.initState();
    nameController.text = widget.name;
    phoneController.text = widget.phone;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Update User Information'),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 200,
          child: Card(
            child: Form(
                key: addKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) =>
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification:
                          (OverscrollIndicatorNotification? overscroll) {
                        overscroll!.disallowGlow();
                        return true;
                      },
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                              minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),

//==============================name textField===============================================================
                               textField(
                                  context,
                                  nameIcon,
                                  "Name",
                                  false,
                                  nameController,
                                  manditary,
                                  //fillColor: textFieldColors3,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
//============================== phone textField===============================================================
                                textField(
                                  context,
                                  passIcon,
                                  "Phone",
                                  false,
                                  phoneController,
                                  password,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                const Spacer(
                                  flex: 1,
                                ),
//update bottom==================================================================
                         //الابديت
                               bottom(context, 'Update User', white, () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (addKey.currentState?.validate() == true) {
                                    lode(context, '', 'lode');
                                    Firbase.updateEventOwner(
                                            name: nameController.text,
                                            docId: widget.docId,
                                            phone: phoneController.text)
                                        .then((String v) {
                                      print('================$v');
                                      if (v == 'done') {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        lode(context, addData, doneData);
                                      } else if (v == 'weak-password') {
                                        Navigator.pop(context);
                                        lode(context, addData, weekPassword);
                                      } else if (v == 'email-already-in-use') {
                                        Navigator.pop(context);
                                        lode(context, addData, emailFound);
                                      } else {
                                        Navigator.pop(context);
                                        lode(context, addData, errorDat);
                                      }
                                    });
                                  }
                                },
                                    backgroundColor: iconColor,
                                    width: MediaQuery.of(context).size.width,
                                    height: 60.h),

                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            elevation: 10,
          )),
    );
  }
}
