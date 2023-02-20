import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Colors/Colors.dart';
import '../Data/Firebase.dart';
import '../Funcations/Funcation.dart';
import '../Log/Logging.dart';
import '../Messag/Messages.dart';
import 'ManageEvent/AddEvent.dart';
//٠٠٠٩٩٩٩٩٩ ما شرحتو
class SoldOut extends StatefulWidget {
  const SoldOut({Key? key}) : super(key: key);

  @override
  State<SoldOut> createState() => _SoldOutState();
}

class _SoldOutState extends State<SoldOut> {
  CollectionReference ticketsCollection =
      FirebaseFirestore.instance.collection("tickets");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 241, 241, 237),
      appBar: AppBar(
        title: text(context, "Fully sold tickets", mainTextSize, white),
        centerTitle: true,
        backgroundColor: iconColor,
         actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                goToReplace(context, LogIn());
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: ticketsCollection
                //الرقمين بيساو بعض
                //نفس الادمن يضيف الاونر
                   .where('soldOut', isEqualTo: 'totalTicket')
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshat) {
                  if (snapshat.hasError) {
                    return const Center(child: Text("Error check internet!"));
                  }
                  if (snapshat.hasData) {
                    return mainBody(context, snapshat);
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
              SizedBox(height: 10.h)
            ],
          ),
        ),
      ),
    );
  }

//==============================================================
  Widget mainBody(BuildContext context, AsyncSnapshot snapshat) {
    return snapshat.data.docs.length > 0
        ? Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //عدد العناصر في كل صف
                    crossAxisSpacing: 0, // المسافات الراسية
                    childAspectRatio: 0.75, //حجم العناصر
                    mainAxisSpacing: 0 //المسافات الافقية

                    ),
                itemCount: snapshat.data.docs.length,
                itemBuilder: (context, i) {
                  var data = snapshat.data.docs[i].data();
                  return InkWell(
                      
                      // onTap: () {
                      //   goTo(
                      //       context,
                      //       UpdateEvent(
                      //         name: data['name'],
                      //         city: data['city'],
                      //         docId: snapshat.data.docs[i].id,
                      //         detail: data['details'],
                      //         endData: data['endDate'],
                      //         fileName: data['fileName'],
                      //         link: data['link'],
                      //         location: data['location'],
                      //         price: data['price'],
                      //         stDate: data['startDate'],
                      //         ticketNumbrt: data['totalTicket'],
                      //       ));
                      // },

//=========================================================
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
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
                                padding: EdgeInsets.only(left: 10.0.w,top:5.h),
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
                                child: text(context, data['city'],
                                    mainTextSize, Colors.grey[500]!,
                                    align: TextAlign.justify),
                              ),
//============================================================================================
                              const Spacer(),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: iconColor,
                                    //Colors.grey[700]!,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.r))),
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
                }),
          )

//================================================================
        : Center(
            child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2),
                child: text(context, 'Empty List', subTextSize, black,
                    fontWeight: FontWeight.bold)),
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

//delete====================================================================
  
}
