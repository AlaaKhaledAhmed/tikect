import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tikect/User/UserMainPage/Details.dart';
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
  CollectionReference ticketsCollection =
      FirebaseFirestore.instance.collection("tickets");
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30.h,
                              ),
                              SizedBox(
                                  height: 100.h,
                                  child: text(
                                      context,
                                      'Find the trending events',
                                      40,
                                      Colors.black.withOpacity(0.8),
                                      align: TextAlign.left,
                                      fontWeight: FontWeight.bold)),
//search bar===================================================================================
                              SizedBox(height: 70.h, child: searchBar()),
                              SizedBox(
                                height: 25.h,
                              ),
//All event===================================================================================
                              text(
                                context,
                                'Current Events',
                                20,
                                Colors.black.withOpacity(0.8),
                                align: TextAlign.start,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Expanded(child: allEvent()),
                            ]),
                      )))));
        }));
  }

//===============================================================================
  Widget searchBar() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          text(context, 'search', mainTextSize, Colors.grey,
              align: TextAlign.left, fontWeight: FontWeight.bold),
          const Icon(
            Icons.search,
            color: Colors.grey,
          )
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(20.r))),
    );
  }

//AllEvent=================================================================
  Widget allEvent() {
    return StreamBuilder(
      stream: ticketsCollection
          .snapshots(),
      builder: (context, AsyncSnapshot snapshat) {
        if (snapshat.hasError) {
          return const Center(child: Text("Error check internet!"));
        }
        if (snapshat.hasData) {
          return snapshat.data.docs.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: SizedBox(
                            height: 330.h,
                            width: double.infinity,
                            child: mainBody(context, snapshat))),
                  ],
                )
              : const SizedBox();
        }

        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  //==============================================================
  Widget mainBody(BuildContext context, AsyncSnapshot snapshat) {
    return snapshat.data.docs.length > 0
        ? ListView.builder(
          scrollDirection: Axis.horizontal,
            itemCount: snapshat.data.docs.length,
            itemBuilder: (context, i) {
              var data = snapshat.data.docs[i].data();
              return InkWell(
                  onTap: () {
                    goTo(context, Details(
                       name: data['name'],
                              city: data['city'],
                              docId: snapshat.data.docs[i].id,
                              detail: data['details'],
                              endData: data['endDate'],
                              fileName: data['fileName'],
                              link: data['link'],
                              location: data['location'],
                              price: data['price'],
                              stDate: data['startDate'],
                              ticketNumbrt: data['totalTicket'],
                             soldOut :data['soldOut'],
                            
                    ));
                  },

//=========================================================
                  child: SizedBox(
                    height: 280.h,
                    width: 220.w,
                    child: Card(
                      elevation: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 120.h,
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                  color: white,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5.0.r), //<-- SEE HERE
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0.r)),
                                    child: Image.network(
                                      data['link'],
                                      fit: BoxFit.cover,
                                    ),
                                  ))),
//============================================================================================

                          Padding(
                            padding: EdgeInsets.only(left: 10.0.w, top: 5.h),
                            child: text(context, data['startDate'],
                                mainTextSize, Colors.grey[900]!,
                                align: TextAlign.justify),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0.w),
                            child: text(context, data['name'], mainTextSize,
                                Colors.grey[700]!,
                                align: TextAlign.justify),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0.w),
                            child: text(context, data['city'], mainTextSize,
                                Colors.grey[500]!,
                                align: TextAlign.justify),
                          ),
//============================================================================================
                          const Spacer(),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: iconColor,
                                //Colors.grey[700]!,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r))),
                            margin: EdgeInsets.all(10.r),
                            padding: EdgeInsets.all(11.r),
                            child: text(
                                context,
                                'Sold out ${data['soldOut']} of ${data['totalTicket']}',
                                subTextSize + 2,
                                white,
                                align: TextAlign.justify),
                          ),
                        ],
                      ),
                    ),
                  ));
            })

//================================================================
        : Center(
            child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2),
                child: Center(
                  child: text(context, 'No Events to show', subTextSize, black,
                      fontWeight: FontWeight.bold),
                )),
          );
  }

//get section===============================================================================
  getDataName(BuildContext context, IconData icon, String titel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 20.h),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor),
          SizedBox(width: 5.w),
          Expanded(
            child: text(context, titel, subTextSize, black,
                fontWeight: FontWeight.bold, align: TextAlign.start),
          ),
        ],
      ),
    );
  }
}
