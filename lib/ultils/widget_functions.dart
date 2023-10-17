import 'package:flutter/material.dart';

showMsg(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

showSingleTextFieldDialog({
  required BuildContext context,
  required String title,
  required String hint,
  TextInputType inputType = TextInputType.name,
  String positiveBtnText = 'SAVE',
  String negativeBtnText = 'CANCEL',
  required Function(String) onSave,
}) {
  final controller = TextEditingController();
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
            title: Text(
              title,
              style: const TextStyle(color: Colors.lightGreenAccent),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                keyboardType: inputType,
                decoration: InputDecoration(
                  hintText: hint,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  negativeBtnText,
                  style: const TextStyle(color: Colors.lightGreenAccent),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                ),
                onPressed: () {
                  if (controller.text.isEmpty) {
                    return;
                  }
                  Navigator.pop(context);
                  onSave(controller.text);
                },
                child: Text(
                  positiveBtnText,
                  style: const TextStyle(color: Colors.purple),
                ),
              ),
            ],
            backgroundColor: Colors.green,
          ));
}
