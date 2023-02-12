import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../Colors/Colors.dart';
import '../Funcations/Funcation.dart';
import '../Log/Logging.dart';
import '../Messag/Messages.dart';
import 'dart:convert';

class MyTicket extends StatefulWidget {
  const MyTicket({Key? key}) : super(key: key);

  @override
  State<MyTicket> createState() => _MyTicketState();
}

class _MyTicketState extends State<MyTicket> {
  CollectionReference ticketsCollection =
      FirebaseFirestore.instance.collection("myTickets");
  Map<String, dynamic> myData = {};
  String? encodedJson;
  String? userId;
  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: text(context, 'My Tickets', mainTextSize + 5, black),
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
                                      'Current avilable tickets',
                                      40,
                                      Colors.black.withOpacity(0.8),
                                      align: TextAlign.left,
                                      fontWeight: FontWeight.bold)),

//All event===================================================================================

                              Expanded(child: allTicket()),
                            ]),
                      )))));
        }));
  }

//AllTicket=================================================================
  Widget allTicket() {
    return StreamBuilder(
      stream: ticketsCollection.snapshots(),
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
              myData = {
                'eventName': data['eventName'],
                'date': data['date'],
                'numberOfTicket': data['numberOfTicket'],
                'totalPrice': data['totalPrice'],
                'userPhone': data['userPhone'],
                'userId': data['userId'],
                'ticketId': data['ticketId'],
                'valed':data['valed'],
                'docId':snapshat.data.docs[i].id,
              };
              encodedJson = jsonEncode(myData);
              return InkWell(
                  onTap: () {},

//=========================================================
                  child: SizedBox(
                    height: 280.h,
                    width: (MediaQuery.of(context).size.width) - 40.w,
                    child: Card(
                      elevation: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
//barcode================================================================
                          SizedBox(
                            height: 250.h,
                            child: Center(
                              child: QrImage(
                                data: encodedJson!,
                                version: QrVersions.auto,
                                size: 250,
                                gapless: false,
                                backgroundColor: Colors.white,
                                errorStateBuilder: (cxt, err) {
                                  return const Center(
                                    child: Text(
                                      "Uh oh! Something went wrong...",
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
//============================================================================================
                          SizedBox(
                            height: 10.h,
                          ),

                          Container(
                            margin:EdgeInsets.symmetric(horizontal: 8.w),
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: iconColor,
                            ),
                            //  padding: EdgeInsets.only(left: 10.0.w, top: 5.h),
                            child: Center(
                              child: text(context, data['eventName'],
                                  mainTextSize, white,
                                  align: TextAlign.justify,
                                  fontWeight: FontWeight.bold
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0.w,top:15.h),
                            child: text(context, 'Date: ' + data['date'],
                                mainTextSize, Colors.grey[700]!,
                                align: TextAlign.justify),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0.w),
                            child: text(
                                context,
                                'Number Of Ticket: ' +
                                    '${data['numberOfTicket']}',
                                mainTextSize,
                                Colors.grey[700]!,
                                align: TextAlign.justify),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 10.0.w),
                            child: text(
                                context,
                                'Total Price: ' + '${data['totalPrice']}',
                                mainTextSize,
                                Colors.grey[700]!,
                                align: TextAlign.justify),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 10.0.w),
                            child: text(context, 'Phone: ' + data['userPhone'],
                                mainTextSize, Colors.grey[700]!,
                                align: TextAlign.justify),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),

//============================================================================================
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
                  child: text(context, 'No ticket to show', subTextSize, black,
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
