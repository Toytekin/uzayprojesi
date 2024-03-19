import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TelDiyalog extends StatelessWidget {
  TextEditingController controller;
  Function() onayPress;
  TelDiyalog({
    super.key,
    required this.controller,
    required this.onayPress,
  });

  final String title = 'Enter your phone number and confirm';
//11
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: [
        TextField(
          keyboardType: TextInputType.phone,
          controller: controller,
          maxLength: 11,
          decoration: const InputDecoration(
            hintText: 'Number',
            border: OutlineInputBorder(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: onayPress, child: const Text('OK')),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'))
          ],
        )
      ],
    );
  }
}
