import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tikect/EventOwner/ManageTicketChecker/ShowTicketChecker.dart';
import '../../Colors/Colors.dart';
import '../Admin/AdminHome.dart';
import '../Data/Firebase.dart';
import '../EventOwner/EvenOwnerNavBar.dart';
import '../EventOwner/ManageEvent/showEvent.dart';
import '../Funcations/Funcation.dart';
import '../Icons/Icons.dart';
import '../Messag/Messages.dart';
import '../TicketChecker/TicketChecker.dart';
import '../User/UserHome.dart';
import 'SingUp.dart';
//المستخدم يقدر يتحكم فيه فول
class LogIn extends StatefulWidget {
  LogIn({Key? key}) : super(key: key);

  @override
  //الاستيت عشان المستخدم يتفاعل معاه واعرف سوا ايش الحاله حق كل ودجز
  //لما يجي ينشاها من اللوق ان استيت
  State<LogIn> createState() => _LogInState();

}
//كلاس اللوق لما تتشغل تشغل معاها كلاس الاستيت
class _LogInState extends State<LogIn> {
  //متحكمات
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  GlobalKey<FormState> logKey = GlobalKey();
  GlobalKey<FormState> restPasswordKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  //بنا الشاشه
  Widget build(BuildContext context) {
    //ترجع لي مجموعه من الودجز داخلها
    return Scaffold(
      //مكان المستخدم من بدايه الصفحه لنهايتها
        body: SizedBox(
          //اكبر عرض واكبر وارتفاع
          height: double.infinity,
          width: double.infinity,
          //شايلد حق السايز بوكس -بادنق مسافه داخليه
          child: Padding(
            //حجم الصفحه والمساحه بينهم من فوق وتحت ولا يمين ويسار
            //حجم الحواف حق الايميل والباسورد
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            //فور نموذج فيه بيانات وبرسل البيانات لمكان ثاني
            child: Form(
              //لو بتحكم بالكود
              key: logKey,
              //اتحقق من مدخلات المستخدم لما المستخدم انتر اكشن
              autovalidateMode: AutovalidateMode.onUserInteraction,
              //الشاشه تتحرك فوق وتحت عشانه كولم
              child: SingleChildScrollView(
                child: Column(
                  //الكل يكون في النص
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //المسافه من فوق لين اللوقو
                    SizedBox(height: 150.h),
                    //==============================logo image===============================================================
                    CircleAvatar(
                      //حجم الصوره السيركل
                      radius: 80.r,
                      backgroundColor: iconColor,
                      //مكان الصوره
                      backgroundImage: const AssetImage("assets/image/logo.jpg"),
                    ),

                    // icon(),
                    SizedBox(
                      //المسافه الي تحت الصوره
                      height: 15.h,
                    ),
//==============================app name===============================================================
                    text(context, appName, 35.r, black,
                        //حجم خط  النص
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
                      //الكتابه الي موجوده ترقي فوق الخطا
                      //الاوبجكت المتحكم الي عرفناه فوق
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
                      true,
                      passController,
                      manditary,
                      //النجوم حق الباسورد
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
                            //عشان اخذ منهم تفاعل المستخدم وارسلهم للفير بيز
                              email: emailController.text,
                              password: passController.text)
                              .then((String v) {
                            if (v == 'error') {
                              //مصفوفه فيه المتغيرات والمفاتيح بوب يعني ارجع
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
                                  //كل واحد اوديه صفحته
                                  print('respoms is: $v');
                                  if (element.data()['type'] == 'user') {
                                    goToReplace(context, const UserHome());
                                  } else if (element.data()['type'] =='eventOwner') {
                                    goToReplace(context, const EventNavBar());
                                  } else if (element.data()['type'] =='ticketChecker') {
                                    goToReplace(context, const TicketChecker());
                                  } else {
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

                  ],
                ),
              ),
            ),
          ),
        ));
  }
}