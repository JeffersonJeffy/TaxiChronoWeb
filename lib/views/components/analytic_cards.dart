import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../constants/responsive.dart';
import '../../data/data.dart';
import 'analytic_info_card.dart';

class AnalyticCards extends StatelessWidget {
  const AnalyticCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Responsive(
      mobile: AnalyticInfoCardGridView(
        crossAxisCount: size.width < 650 ? 2 : 4,
        childAspectRatio: size.width < 650 ? 2 : 1.5,
      ),
      tablet: AnalyticInfoCardGridView(),
      desktop: AnalyticInfoCardGridView(
        childAspectRatio: size.width < 1400 ? 1.5 : 2.1,
      ),
    );
  }
}

class AnalyticInfoCardGridView extends StatelessWidget {
   AnalyticInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.4,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final List<Future<int> Function()> counterItemsCollection = [
         () async {
       final usersQuery = await FirebaseFirestore.instance.collection('Utilisateur').get();
       return usersQuery.docs.length;
     },
         () async {
       final usersQuery = await FirebaseFirestore.instance.collection('Commerciaux').get();
       return usersQuery.docs.length;
     },
         () async {
       final usersQuery = await FirebaseFirestore.instance.collection('Clients').get();
       return usersQuery.docs.length;
     },
         () async {
       final usersQuery = await FirebaseFirestore.instance.collection('Chauffeur').get();
       return usersQuery.docs.length;
     },


        () async {
      final usersQuery = await FirebaseFirestore.instance.collection('administrateur').get();
      return usersQuery.docs.length;
    },
        () async {
      final usersQuery = await FirebaseFirestore.instance.collection('cars').get();
      return usersQuery.docs.length;
    },
        () async {
      final usersQuery = await FirebaseFirestore.instance.collection('Reservation').get();
      return usersQuery.docs.length;
    },
        () async {
      final usersQuery = await FirebaseFirestore.instance.collection('TransactionApp').get();
      return usersQuery.docs.length;
    },



        () async {
      final usersQuery = await FirebaseFirestore.instance.collection('Courses').get();
      return usersQuery.docs.length;
    },
        () async {
      final usersQuery = await FirebaseFirestore.instance.collection('riders').get();
      return usersQuery.docs.length;
    },
        () async {
      final usersQuery = await FirebaseFirestore.instance.collection('trips').get();
      return usersQuery.docs.length;
    },
   ];

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: analyticData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: appPadding,
        mainAxisSpacing: appPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {

        var value = FutureBuilder<int>(
          future: counterItemsCollection[index](),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            } else {
              return Text(
                "${snapshot.data}",
                style: const TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              );
            }
          },
        );

        return AnalyticInfoCard(
          info: analyticData[index],
          value: value
        );


      }
    );
  }
}
