import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SbtCard extends StatelessWidget {
  final String title;
  final String value;
  Function()? onTap;
  bool anketVarmi;
  SbtCard({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
    this.anketVarmi = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: anketVarmi
          ? const Color.fromARGB(143, 184, 235, 186)
          : const Color.fromARGB(133, 255, 255, 255),
      child: ListTile(
        trailing: value.isEmpty
            ? const Icon(
                Icons.star,
                color: Colors.red,
              )
            : null,
        onTap: onTap,
        title: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(value),
          ],
        ),
      ),
    );
  }
}
