

import 'package:flutter/material.dart';
import 'package:taxi_chrono_web/controller/dashboard_controller.dart';

import '../constants/constants.dart';
import '../constants/responsive.dart';
import '../models/user_account_model.dart';
import 'components/drawer_menu.dart';
import 'package:provider/provider.dart';

import 'components/driver_content.dart';

class DriverView extends StatefulWidget {
  const DriverView({Key? key, this.admin}) : super(key: key);
  final Administrator? admin;
  static const String pageName = "drivers";

  @override
  State<DriverView> createState() => _DriverViewState();
}

class _DriverViewState extends State<DriverView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: DrawerMenu(admin: widget.admin),
      key: context.read<DashboardController>().scaffoldKey,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isWebDesktop(context)) const Expanded(child: DrawerMenu(),),
            Expanded(
              flex: 5,
              child: DriverContent(admin: widget.admin),
            )
          ],
        ),
      ),
    );
  }
}
