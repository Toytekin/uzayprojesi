import 'package:flutter/material.dart';
import 'package:uzayprojesi/page/home/home.dart';
import 'package:uzayprojesi/util/constant/colors.dart';
import 'package:uzayprojesi/util/constant/sizelar.dart';
import 'package:uzayprojesi/util/model/user_model.dart';

// ignore: must_be_immutable
class OdulEkarani extends StatefulWidget {
  final String gosterilecekOdlMiktari;
  UserModel userModel;
  OdulEkarani({
    super.key,
    required this.gosterilecekOdlMiktari,
    required this.userModel,
  });

  @override
  State<OdulEkarani> createState() => _OdulEkaraniState();
}

class _OdulEkaraniState extends State<OdulEkarani> {
  final String label = 'Ana Sayfa';

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: geriDonmeButon(context),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.gosterilecekOdlMiktari,
              style: TextStyle(
                  fontSize: SbtSize.yaziLarge, color: SbtColor.yaziRenk),
            ),
            anasayfayaDonButonu(context)
          ],
        )),
      ),
    );
  }

  TextButton anasayfayaDonButonu(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userModel: widget.userModel),
          ),
        );
      },
      icon: Icon(
        Icons.home,
        color: SbtColor.yaziRenk,
      ),
      label: Text(
        label,
        style: TextStyle(color: SbtColor.yaziRenk),
      ),
    );
  }

  IconButton geriDonmeButon(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(userModel: widget.userModel),
            ),
          );
        },
        icon: const Icon(Icons.arrow_back));
  }
}
