import 'dart:convert';
import 'package:uzayprojesi/util/model/anket_model.dart';

class UserModel {
  String userID;
  String userName;
  int puan;
  String tel;
  String mail;
  String photoURL;
  List<AnketModel> bekleyenAnket;
  String vatandaslikTuru;
  String cinsiyet;
  bool adminMi;

  UserModel({
    required this.userID,
    this.userName = '',
    this.puan = 0,
    this.tel = '',
    this.mail = '',
    this.photoURL = '',
    this.bekleyenAnket = const [],
    this.vatandaslikTuru = '',
    this.cinsiyet = '',
    this.adminMi = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "userID": userID,
      "userName": userName,
      "puan": puan,
      "tel": tel,
      "mail": mail,
      'photoURL': photoURL,
      'bekleyenAnket': bekleyenAnket.map((anket) => anket.toMap()).toList(),
      'vatandaslikTuru': vatandaslikTuru,
      'cinsiyet': cinsiyet,
      'adminMi': adminMi,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userID: map['userID'] ?? '',
      userName: map['userName'] ?? '',
      puan: map['puan'] ?? 0,
      tel: map['tel'] ?? '',
      mail: map['mail'] ?? '',
      photoURL: map['photoURL'] ?? '',
      vatandaslikTuru: map['vatandaslikTuru'] ?? '',
      cinsiyet: map['cinsiyet'] ?? '',
      adminMi: map['adminMi'] ?? false,
      bekleyenAnket: List<AnketModel>.from((map['bekleyenAnket'] ?? [])
          .map((anketMap) => AnketModel.fromMap(anketMap))),
    );
  }
}
