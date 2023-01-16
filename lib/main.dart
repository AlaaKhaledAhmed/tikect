
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Colors/Colors.dart';
import 'Log/Logging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(413, 763),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(

            debugShowCheckedModeBanner: false,
            title: 'My Event',
            theme: ThemeData(
              fontFamily: 'Almarai-Regular',
              scaffoldBackgroundColor: Colors.white,
              primaryColor: iconColor,
            ),
            builder: (context, widget) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              );
            },
            home:LogIn()

        );
      },
    );
  }
}

