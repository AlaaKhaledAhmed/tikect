import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';
import '../Colors/Colors.dart';
import '../Funcations/Funcation.dart';
import '../Messag/Messages.dart';
import 'VerificationTicket.dart';
// واجهه المستخدم+نفس واجهه الايفنت اونر
class ScanneQR extends StatefulWidget {
  ScanneQR({Key? key}) : super(key: key);

  @override
  State<ScanneQR> createState() => _ScanneQRState();
}

class _ScanneQRState extends State<ScanneQR> {
  //الماب الي حولناها لسترنق كان عندي ماب حولته لسترنق والحين العكس
  Map<String, dynamic> myData = {};
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barCode;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Future<void> reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
//Flash and camera==================================================================
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
//get Flash Status==========================================================================
                    IconButton(
                      onPressed: () {
                        controller?.toggleFlash();
                        setState(() {});
                      },
                      icon: FutureBuilder<bool?>(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return Icon(
                                snapshot.data!
                                    ? Icons.flash_on
                                    : Icons.flash_off,
                                size: 40,
                                color: Colors.blue,
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
//flip Camera==========================================================================
                    IconButton(
                      onPressed: () {
                        controller?.flipCamera();
                        setState(() {});
                      },
                      icon: FutureBuilder(
                          future: controller?.getCameraInfo(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return const Icon(
                                Icons.switch_camera,
                                size: 40,
                                color: Colors.blue,
                              );
                            } else {
                              return Container();
                            }
                          }),
                    )
                  ],
                ),
              ),

//QR SCANE==================================================================
              Expanded(
                flex: 5,
                child: QRView(
                  //البكج الي تحط حواف علي حدود الكميرا
                  key: qrKey,

                  onQRViewCreated: (QRViewController controller) {
                    setState(() {
                      this.controller = controller;
                    });
                    controller.scannedDataStream.listen((barCode) {
                      setState(() {
                        this.barCode = barCode;
                      });
                      //يجيب البيانات الي عرفناها في ماي داتا يفك التشفير
                      myData = jsonDecode(barCode.code);
                    });
                  },
                  //علامه الحواف
                  overlay: QrScannerOverlayShape(
                    cutOutSize: MediaQuery.of(context).size.width * 0.8,
                    borderWidth: 10,
                    borderLength: 20,
                    borderRadius: 10,
                    borderColor: Theme.of(context).accentColor,
                  ),
                ),
              ),
//QR RESULT==================================================================
              Expanded(
                  flex: 1,
                  child: Center(
                      child: text(
                          context,
                          barCode != null
                          //يعني اف الس
                              ? 'Event name: ${myData['eventName']}'
                              : 'Scane QR from myTicket page',
                          mainTextSize,
                          black,
                          align: TextAlign.justify,
                          fontWeight: FontWeight.bold))),
//=====================================================================================
              InkWell(
                onTap: () {
                  //تبع التذكره اذا كان صفر يعني الكود شعغال
                  myData['valed'] == 0
                  //نفس الكود حق رمز التحقق
                      ? lode(context, 'Event info',
                          'Event name: ${myData['eventName']}\nEvent Date: ${myData['date']}\nNumber of ticket: ${myData['numberOfTicket']}\ntotal Price: ${myData['totalPrice']}\nPhone: ${myData['userPhone']}\nsend code?',
                          showButtom: true, noFunction: () {
                          Navigator.pop(context);
                        }, yesFunction: () async {
                          lode(context, 'lode', 'lode');
                          //تاخذ الرقم وترسل الرقم
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            //يرسل التحقق علي رقم الجوال
                            phoneNumber: myData['userPhone'],
                            verificationCompleted:
                                (PhoneAuthCredential credential) async {
                              await FirebaseAuth.instance
                                  .signInWithCredential(credential)
                                  .then((value) async {
                                Navigator.pop(context);
                                if (value.user != null) {
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
                            //بعد ما يرسلي الرقم صفحه التحقق
                            verificationFailed: (FirebaseAuthException e) {
                              Navigator.pop(context);
                              if (e.code == 'invalid-phone-number') {
                                lode(context, 'verification',
                                    'invalid phone number');
                              }
                            },
                            //ينقلني لصفحه التحقق+الرمز
                            codeSent: (String verificationId,
                                int? resendToken) async {
                              Navigator.pop(context);
                              goTo(
                                  context,
                                  //ينقلني للصفحه حق رقم الجوال والتحقق
                                  VerificationTicket(
                                    verificationId: verificationId,
                                    docId: myData['docId'],
                                  ));
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        }, higth: 250.h)
                      : Center(
                    //اذا واحد يرجع انو انفليد
                          child: text(
                              context, 'Invalid ticket', mainTextSize, red!,
                              align: TextAlign.justify,
                              fontWeight: FontWeight.bold),
                        );
                },
                child: Center(
                    child: text(context, getText(), mainTextSize, iconColor,
                        align: TextAlign.justify, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 10.h,
              ),
//================================================================

              SizedBox(
                height: 10.h,
              )
            ],
          )),
    );
  }
//=============================================
  String getText() {
    if (barCode != null) {
      if (myData['valed'] == 0) {
        return 'Show details';
      } else {
        return 'Invalid ticket';
      }
    } else {
      return '';
    }
  }
}
