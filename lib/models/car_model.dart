

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_chrono_web/models/position_model.dart';

class Car {

  String? carId;
  String? activeEndDate;
  String? assurance;
  String? chauffeurId;
  String? expirationAssurance;
  String? imatriculation;
  bool? isActive;
  String? numeroDeChassie;
  Position? position;
  bool? statut;
  String? token;
  String? createdBy;
  Timestamp? createdAt;

  Car({
    this.carId,
    this.activeEndDate,
    this.assurance,
    this.chauffeurId,
    this.expirationAssurance,
    this.imatriculation,
    this.isActive,
    this.numeroDeChassie,
    this.position,
    this.statut,
    this.token,
    this.createdBy,
    this.createdAt
  });

  Car.fromMap(Map map) : this(
    carId: map.containsKey('car_id') ? map['car_id'] : null,
    activeEndDate: map.containsKey('activeEndDate') ? map['activeEndDate']?.toString() : null,
    assurance: map.containsKey('assurance') ? map['assurance'] : null,
    chauffeurId: map.containsKey('chauffeurId') ? map['chauffeurId'] : null,
    expirationAssurance: map.containsKey('expirationAssurance') ? map['expirationAssurance']?.toString() : null,
    imatriculation: map.containsKey('imatriculation') ? map['imatriculation'] : null,
    isActive: map.containsKey('isActive') ? map['isActive'] : false,
    numeroDeChassie: map.containsKey('numeroDeChassie') ? map['numeroDeChassie'] : null,
    position: map.containsKey('position') ? Position.fromMap(map['position']) : null,
    statut: map.containsKey('statut') ? map['statut'] : false,
    token: map.containsKey('token') ? map['token'] : null,
    createdBy: map.containsKey('created_by') ? map['created_by'] : null,
    createdAt: map.containsKey('created_at') ? map['created_at'] : null,
  );

  Map<String, dynamic> toMap(){
    return {
      "car_id": carId,
      "activeEndDate": activeEndDate,
      "assurance": assurance,
      "chauffeurId": chauffeurId,
      "expirationAssurance": expirationAssurance,
      "imatriculation": imatriculation,
      "isActive": isActive,
      "numeroDeChassie": numeroDeChassie,
      "position": position?.toMap(),
      "statut": statut,
      "token": token,
      "created_by": createdBy,
      "created_at": createdAt,
    };
  }

}
