import 'package:flutter/material.dart';
import 'package:taxi_chrono_web/views/car_view.dart';
import 'package:taxi_chrono_web/views/driver_view.dart';
import 'package:taxi_chrono_web/views/salesperson_view.dart';
import 'package:taxi_chrono_web/views/transaction_view.dart';

import '../../../constants/constants.dart';
import '../../../localizations/localization.dart';
import '../../../models/user_account_model.dart';
import '../dashboard_view.dart';
import 'drawer_list_tile.dart';

class DrawerMenu extends StatelessWidget {
  final Administrator? admin;
  const DrawerMenu({Key? key, this.admin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late AppLocalizations localization = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(appPadding),
            child: Image.asset("assets/images/logo.jpg"),
          ),
          DrawerListTile(
              title: localization.trans('dashboard')!,
              svgSrc: 'assets/icons/Dashboard.svg',
              tap: () {
                Navigator.of(context)
                    .pushNamed(DashboardView.pageName, arguments: {
                  "admin": admin
                });
              }),
          DrawerListTile(
              title: localization.trans('transactions')!,
              svgSrc: 'assets/icons/Statistics.svg',
              tap: () {
                Navigator.of(context)
                    .pushNamed(TransactionView.pageName, arguments: {
                  "admin": admin
                });
              }),
          DrawerListTile(
              title: localization.trans('salesperson')!,
              svgSrc: 'assets/icons/BlogPost.svg',
              tap: () {
                Navigator.of(context)
                    .pushNamed(SalesPersonView.pageName, arguments: {
                  "admin": admin
                });
              }),
          DrawerListTile(
              title: localization.trans('drivers')!,
              svgSrc: 'assets/icons/chauffeur.svg',
              tap: () {
                Navigator.of(context)
                    .pushNamed(DriverView.pageName, arguments: {
                  "admin": admin
                });
              }),
          DrawerListTile(
              title: localization.trans('cars')!,
              svgSrc: 'assets/icons/car.svg',
              tap: () {
                Navigator.of(context)
                    .pushNamed(CarView.pageName, arguments: {
                  "admin": admin
                });
              }),
          /*DrawerListTile(
              title: localization.trans('message')!, svgSrc: 'assets/icons/Message.svg', tap: () {}),
          DrawerListTile(
              title: localization.trans('statistics')!,
              svgSrc: 'assets/icons/Statistics.svg',
              tap: () {}),*/
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: appPadding * 2),
            child: Divider(
              color: grey,
              thickness: 0.2,
            ),
          ),

          DrawerListTile(
              title: localization.trans('settings')!,
              svgSrc: 'assets/icons/Setting.svg',
              tap: () {}),
          DrawerListTile(
              title: localization.trans('logout')!,
              svgSrc: 'assets/icons/Logout.svg',
              tap: () {}),
        ],
      ),
    );
  }
}
