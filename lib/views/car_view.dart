import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../constants/responsive.dart';
import '../controller/dashboard_controller.dart';
import 'components/car_content.dart';
import 'components/drawer_menu.dart';
import 'package:provider/provider.dart';
import '../models/user_account_model.dart';



class CarView extends StatefulWidget {
  const CarView({Key? key, this.admin}) : super(key: key);
  final Administrator? admin;
  static const String pageName = "cars";

  @override
  State<CarView> createState() => _CarViewState();
}

class _CarViewState extends State<CarView> {
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
              child: CarContent(admin: widget.admin),
            )
          ],
        ),
      ),
    );
  }
}
