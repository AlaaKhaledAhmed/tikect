import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Colors/Colors.dart';
import '../../Funcations/Funcation.dart';
import '../../Log/Logging.dart';
import '../../Messag/Messages.dart';

class UserMainPage extends StatefulWidget {
  const UserMainPage({Key? key}) : super(key: key);

  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: text(context, 'Home Page', mainTextSize + 5, black),
          backgroundColor: white,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  goToReplace(context, LogIn());
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: black,
                ))
          ],
        ),
        backgroundColor: white,
        body: LayoutBuilder(builder: (context, constraints) {
          return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification? overscroll) {
                overscroll!.disallowGlow();
                return true;
              },
              child: SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                          minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Column(children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          SizedBox(
                              height: 100.h,
                              child: text(context, 'Find the trending events',
                                  40, Colors.black.withOpacity(0.8),
                                  align: TextAlign.left,
                                  fontWeight: FontWeight.bold)),
//search bar===================================================================================
                          SizedBox(height: 70.h, child: searchBar()),
                          SizedBox(
                            height: 10.h,
                          ),
//pupuler event===================================================================================
                          SizedBox(
                            height: 120.h,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
//All event===================================================================================
                          SizedBox(
                            height: 110.h,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ]),
                      )))));
        }));
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.only(left: 20.w,right:20.w),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          text(context, 'search', mainTextSize, Colors.grey,
              align: TextAlign.left, fontWeight: FontWeight.bold),
          const Icon(Icons.search,color: Colors.grey,)
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(20.r))),
    );
  }
}
