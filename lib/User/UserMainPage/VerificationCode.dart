import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:tikect/Messag/Messages.dart';
import 'package:tikect/User/UserHome.dart';

import '../../Colors/Colors.dart';
import '../../Data/Firebase.dart';
import '../../Funcations/Funcation.dart';

class VerificationCode extends StatefulWidget {
  final String verificationId;
  final String userId;
  final int eventTotalTicket;
  final int eventSoldOut;
  final int totalUserPrice;
  final int userNumberTicket;
  final String eventId;
  final String docId;
  final String userPhone;
  final String selectEventDate;
final String eventName;
  const VerificationCode(
      {Key? key,
      required this.verificationId,
      required this.eventName,
      required this.userId,
      required this.eventTotalTicket,
      required this.eventSoldOut,
      required this.eventId,
      required this.docId,
      required this.userPhone,
      required this.totalUserPrice,
      required this.selectEventDate,
      required this.userNumberTicket})
      : super(key: key);
//٩٩٩٩٩٩٩٩٩٩٩
  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}
//٩٩٩٩٩٩٩٩٩٩٩
//في صفحه الديتيلز
class _VerificationCodeState extends State<VerificationCode> {
  //تبع حقول الارقام
  TextEditingController smsCode = TextEditingController();
  PinTheme? defaultPinTheme, focusedPinTheme, submittedPinTheme, errorPinTheme;
  GlobalKey<FormState> codeKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    //==========================================================================
    defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
//==========================================================================
    errorPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: red!),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
//==========================================================================
    focusedPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
          border: Border.all(color: iconColor),
          borderRadius: BorderRadius.circular(8)),
    );
//==========================================================================
    submittedPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20.sp,
          color: const Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w300),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
//=============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: LayoutBuilder(builder: (context, constraints) {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text(
                          context, 'Verification Code', mainTextSize + 5, black,
                          fontWeight: FontWeight.bold),
                      SizedBox(
                        height: 10.h,
                      ),
                      text(context, 'Enter code', mainTextSize, Colors.grey),
                      SizedBox(
                        height: 20.h,
                      ),

//code========================================================================
                      Form(
                        key: codeKey,
                        //مربعات الادخال
                        child: Pinput(
                          animationCurve: Curves.easeInQuint,
                          controller: smsCode,
                          //يجيبلي الرساله تلقايي
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsRetrieverApi,
                          //التصميم
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          errorPinTheme: errorPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          pinAnimationType: PinAnimationType.scale,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.phone,
                          errorTextStyle: TextStyle(
                            fontSize: 14.sp,
                            color: red!,
                          ),
                          validator: (s) {
                            if (s == '') {
                              return "Empty Data";
                            }
                            if (s!.length != 6) {
                              return 'must be 6 digits';
                            } else {
                              return null;
                            }
                          },
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          autofocus: false,
                          length: 6,
                        ),
                      ),
                      SizedBox(height: 20.h),
//check===============================================================
                      bottom(context, 'check', white, () async {
                        lode(context, 'lode', 'lode');
                        try {
                          PhoneAuthCredential credential =
                          //تتحق لي من صحه الجوال بكج من قوقل
                              PhoneAuthProvider.credential(
                                //ننكتب الرمز الي وصلي
                                  verificationId: widget.verificationId,
                                  //الكود الي انا ادخلو اسمه اس ام اس كود
                                  smsCode: smsCode.text);
                          await FirebaseAuth.instance
                              .signInWithCredential(credential);
//ganrate bar code==============================================================================
                         //اذا الكود الي دخلتو صح يحدث التذاكر
                          if (FirebaseAuth.instance.currentUser != null) {
                            //يحدث التذاكر
                            Firbase.updateTickets(
                                    docId: widget.docId,
                                    totalTicket: widget.eventTotalTicket -
                                        widget.userNumberTicket,
                                    solidTickets: widget.eventSoldOut +
                                        widget.userNumberTicket)
                                .then((value) {
                              if (value == "done") {
                                //اضيف بيانات الجدول في الفير بيس
                                Firbase.myTickets(
                                        userId: widget.userId,
                                        numberOfTicket: widget.userNumberTicket,
                                        ticketId: widget.eventId,
                                        userPhone: widget.userPhone,
                                        totalPrice: widget.totalUserPrice,
                                        stDate: widget.selectEventDate,
                                        eventName:widget.eventName
                                        )
                                    .then((v) {
                                  if (v == "done") {
                                    Navigator.pop(context);
                                    lode(context, addData,
                                        //يرجعني الصفحه الريسيه
                                        doneData + " go to home page?",
                                        showButtom: true, noFunction: () {
                                      goToReplace(context, UserHome());
                                    }, yesFunction: () {
                                      goToReplace(context, UserHome());
                                    });
                                  } else {
                                    Navigator.pop(context);
                                    lode(context, addData, errorDat);
                                  }
                                });
                              } else {
                                Navigator.pop(context);
                                lode(context, addData, errorDat);
                              }
                            });
//End ganrate bar code==============================================================================
                          } else {
                            //اذا دخلت غلط
                            Navigator.pop(context);
                            lode(context, 'Verification phone',
                                'the code is incorrect');
                          }
                        } on FirebaseException catch (e) {
                          Navigator.pop(context);
                          if (e.code == 'session-expired') {
                            lode(context, 'Verification phone',
                                'code expired reSend code');
                          }
                          if (e.code == 'invalid-verification-code') {
                            lode(context, 'Verification phone',
                                'invalid verification code');
                          }
                          // print('==========================');
                          // print(e.code);
                          // print('==========================');
                        } catch (e) {
                          Navigator.pop(context);
                          return e.toString();
                        }
                      }, backgroundColor: iconColor),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
