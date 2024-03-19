import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SbtTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int satirSayisi;
  final bool klvyeTipi;
  const SbtTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.satirSayisi = 1,
    this.klvyeTipi = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        keyboardType:
            klvyeTipi ? TextInputType.multiline : TextInputType.number,
        inputFormatters: klvyeTipi
            ? null
            : <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
        maxLines: satirSayisi,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color.fromARGB(190, 255, 255, 255),
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
