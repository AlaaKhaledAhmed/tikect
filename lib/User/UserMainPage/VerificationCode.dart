import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Colors/Colors.dart';
import '../../Funcations/Funcation.dart';

class VerificationCode extends StatefulWidget {
  final String verificationId;

  const VerificationCode({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  TextEditingController smsCode = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: bottom(context, 'check', textColor, () async {
            // in otp page Create a PhoneAuthCredential with the code
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: widget.verificationId, smsCode: '082382');

            // Sign the user in (or link) with the credential
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (FirebaseAuth.instance.currentUser != null) {
              print('dddddddddone');
            } else {
             32;
            }
          }, backgroundColor: iconColor),
        ),
      ),
    );
  }
}
