import 'package:uzayprojesi/util/model/user_model.dart';

class AnketModel {
  String anketID;
  String title;
  String subTitle;
  String gelenCevap;
  int puanMiktari;
  List<UserModel> dolduranUserLar;

  AnketModel({
    required this.anketID,
    required this.title,
    required this.subTitle,
    this.dolduranUserLar = const [], // Boş bir liste olarak başlatıyoruz
    this.gelenCevap = '',
    this.puanMiktari = 100,
  });

  Map<String, dynamic> toMap() {
    return {
      'anketID': anketID,
      'title': title,
      'subTitle': subTitle,
      'gelenCevap': gelenCevap,
      'puanMiktari': puanMiktari,
      'dolduranUserLar': dolduranUserLar.map((user) => user.toMap()).toList(),
    };
  }

  factory AnketModel.fromMap(Map<String, dynamic> map) {
    return AnketModel(
      anketID: map['anketID'],
      title: map['title'],
      subTitle: map['subTitle'],
      gelenCevap: map['gelenCevap'],
      puanMiktari: map['puanMiktari'],
      dolduranUserLar: List<UserModel>.from(
        map['dolduranUserLar'].map((userMap) => UserModel.fromMap(userMap)),
      ),
    );
  }
}
