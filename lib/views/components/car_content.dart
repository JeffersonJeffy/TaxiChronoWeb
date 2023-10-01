import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../constants/responsive.dart';
import '../../localizations/localization.dart';
import '../../models/user_account_model.dart';
import 'car_form.dart.dart';
import 'car_info_detail.dart';
import 'custom_appbar.dart';
import 'filter_widget.dart';

class CarContent extends StatefulWidget {
  final Administrator? admin;
  CarContent({Key? key, this.admin}) : super(key: key);


  @override
  State<CarContent> createState() => _CarContentState();
}

class _CarContentState extends State<CarContent> {

  int filter = 10;
  int totalCar = 0;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbar(admin: widget.admin),
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
                          CarList(),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) CarForm(admin: widget.admin,),
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
                        child: CarForm(admin: widget.admin,),
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


  Future<List<Map<String, dynamic>>> joinCollectionsBetweenCarsAndUsers() async {
    // Effectuer une requête pour récupérer les données de la première collection
    QuerySnapshot firstCarsCollectionSnapshot =
    await FirebaseFirestore.instance.collection('cars').get();
    //await FirebaseFirestore.instance.collection('cars').orderBy('created_at', descending: true).get();

    // Effectuer une requête pour récupérer les données de la deuxième collection
    QuerySnapshot secondDriversCollectionSnapshot =
    await FirebaseFirestore.instance.collection('Utilisateur').get();

    // Combinez les données des deux collections
    List<DocumentSnapshot> firstCarsCollectionDocs = firstCarsCollectionSnapshot.docs;
    List<DocumentSnapshot> secondDriversCollectionDocs = secondDriversCollectionSnapshot.docs;

    // Effectuez la logique de jointure en utilisant l'ID ou un autre champ commun
    totalCar = 0;
    List<Map<String, dynamic>> joinedData = [];
    for (var firstCarDoc in firstCarsCollectionDocs) {
      for (var secondDriverDoc in secondDriversCollectionDocs) {
        if (firstCarDoc["chauffeurId"] == secondDriverDoc.id) {
          //joinedData.add(firstCarDoc.data() as Map<String, dynamic>);
          //joinedData.add(secondDriverDoc.data() as Map<String, dynamic>);

          Map<String, dynamic> joinedItem = {
            'assurance': firstCarDoc['assurance'],
            'expirationAssurance': firstCarDoc['expirationAssurance'],
            'imatriculation': firstCarDoc['imatriculation'],
            'numeroDeChassie': firstCarDoc['numeroDeChassie'],

            'userName': secondDriverDoc['userName'],
          };
          joinedData.add(joinedItem);
          totalCar++;
          break;
        }
      }
    }

    // Utilisez les données combinées dans votre application
    //Logger().d(joinedData);
    return joinedData;
  }

  CarList(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    'Voitures', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                Text(
                  'Total enregistré : $totalCar',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xffa6a6a6),),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                    'Filtre', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
                const SizedBox(width: 10,),
                FilterWidget(
                  filterOptions: const [10, 50, 100, -1], // -1 représente l'option "Tous"
                  selectedOption: filter,
                  onOptionChanged: (newOption) {
                    // Faites quelque chose lorsque l'option est changée
                    print('Nouvelle option sélectionnée : $newOption');
                    setState(() {
                      filter = newOption;
                    });
                  },
                ),
              ],
            )
          ],
        ),

        const SizedBox(
          height: appPadding,
        ),
        FutureBuilder(
          future: joinCollectionsBetweenCarsAndUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            } else{
              List<Map<String, dynamic>> joinedData = snapshot.data!;
              // Trier les utilisateurs par ordre décroissant en fonction de l'ID
              //joinedData.sort((a, b) => b['activeEndDate'].compareTo(a['activeEndDate']));

              // Limiter les résultats aux filtres derniers utilisateurs
              if(filter != -1){
                joinedData = joinedData.sublist(0, joinedData.length > filter ? filter : joinedData.length);
              }
              return CarInfoDetail(joinedData: joinedData);
            }
          },
        ),
      ],
    );
  }

}



