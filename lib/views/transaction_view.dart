import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../constants/responsive.dart';
import '../controller/dashboard_controller.dart';
import '../models/user_account_model.dart';
import 'components/drawer_menu.dart';
import 'components/transaction_content.dart';




class TransactionView extends StatefulWidget {
  const TransactionView({Key? key, this.admin}) : super(key: key);
  final Administrator? admin;
  static const String pageName = "transactions";

  @override
  State<TransactionView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionView> with SingleTickerProviderStateMixin {
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
              child: TransactionContent(admin: widget.admin),
            )
          ],
        ),
      ),
    );
  }
}