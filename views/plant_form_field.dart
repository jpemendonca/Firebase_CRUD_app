import 'package:flutter/material.dart';

// Esse é apenas um widget que fiz para tornar mais fácil a leitura dos textField
// que aparecem ao criar ou editar um objeto.
// Ele apenas retorna um TextFormField

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.label,
    this.hintText,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.suffix,
    required this.controller,
  }) : super(key: key);
  final String? label;
  final String? hintText;
  final Widget? suffix;
  final TextEditingController controller;

  final String? Function(String? text)? validator;
  final void Function(String? text)? onSaved;
  final void Function(String text)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onSaved: onSaved,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        suffixIcon: suffix,
        labelText: label,
        hintText: hintText,
        // ignore: unnecessary_null_comparison
      ),
    );
  }
}
