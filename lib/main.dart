import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:uzayprojesi/firebase_options.dart';
import 'package:uzayprojesi/page/log/auth_widget_buildder.dart';
import 'package:uzayprojesi/page/log/auth_wiidget.dart';
import 'package:uzayprojesi/services/user_aouth.dart';
import 'package:uzayprojesi/util/constant/theme.dart';

Future<void> main() async {
// Hive Veri Tabanı

  //Firebase Yapısı
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FirebaseServices()),
        ],
        child: AuthWidgetBuilder(
          onPageBuilder: (context, snapshot) => MaterialApp(
            theme: SbtTema.temam,
            debugShowCheckedModeBanner: false,
            home: AuthWidget(snapshot: snapshot),
          ),
        ));
  }
}
