import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_chrono_web/controller/dashboard_controller.dart';
import 'package:taxi_chrono_web/controller/salesperson_controller.dart';
import 'package:taxi_chrono_web/views/components/profile_info.dart';
import 'package:taxi_chrono_web/views/components/search_field.dart';
import 'package:taxi_chrono_web/views/transaction_view.dart';

import '../../../constants/constants.dart';
import '../../../constants/responsive.dart';
import '../../../models/user_account_model.dart';
import '../salesperson_view.dart';

class CustomAppbar extends StatelessWidget {
  final Administrator? admin;
  final type;
  const CustomAppbar({Key? key, this.admin, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isWebDesktop(context))
          IconButton(
            onPressed: type==SalesPersonView.pageName ? context.read<SalesPersonController>().controlMenu :
            context.read<DashboardController>().controlMenu,
            icon: Icon(Icons.menu,color: textColor.withOpacity(0.5),),
          ),
        const Expanded(child: SearchField()),
        ProfileInfo(admin: admin)
      ],
    );
  }
}
