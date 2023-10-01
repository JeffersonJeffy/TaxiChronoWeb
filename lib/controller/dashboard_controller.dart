
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  stringToTimestamp(String dateString){
    // Créer un objet DateFormat pour le format de date spécifié
    DateFormat format = DateFormat("dd-MM-yyyy");
    // Convertir la chaîne de caractères en objet DateTime
    DateTime dateTime = format.parse(dateString);
    // Convertir l'objet DateTime en timestamp en secondes
    int timestamp = dateTime.millisecondsSinceEpoch ~/ 1000;
    print('Le timestamp correspondant est : $timestamp');
    return timestamp;
  }
}