import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Colors/Colors.dart';
import '../../Data/Firebase.dart';
import '../Funcations/Funcation.dart';
import '../Icons/Icons.dart';
import '../Messag/Messages.dart';


class SingUp extends StatefulWidget {
  SingUp({Key? key}) : super(key: key);
  @override
  State<SingUp> createState() => _AddUserState();
}

class _AddUserState extends State<SingUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController idController = TextEditingController();
  GlobalKey<FormState> addKey = GlobalKey();
  String? type;
  String passowrd = '';

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: iconColor,
            title: text(
              context,
              "CREATE NEW USER ACCOUNT",
              mainTextSize,
              black,
            )),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 30.h),
            child: SingleChildScrollView(
              child: Form(
                key: addKey,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60.r,
                      backgroundColor: textColor2,
                      child: Icon(
                        add,
                        size: 50.r,
                        color: white,
                      ),
                    ),
                    // icon(),
                    SizedBox(
                      height: 20.h,
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
                      false,
                      passwordController,
                      password,

                    ),
                    SizedBox(
                      height: 10.h,
                    ),
//==============================id Number textField===============================================================
                    textField(context, id, "ID", false,
                        idController, manditary,
                        keyboardType: TextInputType.number),
                    SizedBox(
                      height: 10.h,
                    ),
//==============================add ===============================================================

                    bottom(
                      context,
                      "Create Account",
                      textColor,
                      () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (addKey.currentState?.validate() == true) {
                          lode(context, '', 'lode');

                          Firbase.singUpAccount(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  idNumber: idController.text,
                                  type: "user")
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
//===================================================================
  void clear() {}
}
