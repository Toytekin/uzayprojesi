import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uzayprojesi/page/admin/a_home.dart';
import 'package:uzayprojesi/page/anket_doldurma/ank_home.dart';
import 'package:uzayprojesi/page/home/home_model.dart';
import 'package:uzayprojesi/page/home/tel_diyalog_widget.dart';
import 'package:uzayprojesi/page/odul/odul_animaasyon.dart';
import 'package:uzayprojesi/page/ulke_secme.dart';
import 'package:uzayprojesi/services/user_aouth.dart';
import 'package:uzayprojesi/util/constant/colors.dart';
import 'package:uzayprojesi/util/constant/image_yolu.dart';
import 'package:uzayprojesi/util/model/anket_model.dart';
import 'package:uzayprojesi/util/model/user_model.dart';
import 'package:uzayprojesi/util/widget/sbt_cart.dart';

// Kodunuzun devamı

class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  const HomeScreen({
    super.key,
    required this.userModel,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with HomeModel {
  List<AnketModel> anketlerim = [];

  @override
  void initState() {
    super.initState();
    verilerileriCek();
  }

  verilerileriCek() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
              child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Lottie.asset(AnimasyonLolu.instance.yildizlar),
              stream(context, size)
            ],
          )),
        ),
        floatingActionButton:
            showButton ? floatingButon(context) : const SizedBox(),
      ),
    );
  }

  StreamBuilder<UserModel?> stream(BuildContext context, Size size) {
    return StreamBuilder<UserModel?>(
      stream:
          context.read<FirebaseServices>().listenToActiveUser(usermodel.userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Veri yüklenene kadar bekleyin
          return const CircularProgressIndicator(); // veya başka bir yükleme göstergesi
        } else if (snapshot.hasError) {
          // Hata durumunda kullanıcıyı bilgilendirin
          return Text('Bir hata oluştu: ${snapshot.error}');
        } else {
          // Veri yüklendiyse, UserModel nesnesini alın
          var veri = snapshot.data;
          if (veri != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                appBar(size, veri, context),
                QrImageView(
                  semanticsLabel: 'Deneme',
                  backgroundColor: Colors.white,
                  data: karekodaVeriHazirla(usermodel),
                  version: QrVersions.auto,
                  size: size.height / 4,
                ),
                SizedBox(height: size.height * 0.05),
                SbtCard(title: isim, value: usermodel.userName),
                SbtCard(title: mail, value: usermodel.mail),
                telefon(veri, context),
                SbtCard(
                  title: ulke,
                  value: veri.vatandaslikTuru,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UlkeSecmeEkrani(
                          userModel: usermodel,
                        ),
                      ),
                    );
                  },
                ),
                SbtCard(
                  title: bekleyenAnket,
                  value: veri.bekleyenAnket.length.toString(),
                  anketVarmi: usermodel.bekleyenAnket.isEmpty ? false : true,
                  onTap: usermodel.bekleyenAnket.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnketHome(
                                anketModels: usermodel.bekleyenAnket,
                                userModel: usermodel,
                              ),
                            ),
                          );
                        },
                ),
                SbtCard(title: puan, value: veri.puan.toString()),
              ],
            );
          } else {
            return bosVeriGelirse(size);
          }
        }
      },
    );
  }

  SbtCard telefon(UserModel veri, BuildContext context) {
    return SbtCard(
      title: tel,
      value: veri.tel,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => TelDiyalog(
            controller: controller,
            onayPress: () async {
              if (controller.text.isNotEmpty) {
                Navigator.of(context).pop();
                await context
                    .read<FirebaseServices>()
                    .updateUserTel(usermodel.userID, controller.text);
                puanArttir();
              }
            },
          ),
        );
      },
    );
  }

  SizedBox appBar(Size size, UserModel? veri, BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height * 0.06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (veri!.adminMi == true)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdminHomeSayfasi(userModel: widget.userModel),
                  ),
                );
              },
              icon: const Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
              ),
            ),
          const Spacer(),
          restat(context),
          cikisButon(context)
        ],
      ),
    );
  }

  IconButton cikisButon(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await context.read<FirebaseServices>().outUser();
        },
        icon: const Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ));
  }

  FloatingActionButton floatingButon(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: SbtColor.yaziRenk,
      onPressed: () async {
        await context
            .read<FirebaseServices>()
            .updateUserPuan(usermodel.userID, 100, usermodel.puan);
        // ignore: use_build_context_synchronously
        animasyonluSayfayaGit(context);

        updateLastClicked();
      },
      child: Lottie.asset(AnimasyonLolu.instance.hediye, fit: BoxFit.contain),
    );
  }

  Center bosVeriGelirse(Size size) {
    return const Center(
      child: Text('Not Found'),
    );
  }

  IconButton restat(BuildContext context) {
    return IconButton(
        onPressed: () {
          setState(() {});
          context.read<FirebaseServices>().getUserModel();
        },
        icon: const Icon(
          Icons.restart_alt,
          color: Colors.white,
        ));
  }

  animasyonluSayfayaGit(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => OdulAnimasyon(userModel: widget.userModel),
        transitionsBuilder: (_, animation, __, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 4.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: child,
          );
        },
      ),
    );
  }
}
