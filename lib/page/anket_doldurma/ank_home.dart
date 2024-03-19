import 'package:flutter/material.dart';
import 'package:uzayprojesi/page/anket_doldurma/anket_doldur.dart';
import 'package:uzayprojesi/page/home/home.dart';
import 'package:uzayprojesi/util/model/anket_model.dart';
import 'package:uzayprojesi/util/model/user_model.dart';

class AnketHome extends StatefulWidget {
  final List<AnketModel> anketModels;
  final UserModel userModel;
  const AnketHome({
    super.key,
    required this.anketModels,
    required this.userModel,
  });

  @override
  State<AnketHome> createState() => _AnketHomeState();
}

class _AnketHomeState extends State<AnketHome> {
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
          title: const Text(' All Surveys'),
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
        body: Center(
          child: ListView.builder(
            itemCount: widget.anketModels.length,
            itemBuilder: (context, index) {
              var data = widget.anketModels[index];
              return Card(
                child: ListTile(
                  leading: Text(
                    '${index + 1}',
                    style: const TextStyle(fontSize: 22),
                  ),
                  title: Text(data.title),
                  subtitle: Text(data.puanMiktari.toString()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnketDoldurSayfa(
                          anketModel: data,
                          userModel: widget.userModel,
                          anketModels: widget.anketModels,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
