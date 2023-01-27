import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tikect/Data/Firebase.dart';

import '../Colors/Colors.dart';
import '../Funcations/Funcation.dart';
import '../Icons/Icons.dart';
import '../Messag/Messages.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? type;
  GlobalKey<FormState> addKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Add New Event Owner'),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 120,
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
//============================== Email textField===============================================================
                                textField(
                                  context,
                                  emailIcon,
                                  "Email",
                                  false,
                                  emailController,
                                  emile,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
//============================== password textField===============================================================
                           textField(
                                  context,
                                  passIcon,
                                  "Password",
                                  true,
                                  passwordController,
                                  password,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
//============================== phone textField===============================================================
                                textField(
                                  context,
                                  Icons.phone,
                                  "Phone",
                                  false,
                                  phoneController,
                                  validPhone,
                                ),
                                SizedBox(height: 10.h),
                                const Spacer(
                                  flex: 1,
                                ),
//Add bottom==================================================================
                              bottom(context, 'Add User', white, () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (addKey.currentState?.validate() == true) {
                                    lode(context, '', 'lode');
                                    Firbase.singUpAccountEventOwner(
                                      type: 'eventOwner',
                                            name: nameController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                             phone:phoneController.text)
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
