

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_chrono_web/models/user_account_model.dart';

class SalesPerson extends UserAccount {
  String? salesRegion;
  int? salesTarget;
  String? promoCode;

  SalesPerson({
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
    String? createdBy,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    this.salesRegion,
    this.salesTarget,
    this.promoCode,
    // Autres champs spécifiques au vendeur
  }) : super(id: id,
    expireCniDate: expireCniDate,
    userAdresse: userAdresse,
    userCni: userCni,
    userEmail: userEmail,
    userName: userName,
    userTelephone: userTelephone,
    access: access,
    cniRecto: cniRecto,
    cniVerso: cniVerso,
    code: code,
    dateNaissance: dateNaissance,
    password: password,
    pays: pays,
    photo: photo,
    quartier: quartier,
    sexe: sexe,
    type: type,
    createdBy: createdBy,
    createdAt: createdAt,
    updatedAt: updatedAt,);


  @override
  Map<String, dynamic> toMap(){
    final Map<String, dynamic> data = super.toMap();
    data["sales_region"] = salesRegion;
    data["sales_target"] = salesTarget;
    data["promo_code"] = promoCode;
    return data;
  }

  factory SalesPerson.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return SalesPerson(
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
        createdBy: data["created_by"],
        createdAt: data["created_at"],
        updatedAt: data["updated_at"],

        salesRegion: data["sales_region"],
        salesTarget: data["sales_target"],
        promoCode: data["promo_code"]
    );
  }

   SalesPerson.fromMap(Map<String, dynamic> data)
    : this(
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
        updatedAt: data["updated_at"],

        salesRegion: data["sales_region"],
        salesTarget: data["sales_target"],
        promoCode: data["promo_code"],
        createdBy: data["created_by"],
    );

}