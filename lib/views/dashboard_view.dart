

import 'package:flutter/material.dart';
import 'package:taxi_chrono_web/controller/dashboard_controller.dart';
import '../constants/constants.dart';
import '../constants/responsive.dart';
import 'package:provider/provider.dart';
import 'package:taxi_chrono_web/models/user_account_model.dart';

import 'components/dashboard_content.dart';
import 'components/drawer_menu.dart';


class DashboardView extends StatefulWidget {
  static const String pageName = "dashboard";
  final Administrator? admin;
  const DashboardView({Key? key, this.admin}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
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
              child: DashboardContent(admin: widget.admin),
            )
          ],
        ),
      ),
    );
  }
}
