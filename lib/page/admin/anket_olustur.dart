import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uzayprojesi/page/admin/a_home.dart';
import 'package:uzayprojesi/services/user_aouth.dart';
import 'package:uzayprojesi/util/model/anket_model.dart';
import 'package:uzayprojesi/util/model/user_model.dart';
import 'package:uzayprojesi/util/widget/sbt_textfid.dart';

class AnketOlustur extends StatefulWidget {
  final UserModel userModel;

  final AnketModel? anketModel;
  const AnketOlustur({
    super.key,
    this.anketModel,
    required this.userModel,
  });

  @override
  State<AnketOlustur> createState() => _AnketOlusturState();
}

class _AnketOlusturState extends State<AnketOlustur> {
  var titleCtrl = TextEditingController();
  var writeCtrl = TextEditingController();
  var puanCtrl = TextEditingController();
  final String baslik = 'Title...';
  final String yazi = 'Wiriting...';
  final String puan = 'Point...';
  final String yayinla = 'Publish...';

  final String dylTitle = 'Warning';
  final String dylgYazi =
      'Please try again after making sure all fields are filled.';

  bool anketDolumu = false;

  @override
  void initState() {
    super.initState();
    if (widget.anketModel != null) {
      anketDoldur(widget.anketModel!);
    }
  }

  anketDoldur(AnketModel anketModel) {
    anketDolumu = true;
    titleCtrl.text = anketModel.title;
    writeCtrl.text = anketModel.subTitle;
    puanCtrl.text = anketModel.puanMiktari.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SbtTextField(controller: titleCtrl, hint: baslik),
              SbtTextField(controller: writeCtrl, hint: yazi, satirSayisi: 4),
              SbtTextField(
                controller: puanCtrl,
                hint: puan,
                klvyeTipi: false,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [silButon(context), onayButon(context)],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton silButon(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          sil(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminHomeSayfasi(
                userModel: widget.userModel,
              ),
            ),
          );
        },
        child: const Text(
          'Delete',
          style: TextStyle(color: Colors.white),
        ));
  }

  ElevatedButton onayButon(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (titleCtrl.text.isNotEmpty && writeCtrl.text.isNotEmpty) {
            if (puanCtrl.text.length > 2) {
              var anketID = const Uuid().v1();
              AnketModel anketModel = AnketModel(
                  anketID: anketID,
                  title: titleCtrl.text,
                  subTitle: writeCtrl.text,
                  puanMiktari: int.parse(puanCtrl.text));

              anketKaydet(anketModel);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AdminHomeSayfasi(userModel: widget.userModel),
                ),
              );
            }
          } else {
            diyalog(context);
          }
        },
        child: Text(
          yayinla,
          style: const TextStyle(color: Colors.black),
        ));
  }

  Future<dynamic> diyalog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(dylTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(dylgYazi),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          ),
        );
      },
    );
  }

  alanlariTemizle() {
    titleCtrl.clear();
    writeCtrl.clear();
    puanCtrl.clear();
  }

  anketKaydet(AnketModel anketModel) async {
    await context.read<FirebaseServices>().saveAnket(anketModel);
  }

  Future<void> sil(BuildContext context) async {
    await context
        .read<FirebaseServices>()
        .deleteAnket(widget.anketModel!.anketID);
  }
}
