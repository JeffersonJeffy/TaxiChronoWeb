

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_chrono_web/models/position_model.dart';
import 'package:taxi_chrono_web/models/user_account_model.dart';

class Driver extends UserAccount {

  Timestamp? expirePermiDate;
  String? numeroPermi;
  String? userid;

  Driver({
    this.expirePermiDate,
    this.numeroPermi,
    this.userid,
    String? id,
    String? expireCniDate,
    String? userAdresse,
    String? userCni,
    String? userEmail,
    String? userName,
    String? userTelephone,
    String? createdBy,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) : super(id: id, expireCniDate: expireCniDate,
    userAdresse: userAdresse, userCni: userCni, userEmail: userEmail,
    userName: userName, userTelephone: userTelephone,
    createdBy:createdBy, createdAt: createdAt, updatedAt: updatedAt,);



  factory Driver.fromMapDropdownList(Map<String, dynamic> data) {
    //final data = document.data()!;
    return Driver(
        userid: data['userid'],
        expireCniDate: data["expireCniDate"],
        userAdresse: data["userAdresse"],
        userCni: data["userCni"],
        userEmail: data["userEmail"],
        userName: data["userName"],
        userTelephone: data["userTelephone"],

        createdBy: data["created_by"],
        createdAt: data["created_at"],
        updatedAt: data["updated_at"]
    );
  }


  factory Driver.fromMap(Map<String, dynamic> data) {
    //final data = document.data()!;
    return Driver(
      expirePermiDate: data['expirePermiDate'],
      numeroPermi: data['numeroPermi'],
      userid: data['userid'],
      //userAccount: data['user'] != null ? User.fromSnapshot(data['user']) : null,
        //id: document.id,
        id: data["id"],
        expireCniDate: data["expiration_cni"] ?? data["expireCniDate"],
        userAdresse: data["userAdresse"] ?? data["quartier"],
        userCni: data["cni"] ?? data["userCni"],
        userEmail: data["email"] ?? data["userEmail"],
        userName: data["nom"] ?? data["userName"],
        userTelephone: data["tel"] ?? data["userTelephone"],

        createdBy: data["created_by"],
        createdAt: data["created_at"],
        updatedAt: data["updated_at"]
    );
  }

  Map<String, dynamic> toUserMap() {
    return {
      'expireCniDate' : expireCniDate,
      'userAdresse' : userAdresse,
      'userCni' : userCni,
      'userEmail' : userEmail,
      'userName' : userName,
      'userTelephone' : userTelephone,
      'userid' : id,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = super.toMap();
    data['expireCniDate'] = expireCniDate;
    data['userAdresse'] = userAdresse;
    data['userCni'] = userCni;
    data['userid'] = userid;
    return data;
  }

  Map<String, dynamic> toMapDriver() {
    return {
    'expirePermiDate' : expirePermiDate,
    'numeroPermi' : numeroPermi,
    'userid' : userid,
    };
  }

}