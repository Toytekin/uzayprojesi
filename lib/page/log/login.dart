import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:uzayprojesi/services/user_aouth.dart';
import 'package:uzayprojesi/util/constant/colors.dart';
import 'package:uzayprojesi/util/constant/image_yolu.dart';
import 'package:uzayprojesi/util/widget/fture_buton.dart';
import 'package:lottie/lottie.dart';

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool butonaTiklanmaDurumu = false;
  final String baslik = ' MARS';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //  var user = Provider.of<UserModelProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
              child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Lottie.asset(AnimasyonLolu.instance.yildizlar),
              SizedBox(
                height: size.height,
                width: size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: size.height * 0.1),
                    munevver(size),
                    SizedBox(height: size.height * 0.05),
                    resim(size),
                    SizedBox(height: size.height * 0.08),
                    const Spacer(),
                    SbtFutureButon(
                      label: 'Google İl Giriş',
                      press: () async {
                        await context.read<FirebaseServices>().userKayit();
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  LottieBuilder resim(Size size) {
    return LottieBuilder.asset(
      AnimasyonLolu.instance.girisAnimasyonu,
      height: size.height / 3,
      fit: BoxFit.fitHeight,
    );
  }

  Row munevver(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          baslik,
          style: GoogleFonts.kalam(
            textStyle: TextStyle(
              color: SbtColor.yaziRenk,
              fontSize: size.width / 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.05),
        Icon(
          Icons.pentagon_sharp,
          size: size.width / 14,
          color: SbtColor.anaRenk,
        )
      ],
    );
  }
}
