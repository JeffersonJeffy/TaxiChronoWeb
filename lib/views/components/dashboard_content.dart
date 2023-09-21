import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxi_chrono_web/views/components/top_referals.dart';
import 'package:taxi_chrono_web/views/components/users.dart';
import 'package:taxi_chrono_web/views/components/users_by_device.dart';
import 'package:taxi_chrono_web/views/components/viewers.dart';

import '../../constants/constants.dart';
import '../../constants/responsive.dart';
import '../../models/user_account_model.dart';
import 'analytic_cards.dart';
import 'custom_appbar.dart';
import 'reservations.dart';

class DashboardContent extends StatelessWidget {
  final Administrator? admin;
  const DashboardContent({Key? key, this.admin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    admin;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbar(admin: admin),
            const SizedBox(
              height: appPadding,
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          const AnalyticCards(),
                          const SizedBox(
                            height: appPadding,
                          ),
                          const Users(),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) Reservations(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      const SizedBox(
                        width: appPadding,
                      ),
                    if (!Responsive.isMobile(context))
                       Expanded(
                        flex: 2,
                        child: Reservations(),
                      ),
                  ],
                ),
                /*Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: appPadding,
                          ),
                          Row(
                            children: [
                              if(!Responsive.isMobile(context))
                                Expanded(
                                  child: TopReferals(),
                                  flex: 2,
                                ),
                              if(!Responsive.isMobile(context))
                                SizedBox(width: appPadding,),
                              Expanded(
                                flex: 3,
                                child: Viewers(),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          SizedBox(
                            height: appPadding,
                          ),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) TopReferals(),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) UsersByDevice(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        width: appPadding,
                      ),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: UsersByDevice(),
                      ),
                  ],
                ),*/
              ],
            ),

          ],
        ),
      ),
    );
  }
}
