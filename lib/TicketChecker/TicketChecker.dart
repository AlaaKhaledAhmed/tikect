import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tikect/Funcations/Funcation.dart';
import 'package:tikect/Messag/Messages.dart';
import 'package:tikect/TicketChecker/ScanQR.dart';

import '../Colors/Colors.dart';
import '../Log/Logging.dart';

class TicketChecker extends StatefulWidget {
  const TicketChecker({Key? key}) : super(key: key);

  @override
  State<TicketChecker> createState() => _TicketCheckerState();
}

class _TicketCheckerState extends State<TicketChecker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text(context, 'Scan QR', mainTextSize + 2, black),
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
      body: Center(
        child: InkWell(
            onTap: () {
              goTo(context, ScanneQR());
            },
            child: Icon(Icons.qr_code_sharp, size: 100.sp)),
      ),
    );
  }
}
