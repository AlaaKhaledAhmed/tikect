import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:counter_button/counter_button.dart';

import '../../Colors/Colors.dart';
import '../../Funcations/Funcation.dart';
import '../../Messag/Messages.dart';
import 'VerificationCode.dart';

class Details extends StatefulWidget {
  //استقبلنا قيمها من صفحه يوز بيج
  final String name;
  final String city;
  final String location;
  final int ticketNumbrt;
  final String stDate;
  final String endData;
  final int price;
  final String detail;
  final String link;
  final String docId;
  final String fileName;
  final int soldOut;
  final String eventId;
  final String userId;
  const Details(
      {Key? key,
      required this.name,
      required this.city,
      required this.location,
      required this.userId,
      required this.eventId,
      required this.ticketNumbrt,
      required this.stDate,
      required this.endData,
      required this.price,
      required this.detail,
      required this.link,
      required this.docId,
      required this.fileName,
      required this.soldOut})
      : super(key: key);
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController userDateController = TextEditingController();
  GlobalKey<FormState> addKey = GlobalKey();

  bool isPhonevisible = false;
  int? totalPrice;
  //المتبقي من التذاكر
  int? remindTicket;
  int total = 1;
  @override
  void initState() {
    super.initState();
    //قيمه التذكره ناقص الي اشتريناها
    totalPrice = widget.price;
    remindTicket = widget.ticketNumbrt - widget.soldOut;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: iconColor),
        body: ListView(
          children: [
//image===========================================================
//
            Container(
                margin: EdgeInsets.all(10.r),
                width: double.infinity,
                height: 200.h,
                //المسافات decoration
                decoration: BoxDecoration(
                  //borderRadiusالحواف
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    //الصوره من النت ورك داتا بيز
                    image: DecorationImage(
                      image: NetworkImage(widget.link),
                      fit: BoxFit.cover,
                    ))),
//name===========================================================
           // الريسي العنوان
            ListTile(
              title: text(
                  context, 'Event title', mainTextSize + 6, Colors.grey[900]!,
                  align: TextAlign.justify, fontWeight: FontWeight.bold),
              //widget.name القيمه الي داخله الي جايني من الداتا
              subtitle: text(context, widget.name, mainTextSize, Colors.grey,
                  align: TextAlign.justify),
            ),
//price===========================================================
            ListTile(
              title: text(
                  context, 'Event price', mainTextSize + 6, Colors.grey[900]!,
                  align: TextAlign.justify, fontWeight: FontWeight.bold),
              subtitle: text(
                  context, '${widget.price}', mainTextSize, Colors.grey,
                  align: TextAlign.justify),
            ),
//Date===========================================================
            ListTile(
              title: text(
                  context, 'Event Date', mainTextSize + 6, Colors.grey[900]!,
                  align: TextAlign.justify, fontWeight: FontWeight.bold),
              subtitle: text(context, widget.stDate + " to " + widget.endData,
                  mainTextSize, Colors.grey,
                  align: TextAlign.justify),
            ),
//location===========================================================
            ListTile(
              onTap: () async {
                await launch(widget.location);
              },
              title: text(context, 'Event Location', mainTextSize + 6,
                  Colors.grey[900]!,
                  align: TextAlign.justify, fontWeight: FontWeight.bold),
              subtitle: text(context, widget.city, mainTextSize, Colors.grey,
                  align: TextAlign.justify),
            ),
//details===========================================================
            ListTile(
              title: text(context, 'Additional information', mainTextSize + 6,
                  Colors.grey[900]!,
                  align: TextAlign.justify, fontWeight: FontWeight.bold),
              subtitle: text(context, widget.detail, mainTextSize, Colors.grey,
                  align: TextAlign.justify),
            ),
//remaining tickets===========================================================
          //التذاكر والمتبقي منها
            ListTile(
              title: text(context, 'Remaining tickets', mainTextSize + 6,
                  Colors.grey[900]!,
                  align: TextAlign.justify, fontWeight: FontWeight.bold),
              subtitle: text(
                  context, '$remindTicket', mainTextSize, Colors.grey,
                  align: TextAlign.justify),
            ),
//remaining tickets===========================================================
            ListTile(
              title: Padding(
                  padding: EdgeInsets.only(bottom: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text(context, 'tickets number', mainTextSize + 6,
                          Colors.grey[900]!,
                          align: TextAlign.justify,
                          fontWeight: FontWeight.bold),
                      text(context, '$totalPrice RS', mainTextSize + 6,
                          Colors.grey[900]!,
                          align: TextAlign.justify,
                          fontWeight: FontWeight.bold),
                    ],
                  )),
              //ما يختار اقل ولا اعلي من التذاكر المتاحه
              subtitle: CounterButton(
                loading: false,
                //onchang  يرجع لي القيمه الي اخترتها  CounterButton مثود موجوده في
                //يخزنه في متغير اسمه val
                onChange: (int val) {
                  setState(() {
                    total = val;
                    //اكبر من الصفر وفي نفس اللحظه يكون اقل او يساوي الرميند =ما يختار اصغر من واحد ولا اكبر من التذاكر المتبقيه
                    if (total > 0 && total <= remindTicket!) {
                      //كل ما زودنا تذكره العدد بيزيد =التوتل الي اخترته مضروب في سعر التذكره
                      totalPrice = total * widget.price;
                    }
                  });
                },
                count: total,
                countColor: black,
                buttonColor: green,
                progressColor: green,
                addIcon: const Icon(Icons.add_circle_outline),
                removeIcon: const Icon(Icons.remove_circle_outline),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
//============================== phone textField===============================================================
           //٩٩٩٩٩٩٩
            //الي يتحكم في خانه الجوال يختفي ولا يضهر
            Visibility(
              visible: isPhonevisible,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Form(
                    key: addKey,
                    child: Column(
                      children: [
                        textField(context, Icons.phone, "Enter Phone", false,
                            phoneController, validPhone),
                        SizedBox(
                          height: 10.h,
                        ),
                        textField(context, Icons.calendar_month, "Select Date",
                            false, userDateController, manditary,
                            onTap: onTapDate),
                      ],
                    )),
              ),
            ),
            Visibility(
              visible: isPhonevisible,
              child: SizedBox(
                height: 10.h,
              ),
            ),
//buy===========================================================

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
              ),
              child: bottom(context, 'BUY', white, () async {
                if (total <= 0) {
                  lode(context, 'BUY', 'You must select at least 1');
                } else if (total > remindTicket!) {
                  lode(context, 'BUY', 'The quantity is not enough');
                } else {
                  //لو كل شي صح =الكود
                  setState(() {
                    isPhonevisible = true;
                  });

                  FocusManager.instance.primaryFocus?.unfocus();
                  if (addKey.currentState?.validate() == true) {
                    print(phoneController.text);
                    lode(context, 'lode', 'lode');
                    //الفير بيز فيها خاصيه اسمها الفون فالديت
                    // الكود تلقايي يرسله قوقل
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      //المثود فيها اكثر من ارتربيوت verifyPhoneNumber اول شي رقم الجوال
                      //phoneController.text امررها رقم الجوال الي دخلنها في خانه
                      phoneNumber: phoneController.text,
                      //اذا اكتمل
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {
                        await FirebaseAuth.instance
                            .signInWithCredential(credential)
                            .then((value) async {
                          Navigator.pop(context);
                          if (value.user != null) {
                            //صحيح
                            print("Done !!" "verificationCompleted");
                          } else {
                            Navigator.pop(context);
                            lode(context, 'Error', 'Failed ');
                          }
                        }).catchError((e) {
                          Navigator.pop(context);
                          lode(context, 'Error',
                              'Something Went Wrong: ${e.toString()}');
                        });
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        Navigator.pop(context);
                        if (e.code == 'invalid-phone-number') {
                          lode(context, 'verification', 'invalid phone number');
                        }
                      },
                      //اول ما ينرسل الكود
                      codeSent:

                          (String verificationId, int? resendToken) async {
                        Navigator.pop(context);
                        goTo( context,
                            VerificationCode( verificationId: verificationId,
                              docId: widget.docId,
                              eventId: widget.eventId,
                              eventSoldOut: widget.soldOut,
                              eventTotalTicket: widget.ticketNumbrt,
                              selectEventDate: userDateController.text,
                              totalUserPrice: totalPrice!,
                              userId: widget.userId,
                              userNumberTicket: total,
                              userPhone: phoneController.text,
                              eventName:widget.name,
                            ));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  }
                }
              }, backgroundColor: iconColor),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ));
  }

  //show date picker----------------------------------------
  //٠٩٩٩٩٩٩٩٩٩٩٩٩
  void onTapDate() async {
    FocusScope.of(context).unfocus();
    DateTime? datePicker = await showDatePicker(
        context: context,
        initialDate: DateFormat("dd-MM-yyyy").parse((widget.stDate)),
        firstDate: DateFormat("dd-MM-yyyy").parse((widget.stDate)),
        lastDate: DateFormat("dd-MM-yyyy").parse((widget.endData)));
    setState(() {
      if (datePicker != null) {
        print(datePicker);
        userDateController.text =
            '${datePicker.day}-${datePicker.month}-${datePicker.year}';
        '${datePicker.weekday}';
      }
    });
  }
}
