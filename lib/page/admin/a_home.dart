import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uzayprojesi/page/admin/anket_olustur.dart';
import 'package:uzayprojesi/page/home/home.dart';
import 'package:uzayprojesi/services/user_aouth.dart';
import 'package:uzayprojesi/util/model/anket_model.dart';
import 'package:uzayprojesi/util/model/user_model.dart';

class AdminHomeSayfasi extends StatefulWidget {
  final UserModel userModel;
  const AdminHomeSayfasi({
    super.key,
    required this.userModel,
  });

  @override
  State<AdminHomeSayfasi> createState() => _AdminHomeSayfasiState();
}

class _AdminHomeSayfasiState extends State<AdminHomeSayfasi> {
  final String hataMesaji = 'Not Found';
  final String answers = 'Answers';
  final String points = 'Point';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(userModel: widget.userModel),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SafeArea(
          child: Center(
            child: stream(context, size),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AnketOlustur(
                        userModel: widget.userModel,
                      )),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget stream(BuildContext context, Size size) {
    return StreamBuilder<List<AnketModel>>(
      stream: context.read<FirebaseServices>().getAnketlerStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Veri yüklenirken gösterilecek widget
        } else if (snapshot.hasError) {
          return Text(
              'Hata: ${snapshot.error}'); // Hata durumunda gösterilecek widget
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(
              child:
                  Text(hataMesaji)); // Veri yoksa veya boşsa hata mesajı göster
        } else {
          return Expanded(
            // ListView.builder'ı Expanded widget'ine sardık
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var veri = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: Text(
                      '${index + 1}',
                      style: TextStyle(fontSize: size.width * 0.05),
                    ),
                    title: Text(
                      veri.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: subtitile(veri),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnketOlustur(
                              anketModel: veri, userModel: widget.userModel),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Row subtitile(AnketModel veri) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          answers,
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
        Text(veri.dolduranUserLar.length.toString()),
        const Spacer(),
        Text(
          points,
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
        Text(veri.puanMiktari.toString())
      ],
    );
  }
}
