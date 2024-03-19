import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uzayprojesi/page/anket_doldurma/ank_home.dart';
import 'package:uzayprojesi/services/user_aouth.dart';
import 'package:uzayprojesi/util/model/anket_model.dart';
import 'package:uzayprojesi/util/model/user_model.dart';
import 'package:uzayprojesi/util/widget/sbt_textfid.dart';

class AnketDoldurSayfa extends StatefulWidget {
  final AnketModel anketModel;
  final List<AnketModel> anketModels;
  final UserModel userModel;
  const AnketDoldurSayfa({
    super.key,
    required this.anketModel,
    required this.userModel,
    required this.anketModels,
  });

  @override
  State<AnketDoldurSayfa> createState() => _AnketDoldurSayfaState();
}

class _AnketDoldurSayfaState extends State<AnketDoldurSayfa> {
  var cevapKntr = TextEditingController();
  List<AnketModel> allAnkets = [];
  List<AnketModel> userModelBekleyenAnketler = [];

  @override
  void initState() {
    super.initState();
    anketleriAl();
  }

  anketleriAl() {
    allAnkets = widget.anketModels;
    userModelBekleyenAnketler = widget.userModel.bekleyenAnket;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var siz = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            kart(siz),
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SbtTextField(
                        controller: cevapKntr,
                        hint: 'Answer',
                        satirSayisi: 5,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            verileriKaydet(context, cevapKntr);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnketHome(
                                  anketModels: allAnkets,
                                  userModel: widget.userModel,
                                ),
                              ),
                            );
                          },
                          child: const Text('Ending the Survey'))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded kart(Size siz) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.all(10),
        child: Card(
          child: ListTile(
            title: Text(
              widget.anketModel.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: siz.width / 16,
              ),
            ),
            subtitle: Text(
              widget.anketModel.subTitle,
              style: TextStyle(
                fontSize: siz.width / 25,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
            trailing: Text(
              widget.anketModel.puanMiktari.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: siz.width * 0.05,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verileriKaydet(
      BuildContext context, TextEditingController cevapKntr) async {
    if (cevapKntr.text.isNotEmpty) {
      List<UserModel> dolduranUserlar = widget.anketModel.dolduranUserLar;
      dolduranUserlar.add(widget.userModel);
      AnketModel anketCevap = AnketModel(
        anketID: widget.anketModel.anketID,
        title: widget.anketModel.title,
        subTitle: widget.anketModel.subTitle,
        dolduranUserLar: dolduranUserlar,
        puanMiktari: widget.anketModel.puanMiktari,
        gelenCevap: cevapKntr.text.toString(),
      );
      allAnkets.removeWhere(
          (element) => element.anketID == widget.anketModel.anketID);
      userModelBekleyenAnketler.removeWhere(
          (element) => element.anketID == widget.anketModel.anketID);
      kisiyiGuncelle(userModelBekleyenAnketler, widget.userModel);
      anketiKasydet(anketCevap);
      paunArttir(anketCevap, widget.userModel);
    }
  }

  anketiKasydet(AnketModel anketCevap) async {
    await context.read<FirebaseServices>().updateAnket(anketCevap);
  }

  Future<void> kisiyiGuncelle(
      List<AnketModel> userModelBekleyenAnketler, UserModel userModel) async {
    UserModel updateuserModel = UserModel(
      userID: userModel.userID,
      bekleyenAnket: userModelBekleyenAnketler,
      adminMi: userModel.adminMi,
      cinsiyet: userModel.cinsiyet,
      mail: userModel.mail,
      photoURL: userModel.photoURL,
      puan: userModel.puan,
      tel: userModel.tel,
      userName: userModel.userName,
      vatandaslikTuru: userModel.vatandaslikTuru,
    );
    await context.read<FirebaseServices>().userUpdate(updateuserModel);
  }

  paunArttir(AnketModel anketCevap, UserModel userModel) async {
    await context.read<FirebaseServices>().updateUserPuan(
        userModel.userID, anketCevap.puanMiktari, userModel.puan);
  }
}
