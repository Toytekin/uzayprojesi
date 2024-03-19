import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzayprojesi/page/home/home.dart';
import 'package:uzayprojesi/services/user_aouth.dart';
import 'package:uzayprojesi/util/constant/image_yolu.dart';
import 'package:uzayprojesi/util/model/user_model.dart';

mixin HomeModel on State<HomeScreen> {
  TextEditingController controller = TextEditingController();

  bool showButton = true;
  bool userTelVarmi = false;
  UserModel usermodel = UserModel(
    puan: 0,
    tel: '',
    userID: '2222',
    mail: 'HATA',
    photoURL: ImageYolu.instance.user,
    userName: 'İsimsiz',
  );

  final String isim = 'Name: ';
  final String mail = 'Mail: ';
  final String tel = 'Tel: ';
  final String ulke = 'Country: ';
  final String bekleyenAnket = 'Pending Survey: ';
  final String puan = 'Point: ';

  Future<void> checkButtonVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    final lastClicked = prefs.getInt('last_clicked') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    const oneDayMilliseconds = 24 * 60 * 60 * 1000; // 24 hours in milliseconds
    setState(() {
      showButton = (currentTime - lastClicked) >= oneDayMilliseconds;
    });
  }

  Future<void> updateLastClicked() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_clicked', DateTime.now().millisecondsSinceEpoch);
  }

  @override
  void initState() {
    super.initState();
    checkButtonVisibility();

    userCek();
  }

  String karekodaVeriHazirla(UserModel userModel) {
    String veri =
        'Adı: ${usermodel.userName}\nMail: ${usermodel.mail}\nPuan:${usermodel.puan}\nTel: ${usermodel.tel}\nVatandaş: ${usermodel.vatandaslikTuru}';

    return veri;
  }

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    return '$day.$month.$year';
  }

  Center veriYokise() {
    return const Center(
      child: Text('No posts available'),
    );
  }

  Center verilerYuklenirken() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

// Veri tabanından USER bilgilerini aldık
  Future<void> userCek() async {
    var data = await context.read<FirebaseServices>().getUserModel();
    if (data != null) {
      usermodel = data;
      if (usermodel.tel == '') {
        userTelVarmi = true;
      } else {
        userTelVarmi = false;
      }
    }

    setState(() {});
  }

//Telefon girldiğinde puan artsinmi artmasinmi
  Future<void> puanArttir() async {
    if (userTelVarmi == true) {
      await context
          .read<FirebaseServices>()
          .updateUserPuan(usermodel.userID, usermodel.puan, 100);
    }
  }
}
