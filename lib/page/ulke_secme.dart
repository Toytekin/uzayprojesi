import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:uzayprojesi/services/user_aouth.dart';
import 'package:uzayprojesi/util/constant/image_yolu.dart';
import 'package:uzayprojesi/util/model/user_model.dart';

class UlkeSecmeEkrani extends StatefulWidget {
  final UserModel userModel;
  const UlkeSecmeEkrani({
    super.key,
    required this.userModel,
  });

  @override
  State<UlkeSecmeEkrani> createState() => _UlkeSecmeEkraniState();
}

class _UlkeSecmeEkraniState extends State<UlkeSecmeEkrani> {
  String secilenUlke = '';
  bool ulkeBos = false;

  @override
  void initState() {
    super.initState();
    ulkeKontrol();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Lottie.asset(AnimasyonLolu.instance.yildizlar),
            Column(
              children: [
                Text(
                  'Choose Your Country',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ulke(),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    cikis(context),
                    ok(context),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    ));
  }

  ElevatedButton ok(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {
          if (secilenUlke != '') {
            context.read<FirebaseServices>().updateUserUlke(
                  widget.userModel.userID,
                  secilenUlke,
                );
            puanArttir();
            Navigator.of(context).pop();
          }
        },
        child: const Text(
          'OK',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  ElevatedButton cikis(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text(
        'Cancel',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Center ulke() {
    return Center(
      child: CountryListPick(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Choisir un pays'),
          ),
          theme: CountryTheme(
            isShowFlag: true,
            isShowTitle: true,
            isShowCode: true,
            isDownIcon: true,
            showEnglishName: true,
          ),
          // Set default value
          initialSelection: '+62',
          // or
          // initialSelection: 'US'
          onChanged: (value) {
            setState(() {
              secilenUlke = value?.code ?? 'tr';
            });
          },
          // Whether to allow the widget to set a custom UI overlay
          useUiOverlay: true,
          // Whether the country list should be wrapped in a SafeArea
          useSafeArea: false),
    );
  }

  Future<void> puanArttir() async {
    if (ulkeBos == true) {
      await context.read<FirebaseServices>().updateUserPuanForVatandaslikTuru(
            widget.userModel.userID,
            widget.userModel,
          );
    }
  }

  ulkeKontrol() {
    if (widget.userModel.vatandaslikTuru == '') {
      setState(() {
        ulkeBos = true;
      });
    } else {
      setState(() {
        ulkeBos = false;
      });
    }
  }
}
