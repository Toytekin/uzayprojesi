import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uzayprojesi/page/admin/anket_olustur.dart';
import 'package:uzayprojesi/services/user_aouth.dart';
import 'package:uzayprojesi/util/model/anket_model.dart';

class AdminHomeSayfasi extends StatefulWidget {
  const AdminHomeSayfasi({super.key});

  @override
  State<AdminHomeSayfasi> createState() => _AdminHomeSayfasiState();
}

class _AdminHomeSayfasiState extends State<AdminHomeSayfasi> {
  final String hataMesaji = 'Not Found';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(child: Center(child: stream(context, size))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AnketOlustur()),
          );
        },
        child: const Icon(Icons.add),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnketOlustur(anketModel: veri),
                        ),
                      );
                    },
                    title: Text(veri.title),
                    subtitle: Text(veri.puanMiktari.toString()),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
