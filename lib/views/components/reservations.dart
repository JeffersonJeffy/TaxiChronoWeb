import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:taxi_chrono_web/models/reservation_model.dart';
import 'package:taxi_chrono_web/models/user_account_model.dart';

import '../../constants/constants.dart';
import '../../localizations/localization.dart';
import 'reservation_info_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reservations extends StatelessWidget {
  Reservations({Key? key}) : super(key: key);
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Container(
      height: 400,
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
                localization.trans('reservation_list')!,
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
            child: FutureBuilder(
              future: joinCollectionsBetweenReservationAndUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Erreur : ${snapshot.error}');
                } else{
                  List<Map<String, dynamic>> joinedData = snapshot.data!;

                 return ListView.builder(
                    //physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: joinedData.length,
                    itemBuilder: (context, index) {
                      final map = joinedData[index];
                      Reservation reservation = Reservation.fromMap(map);
                      UserAccount user = UserAccount.fromMap(map);
                      logger.d(reservation.toMap());
                      logger.d(user.toMap());
                      return ReservationInfoDetail(reservation: reservation, user: user);
                    },
                  );

                }
              },
            ),
          )
        ],
      ),
    );
  }


  Future<List<Map<String, dynamic>>> joinCollectionsBetweenReservationAndUsers() async {
    // Effectuer une requête pour récupérer les données de la première collection
    QuerySnapshot firstUsersCollectionSnapshot =
    await FirebaseFirestore.instance.collection('Utilisateur').get();

    // Effectuer une requête pour récupérer les données de la deuxième collection
    QuerySnapshot secondReservationsCollectionSnapshot =
    await FirebaseFirestore.instance.collection('Reservation').orderBy('dateReservation', descending: true).get();

    // Combinez les données des deux collections
    List<DocumentSnapshot> firstUsersCollectionDocs = firstUsersCollectionSnapshot.docs;
    List<DocumentSnapshot> secondReservationsCollectionDocs = secondReservationsCollectionSnapshot.docs;

    // Effectuez la logique de jointure en utilisant l'ID ou un autre champ commun
    List<Map<String, dynamic>> joinedData = [];
    for (var firstUserDoc in firstUsersCollectionDocs) {
      for (var secondReservationDoc in secondReservationsCollectionDocs) {
        if (firstUserDoc.id == secondReservationDoc['idClient']) {
          Map<String, dynamic> joinedItem = {
            'userid': firstUserDoc['userid'],
            //'ExpireCniDate': firstUserDoc['ExpireCniDate'],
            'userAdresse': firstUserDoc['userAdresse'],
            //'userCni': firstUserDoc['userCni'],
            'userEmail': firstUserDoc['userEmail'],
            'userName': firstUserDoc['userName'],
            'userTelephone': firstUserDoc['userTelephone'],

            'dateReservation': secondReservationDoc['dateReservation'],
            'etatReservation': secondReservationDoc['etatReservation'],
            'idClient': secondReservationDoc['idClient'],
            'idReservation': secondReservationDoc['idReservation'],
            'pointArrive': secondReservationDoc['pointArrive'],
            'pointDepart': secondReservationDoc['pointDepart'],
            'positionClient': secondReservationDoc['positionClient'],
            'prixReservation': secondReservationDoc['prixReservation'],
          };
          joinedData.add(joinedItem);
          break;
        }
      }
    }

    // Utilisez les données combinées dans votre application

    //Logger().d(joinedData);
    return joinedData;
  }

}
