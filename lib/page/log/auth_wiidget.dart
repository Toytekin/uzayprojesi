import 'package:flutter/material.dart';
import 'package:uzayprojesi/page/home/home.dart';
import 'package:uzayprojesi/page/log/login.dart';
import 'package:uzayprojesi/util/model/user_model.dart';

class AuthWidget extends StatelessWidget {
  final AsyncSnapshot<UserModel?> snapshot;
  const AuthWidget({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.active) {
      return snapshot.data != null
          ? HomeScreen(userModel: snapshot.data!)
          : const KayitEkrani();
    }
    return const ErrorPage();
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  final String _uyariText =
      'Beklenmedik bir hata oluştu. İnternet bağlantınızı kontrol edin';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(_uyariText),
          ),
        ),
      ),
    );
  }
}
