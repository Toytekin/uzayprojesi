import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uzayprojesi/page/odul/odul.dart';
import 'package:uzayprojesi/util/constant/image_yolu.dart';
import 'package:uzayprojesi/util/model/user_model.dart';

class OdulAnimasyon extends StatefulWidget {
  final UserModel userModel;

  const OdulAnimasyon({super.key, required this.userModel});

  @override
  State<OdulAnimasyon> createState() => _OdulAnimasyonState();
}

class _OdulAnimasyonState extends State<OdulAnimasyon> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 600), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OdulEkarani(
            userModel: widget.userModel,
            gosterilecekOdlMiktari: '100',
          ),
        ),
      );
    });
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
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Center(
          child: Hero(
            tag: 'icon',
            child: Lottie.asset(
              AnimasyonLolu.instance.hediye,
              height: size.height / 4,
            ),
          ),
        ),
      ),
    );
  }
}
