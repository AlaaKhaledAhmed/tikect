
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tikect/Log/Logging.dart';
import 'package:tikect/TicketChecker/TicketChecker.dart';
import 'Colors/Colors.dart';
//عشان اشتغل اجيب اول شي بكج الفلتر
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'EventOwner/EvenOwnerNavBar.dart';
import 'User/UserHome.dart';
//هذا المين البدايه
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//كلاس يرث ويشغل لي البرنامج
  runApp(const MyApp());
}
//ستيس ليس المستخدم يشوفها و ما يتفاعل معاها
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  // تبني الشاشه
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      //مقاسات شاشه التسجيل من فوق من عند الاسم
      designSize: const Size(413, 763),
      builder: (BuildContext context, Widget? child) {
        //الي سويناله استدعا الودج الاساسي  احدد فيه التايتل
        return MaterialApp(
//توخر العلامه التجريبيه
            debugShowCheckedModeBanner: false,
            title: 'My Event',
            //الشكل الي اخترناه
            theme: ThemeData(
              //الخط
              fontFamily: 'Almarai-Regular',
              //لون الخلفيه
              scaffoldBackgroundColor: Colors.white,
              //اللون الاساسي
              primaryColor: iconColor,
            ),
            builder: (context, widget) {
              return MediaQuery(
                //مقياس الرسم حق الخط
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                //علامه التعجب لو كان خطا ويوقف البرنامج
                child: widget!,
              );
            },
            //الشاشه الي هيفتح لنا
            home: LogIn()

        );
      },
    );
  }
}

