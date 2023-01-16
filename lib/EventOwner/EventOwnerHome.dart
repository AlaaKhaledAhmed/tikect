import 'package:flutter/material.dart';

import '../Colors/Colors.dart';
import '../Funcations/Funcation.dart';
class EventOwnerHome extends StatefulWidget {
  const EventOwnerHome({Key? key}) : super(key: key);

  @override
  State<EventOwnerHome> createState() => _EventOwnerHomeState();
}

class _EventOwnerHomeState extends State<EventOwnerHome> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
    body: text(context, "Event Owner Home",15 , black),

    );
  }
}
