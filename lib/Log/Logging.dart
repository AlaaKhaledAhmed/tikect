import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Colors/Colors.dart';
import '../Admin/AdminHome.dart';
import '../Data/Firebase.dart';
import '../EventOwner/showEvent.dart';
import '../Funcations/Funcation.dart';
import '../Icons/Icons.dart';
import '../Messag/Messages.dart';
import '../User/UserHome.dart';
import 'SingUp.dart';

class LogIn extends StatefulWidget {
  LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  GlobalKey<FormState> logKey = GlobalKey();
  GlobalKey<FormState> restPasswordKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Form(
          key: logKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height:150.h),
 //==============================logo image===============================================================
                CircleAvatar(
                  radius: 80.r,
                  backgroundColor: iconColor,
                  backgroundImage:AssetImage(logoImage) ,
                ),
                // icon(),
                SizedBox(
                  height: 15.h,
                ),
//==============================app name===============================================================
                text(context, appName, 35.r, black,
                    fontWeight: FontWeight.bold),
                SizedBox(
                  height: 40.h,
                ),
 //==============================email textField===============================================================
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
//============================== pass textField===============================================================
                textField(
                  context,
                  passIcon,
                  "Password",
                  false,
                  passController,
                  manditary,
                  //fillColor: textFieldColors3,
                ),
                SizedBox(
                  height: 10.h,
                ),
//================================login bottom ===============================================================
               bottom(
                  context,
                  "Login",
                  Colors.white,
                  () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (logKey.currentState?.validate() == true) {
                      lode(context, '', 'lode');
                      Firbase.loggingToApp(
                              email: emailController.text,
                              password: passController.text)
                          .then((String v) {
                        if (v == 'error') {
                          Navigator.pop(context);
                          lode(context, login, errorDat);
                        } else if (v == 'user-not-found') {
                          Navigator.pop(context);
                          lode(context, login, userNotFound);
                        } else if (v == 'wrong-password') {
                          Navigator.pop(context);
                           lode(context, login, userNotFound);
                        } else {
                          print('respoms is: $v');
                          FirebaseFirestore.instance
                              .collection('users')
                              .where('userId', isEqualTo: v)
                              .get()
                              .then((value) {

                            Navigator.pop(context);
                            value.docs.forEach((element) {
                                print('respoms is: $v');
                              if (element.data()['type'] == 'user') {
                                goToReplace(context, const AdminHome());
                              } else if (element.data()['type'] == 'eventOwner') {
                               goToReplace(context,const ShowEvent());
                              } else{
                                goToReplace(context, const AdminHome());
                              }
                            });
                          });
                        }
                      });
                    }
                  },
                  backgroundColor: iconColor,
                ),
                SizedBox(
                  height: 20.h,
                ),
//==============================create account===============================================================
                InkWell(
                    child: text(context, "Create Account", 14, black),
                    onTap: () {
                     goTo(context, SingUp());
                    }),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                    child: text(context, "Reset Password", 14, black),
                    onTap: () {

                    }),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
