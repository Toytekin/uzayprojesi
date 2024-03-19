import 'package:flutter/material.dart';
import 'package:uzayprojesi/util/constant/colors.dart';
import 'package:uzayprojesi/util/constant/text_style.dart';

typedef FutureCallBack = Future<void> Function();

class SbtFutureButon extends StatefulWidget {
  final String label;
  final FutureCallBack press;
  const SbtFutureButon({
    super.key,
    required this.label,
    required this.press,
  }); // key parametresi düzeltildi

  @override
  State<SbtFutureButon> createState() => _SbtFutureButonState();
}

class _SbtFutureButonState extends State<SbtFutureButon> {
  bool _isLoading = false;

  _chancgeLoading() {
    if (mounted) {
      // Widget hala ağaçta mı kontrol ediliyor
      setState(() {
        _isLoading = !_isLoading;
      });
    }
  }

  Future<void> futureComplate() async {
    _chancgeLoading();
    await widget.press();
    _chancgeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: _isLoading ? null : futureComplate,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(98, 255, 255, 255),
          shape: StadiumBorder(side: BorderSide(color: SbtColor.anaRenk)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(widget.label, style: SbtTextStyle.miniStyle),
      ),
    );
  }
}
