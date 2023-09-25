import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:taxi_chrono_web/models/salesperson_model.dart';
import 'package:taxi_chrono_web/views/components/salesperson_info_detail.dart';

import '../../../constants/constants.dart';
import '../../../localizations/localization.dart';

class SalesPersonList extends StatelessWidget {
  const SalesPersonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    Logger logger = Logger();
    return Container(
      height: 540,
      padding: const EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localization.trans("salesperson_list")!,
                style: const TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(
                localization.trans('view_all')!,
                style: TextStyle(
                  color: textColor.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: appPadding,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Commerciaux').snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text("Error: ${snapshot.hasError}");
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final salesPersons = snapshot.data!.docs;
                return ListView.builder(
                  //physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: salesPersons.length,
                  itemBuilder: (context, index) {
                    final salesPerson = salesPersons[index].data() as Map<String, dynamic>;
                    SalesPerson items = SalesPerson.fromMap(salesPerson);
                    logger.d(items.toMap());
                    return SalesPersonInfoDetail(itemSalesPerson: items,);
                  }
                );
              },
            )
          )
        ],
      ),
    );
  }
}
