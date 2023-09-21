

import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount {

  String? id;
  String? expireCniDate;
  String? userAdresse;
  String? userCni;
  String? userEmail;
  String? userName;
  String? userTelephone;

  bool? access;
  String? cniRecto;
  String? cniVerso;
  String? code;
  String? dateNaissance;
  String? password;
  String? pays;
  String? photo;
  String? quartier;
  String? sexe;
  String? type;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  UserAccount({
    this.id,
    this.expireCniDate,
    this.userAdresse,
    this.userCni,
    this.userEmail,
    this.userName,
    this.userTelephone,
    this.access,
    this.cniRecto,
    this.cniVerso,
    this.code,
    this.dateNaissance,
    this.password,
    this.pays,
    this.photo,
    this.quartier,
    this.sexe,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  UserAccount.fromMap(Map map) : this(
      id: map['userid'] ?? map['id'],
      expireCniDate: map.containsKey('ExpireCniDate') ? map['ExpireCniDate'] : null,
      userAdresse: map.containsKey('userAdresse') ? map['userAdresse'] : null,
      userCni: map.containsKey('userCni') ? map['userCni'] : null,
      userEmail: map.containsKey('userEmail') ? map['userEmail'] : null,
      userName: map.containsKey('userName') ? map['userName'] : null,
      userTelephone: map.containsKey('userTelephone') ? map['userTelephone'] : null,
  );

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "expireCniDate": expireCniDate,
      "userAdresse": userAdresse,
      "userCni": userCni,
      "userEmail": userEmail,
      "userName": userName,
      "userTelephone": userTelephone,
      "access": access,
      "cniRecto": cniRecto,
      "cniVerso": cniVerso,
      "code": code,
      "dateNaissance": dateNaissance,
      "password": password,
      "pays": pays,
      "photo": photo,
      "quartier": quartier,
      "sexe": sexe,
      "type": type,
      "created_at": createdAt,
      "updated_at": createdAt,

      "email": userEmail,
      "expirationCni": expireCniDate,
      "nom": userName,
      "cni": userCni,
      "tel": userTelephone,
    };
  }

  factory UserAccount.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return UserAccount(

      id: document.id,
      expireCniDate: data["ExpireCniDate"] ?? data["ExpireCniDate"],
      userAdresse: data["userAdresse"],
      userCni: data["userCni"] ?? data["cni"],
      userEmail: data["userEmail"] ?? data["email"],
      userName: data["userName"] ?? data["nom"],
      userTelephone: data["userTelephone"] ?? data["tel"],

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
      updatedAt: data["updated_at"],

    );
  }

}


class Administrator extends UserAccount {

  Administrator({
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

  @override
  Map<String, dynamic> toMap(){
    return {
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

  factory Administrator.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return Administrator(
        id: document.id,
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

}