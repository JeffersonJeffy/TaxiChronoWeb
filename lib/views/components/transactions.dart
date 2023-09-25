import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:taxi_chrono_web/models/reservation_model.dart';
import 'package:taxi_chrono_web/models/user_account_model.dart';
import 'package:taxi_chrono_web/views/components/transaction_info_detail.dart';

import '../../constants/constants.dart';
import '../../localizations/localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/driver_model.dart';
import '../../models/transaction_model.dart';

class Transactions extends StatelessWidget {
  Transactions({Key? key}) : super(key: key);
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
                localization.trans('transactions_list')!,
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
              future: joinCollectionsBetweenTransactionsReservationsUsersDriver(),
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
                      TransactionApp transaction = TransactionApp.fromMap(map);
                      Reservation reservation = Reservation.fromMap(map);
                      UserAccount user = UserAccount.fromMap(map);
                      Driver driver = Driver.fromMap(map);
                      //logger.d(reservation.toMap());
                      //logger.d(user.toMap());
                      //logger.d(transactions.toMap());
                      //logger.d(driver.toMap());

                      return TransactionInfoDetail(reservation: reservation, user: user, transaction: transaction, driver: driver);
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


  Future<List<Map<String, dynamic>>> joinCollectionsBetweenTransactionsReservationsUsersDriver() async {

    // Récupérez les données de la collection Firestore contenant les transactions
    final transactionsCollectionSnapshot = await FirebaseFirestore.instance.collection('TransactionApp').orderBy('dateAcceptation', descending: true).get();
    final reservationsCollectionSnapshot = await FirebaseFirestore.instance.collection('Reservation').get();
    final threeUsersCollectionSnapshot = await FirebaseFirestore.instance.collection('Utilisateur').get();
    final fourDriversCollectionSnapshot = await FirebaseFirestore.instance.collection('Chauffeur').get();

    // Combinez les données des deux collections
    List<DocumentSnapshot> firstTransactionsCollectionDocs = transactionsCollectionSnapshot.docs;
    List<DocumentSnapshot> secondReservationsCollectionDocs = reservationsCollectionSnapshot.docs;
    List<DocumentSnapshot> threeUsersCollectionDocs = threeUsersCollectionSnapshot.docs;
    List<DocumentSnapshot> fourDriversCollectionDocs = fourDriversCollectionSnapshot.docs;

    List<Map<String, dynamic>> joinedData = [];
    for(var firstTransactionDoc in firstTransactionsCollectionDocs){
      for(var secondReservationsDoc in secondReservationsCollectionDocs){
        for(var threeUserDoc in threeUsersCollectionDocs){
          for(var fourDriverDoc in fourDriversCollectionDocs){
            if(firstTransactionDoc["idReservation"]==secondReservationsDoc.id &&
                threeUserDoc.id == firstTransactionDoc['idClient'] &&
                fourDriverDoc["userid"] == firstTransactionDoc['idChauffeur']){
              Map<String, dynamic> joinedItem = {
                //Transaction
                'commentaireChauffeurSurLeClient': firstTransactionDoc['commentaireChauffeurSurLeClient'],
                'commentaireClientSurLeChauffeur': firstTransactionDoc['commentaireClientSurLeChauffeur'],
                'dateAcceptation': firstTransactionDoc['dateAcceptation'],
                'etatTransaction': firstTransactionDoc['etatTransaction'],
                'idChauffeur': firstTransactionDoc['idChauffeur'],
                //'idClient': firstTransactionDoc['idClient'],
                //'idReservation': firstTransactionDoc['idReservation'],
                'idTansaction': firstTransactionDoc['idTansaction'],
                'noteChauffeur': firstTransactionDoc['noteChauffeur'],
                'tempsAnnulation': firstTransactionDoc['tempsAnnulation'],
                'tempsArrive': firstTransactionDoc['tempsArrive'],
                'tempsDepart': firstTransactionDoc['tempsDepart'],

                //reservation
                'dateReservation': secondReservationsDoc['dateReservation'],
                'etatReservation': secondReservationsDoc['etatReservation'],
                'idClient': secondReservationsDoc['idClient'],
                'idReservation': secondReservationsDoc['idReservation'],
                'pointArrive': secondReservationsDoc['pointArrive'],
                'pointDepart': secondReservationsDoc['pointDepart'],
                'positionClient': secondReservationsDoc['positionClient'],
                'prixReservation': secondReservationsDoc['prixReservation'],


                //user
                //'userid': threeUserDoc['userid'],
                //'ExpireCniDate': firstUserDoc['ExpireCniDate'],
                'userAdresse': threeUserDoc['userAdresse'],
                //'userCni': firstUserDoc['userCni'],
                'userEmail': threeUserDoc['userEmail'],
                'userName': threeUserDoc['userName'],
                'userTelephone': threeUserDoc['userTelephone'],

                //driver
                'expirePermiDate': fourDriverDoc['expirePermiDate'],
                'numeroPermi': fourDriverDoc['numeroPermi'],
                'userid': fourDriverDoc['userid'],

              };
              joinedData.add(joinedItem);
              break;
            }
          }
        }
      }
    }



    logger.d(joinedData.length);

    //Logger().d(joinedData);
    return joinedData;
  }

}
