

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_chrono_web/models/position_model.dart';

class StartPoint {

  String? code;
  String? nom;
  Position? position;

  StartPoint({this.code, this.nom, this.position});

  factory StartPoint.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StartPoint(
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