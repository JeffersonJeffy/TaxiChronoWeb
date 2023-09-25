

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_chrono_web/models/position_model.dart';
import 'package:taxi_chrono_web/models/user_account_model.dart';

class Driver extends UserAccount {

  Timestamp? expirePermiDate;
  String? numeroPermi;

  bool? online;
  Position? position;
  String? permiConduire;
  String? carteGrise;
  String? assurance;
  String? immatriculation;
  bool? payer;
  bool? treated;
  //User? userAccount;

  Driver({
    this.expirePermiDate,
    this.numeroPermi,
    this.online,
    this.position,
    this.permiConduire,
    this.carteGrise,
    this.assurance,
    this.immatriculation,
    this.payer,
    this.treated,
    //this.userAccount,
    String? id,
    String? expireCniDate,
    String? userAdresse,
    String? userCni,
    String? userEmail,
    String? userName,
    String? userTelephone,
    bool? access,
    String? cniRecto,
    String? cniVerso,
    String? code,
    String? dateNaissance,
    String? password,
    String? pays,
    String? photo,
    String? quartier,
    String? sexe,
    String? type,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) : super(id: id, expireCniDate: expireCniDate,
    userAdresse: userAdresse, userCni: userCni, userEmail: userEmail,
    userName: userName, userTelephone: userTelephone, access: access,
    cniRecto: cniRecto, cniVerso: cniVerso, code: code, dateNaissance: dateNaissance,
    password: password, pays: pays, photo: photo, quartier: quartier, sexe: sexe,
    type: type, createdAt: createdAt, updatedAt: updatedAt,);


  factory Driver.fromMap(Map<String, dynamic> data) {
    //final data = document.data()!;
    return Driver(
      expirePermiDate: data['expirePermiDate'],
      numeroPermi: data['numeroPermi'],
      online: data['online'],
      position: data['position'] != null
          ? Position(
        lat: data['position']['latitude'],
        long: data['position']['longitude'],
      )
          : null,
      permiConduire: data['permiConduire'],
      carteGrise: data['carteGrise'],
      assurance: data['assurance'],
      immatriculation: data['immatriculation'],
      payer: data['payer'],
      treated: data['treated'],
      //userAccount: data['user'] != null ? User.fromSnapshot(data['user']) : null,
        //id: document.id,
        expireCniDate: data["expiration_cni"] ?? data["expireCniDate"],
        userAdresse: data["userAdresse"],
        userCni: data["cni"] ?? data["userCni"],
        userEmail: data["email"] ?? data["userEmail"],
        userName: data["nom"] ?? data["userName"],
        userTelephone: data["tel"] ?? data["userTelephone"],

        access: data["access"],
        cniRecto: data["cni_recto"],
        cniVerso: data["cni_verso"],
        code: data["code"],
        dateNaissance: data["date_naissance"],
        password: data["password"],
        pays: data["pays"],
        photo: data["photo"],
        quartier: data["quartier"],
        sexe: data["sexe"],
        type: data["type"],
        createdAt: data["created_at"],
        updatedAt: data["updated_at"]
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'expirePermiDate': expirePermiDate,
      'numeroPermi': numeroPermi,
      'online': online,
      'position': position != null
          ? {
        'lat': position!.lat,
        'lon': position!.long,
      }
          : null,
      'permiConduire': permiConduire,
      'carteGrise': carteGrise,
      'assurance': assurance,
      'immatriculation': immatriculation,
      'payer': payer,
      'treated': treated,
      //'user': userAccount != null ? userAccount!.toMap() : null,
      "id": id,
      "expireCniDate": expireCniDate,
      "userAdresse": userAdresse,
      "userCni": userCni,
      "userEmail": userEmail,
      "userName": userName,
      "userTelephone": userTelephone,

      "access": access,
      "cni_recto": cniRecto,
      "cni_verso": cniVerso,
      "code": code,
      "date_naissance": dateNaissance,
      "password": password,
      "pays": pays,
      "photo": photo,
      "quartier": quartier,
      "sexe": sexe,
      "type": type,
      "created_at": createdAt,
      "updatedAt": updatedAt,

      "email": userEmail,
      "expirationCni": expireCniDate,
      "nom": userName,
      "cni": userCni,
      "tel": userTelephone,
    };
  }
}