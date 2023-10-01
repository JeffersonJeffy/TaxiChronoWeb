import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../constants/responsive.dart';
import '../../models/user_account_model.dart';
import 'custom_appbar.dart';
import 'driver_form.dart';
import 'filter_widget.dart';
import 'driver_info_detail.dart';

class DriverContent extends StatefulWidget {
  final Administrator? admin;
  const DriverContent({Key? key, this.admin}) : super(key: key);

  @override
  State<DriverContent> createState() => _DriverContentState();
}

class _DriverContentState extends State<DriverContent> {
  int filter = 10;
  int totalDriver = 0;


  @override
  Widget build(BuildContext context) {
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
                          const SizedBox(
                            height: appPadding,
                          ),
                          DriverList(),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) DriverForm(admin: widget.admin,),
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
                        child: DriverForm(admin: widget.admin,),
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

  Future<List<Map<String, dynamic>>> joinCollectionsBetweenUsersAndDrivers() async {
    // Effectuer une requête pour récupérer les données de la première collection
    QuerySnapshot firstUsersCollectionSnapshot =
    await FirebaseFirestore.instance.collection('Utilisateur').get();
    //await FirebaseFirestore.instance.collection('cars').orderBy('created_at', descending: true).get();

    // Effectuer une requête pour récupérer les données de la deuxième collection
    QuerySnapshot secondDriversCollectionSnapshot =
    await FirebaseFirestore.instance.collection('Chauffeur').get();

    // Combinez les données des deux collections
    List<DocumentSnapshot> firstUsersCollectionDocs = firstUsersCollectionSnapshot.docs;
    List<DocumentSnapshot> secondDriversCollectionDocs = secondDriversCollectionSnapshot.docs;

    totalDriver = 0;
    // Effectuez la logique de jointure en utilisant l'ID ou un autre champ commun
    List<Map<String, dynamic>> joinedData = [];
    for (var firstUserDoc in firstUsersCollectionDocs) {
      for (var secondDriverDoc in secondDriversCollectionDocs) {
        if (firstUserDoc.id == secondDriverDoc["userid"]) {
          Map<String, dynamic> joinedItem = {

            'userAdresse': firstUserDoc['userAdresse'],
            'userCni': firstUserDoc['userCni'],
            'userEmail': firstUserDoc['userEmail'],
            'userName': firstUserDoc['userName'],
            'userTelephone': firstUserDoc['userTelephone'],

            'expirePermiDate': secondDriverDoc['expirePermiDate'],
            'numeroPermi': secondDriverDoc['numeroPermi'],
            'userid': secondDriverDoc['userid'],

          };
          joinedData.add(joinedItem);
          totalDriver++;
          break;
        }
      }
    }

    // Utilisez les données combinées dans votre application

    //Logger().d(joinedData);
    return joinedData;
  }

  DriverList(){
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
                    'Chauffeurs', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                Text(
                  'Total enregistré : $totalDriver',
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
          future: joinCollectionsBetweenUsersAndDrivers(),
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
              joinedData.sort((a, b) => b['userid'].compareTo(a['userid']));

              // Limiter les résultats aux filtres derniers utilisateurs
              if(filter != -1){
                joinedData = joinedData.sublist(0, joinedData.length > filter ? filter : joinedData.length);
              }
              return DriverInfoDetail(joinedData: joinedData);
            }
          },
        ),
      ],
    );
  }
}



