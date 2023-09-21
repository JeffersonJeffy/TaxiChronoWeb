

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_chrono_web/models/position_model.dart';

class EndPoint {

  String? code;
  String? nom;
  Position? position;

  EndPoint({this.code, this.nom, this.position});

  factory EndPoint.fromMap(Map<String, dynamic> data) {
    //final data = document.data()!;
    return EndPoint(
      code: data['code'],
      nom: data['nom'],
      position: data['position'] != null ? Position.fromMap(data['position']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'nom': nom,
      'position': position != null ? position!.toMap() : null,
    };
  }
}