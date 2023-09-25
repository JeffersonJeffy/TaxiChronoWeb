

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_chrono_web/models/customer_model.dart';
import 'package:taxi_chrono_web/models/reservation_model.dart';

import 'driver_model.dart';

class TransactionApp {

  String? commentaireChauffeurSurLeClient;
  String? commentaireClientSurLeChauffeur;
  Timestamp? dateAcceptation;
  int? etatTransaction;
  String? idChauffeur;
  String? idClient;
  String? idReservation;
  String? id;
  double? noteChauffeur;
  Timestamp? tempsAnnulation;
  Timestamp? tempsArrive;
  Timestamp? tempsDepart;


  TransactionApp({
    this.commentaireChauffeurSurLeClient,
    this.commentaireClientSurLeChauffeur,
    this.dateAcceptation,
    this.etatTransaction,
    this.idChauffeur,
    this.idClient,
    this.idReservation,
    this.id,
    this.noteChauffeur,
    this.tempsAnnulation,
    this.tempsArrive,
    this.tempsDepart
});

  factory TransactionApp.fromMap(Map<String, dynamic> data) {
     //final data = document.data()!;
    return TransactionApp(
      commentaireChauffeurSurLeClient: data.containsKey('commentaireChauffeurSurLeClient') ? data['commentaireChauffeurSurLeClient'] : null,
      commentaireClientSurLeChauffeur: data.containsKey('commentaireClientSurLeChauffeur') ? data['commentaireClientSurLeChauffeur'] : null,
      dateAcceptation: data.containsKey('dateAcceptation') ? data['dateAcceptation'] : null,
      etatTransaction: data.containsKey('etatTransaction') ? data['etatTransaction'] : null,
      idChauffeur: data.containsKey('idChauffeur') ? data['idChauffeur'] : null,
      idClient: data.containsKey('idClient') ? data['idClient'] : null,
      idReservation: data.containsKey('idReservation') ? data['idReservation'] : null,
      id: data.containsKey('idTansaction') ? data['idTansaction'] : null,
      noteChauffeur: data.containsKey('noteChauffeur') ? data['noteChauffeur'] : null,
      tempsAnnulation: data.containsKey('tempsAnnulation') ? data['tempsAnnulation'] : null,
      tempsArrive: data.containsKey('tempsArrive') ? data['tempsArrive'] : null,
      tempsDepart: data.containsKey('tempsDepart') ? data['tempsDepart'] : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentaireChauffeurSurLeClient': commentaireChauffeurSurLeClient,
      'commentaireClientSurLeChauffeur': commentaireClientSurLeChauffeur,
      'dateAcceptation': dateAcceptation,
      'etatTransaction': etatTransaction,
      'idChauffeur': idChauffeur,
      'idClient': idClient,
      'idReservation': idReservation,
      'idTansaction': id,
      'noteChauffeur': noteChauffeur,
      'tempsAnnulation': tempsAnnulation,
      'tempsArrive': tempsArrive,
      'tempsDepart': tempsDepart,
    };
  }

}