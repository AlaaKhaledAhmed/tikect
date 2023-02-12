import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:tikect/TicketChecker/TicketChecker.dart';

import '../Colors/Colors.dart';
import '../Data/Firebase.dart';
import '../Funcations/Funcation.dart';
import '../Messag/Messages.dart';

class VerificationTicket extends StatefulWidget {
  final String verificationId;
  final String docId;
  const VerificationTicket({required this.docId, required this.verificationId});

  @override
  State<VerificationTicket> createState() => _VerificationTicketState();
}

class _VerificationTicketState extends State<VerificationTicket> {
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
                        child: Pinput(
                          animationCurve: Curves.easeInQuint,
                          controller: smsCode,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsRetrieverApi,
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
                              PhoneAuthProvider.credential(
                                  verificationId: widget.verificationId,
                                  smsCode: smsCode.text);
                          await FirebaseAuth.instance
                              .signInWithCredential(credential);
//ganrate bar code==============================================================================
                          if (FirebaseAuth.instance.currentUser != null) {
                            Firbase.updateMyTickets(
                                    docId: widget.docId, valed: 1)
                                .then((value) {
                              if (value == "done") {
                                Navigator.pop(context);
                                lode(context, 'Verification user', doneData);
                                goToReplace(context, const TicketChecker());
                              } else {
                                Navigator.pop(context);
                                lode(context, 'Verification user', errorDat);
                               
                              }
                            });
//End ganrate bar code==============================================================================
                          } else {
                            Navigator.pop(context);
                            lode(context, 'Verification user',
                                'the code is incorrect');
                          }
                        } on FirebaseException catch (e) {
                          Navigator.pop(context);
                          if (e.code == 'session-expired') {
                            lode(context, 'Verification user',
                                'code expired reSend code');
                          }
                          if (e.code == 'invalid-verification-code') {
                            lode(context, 'Verification user',
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
