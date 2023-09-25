import 'package:flutter/material.dart';
import 'package:taxi_chrono_web/views/add_salesperson_view.dart';
import 'package:taxi_chrono_web/views/components/salesperson_list.dart';
import 'package:taxi_chrono_web/views/components/salespersons.dart';
import 'package:taxi_chrono_web/views/salesperson_view.dart';
import '../../constants/constants.dart';
import '../../constants/responsive.dart';
import '../../localizations/localization.dart';
import '../../models/user_account_model.dart';
import 'custom_appbar.dart';

class SalesPersonContent extends StatelessWidget {
  final Administrator? admin;
  const SalesPersonContent({Key? key, this.admin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbar(admin: admin, type: SalesPersonView.pageName),
            const SizedBox(
              height: appPadding,
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(AddSalesPersonView.pageName, arguments: {
                                "admin": admin
                              });
                            },
                            label: Text(localization.trans('add')!),
                            icon: const Icon(Icons.add),
                          ),
                          const SizedBox(
                            height: appPadding,
                          ),
                          const SalesPersons(),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) SalesPersonList(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      const SizedBox(
                        width: appPadding,
                      ),
                    if (!Responsive.isMobile(context))
                      const Expanded(
                        flex: 2,
                        child: SalesPersonList(),
                      ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
