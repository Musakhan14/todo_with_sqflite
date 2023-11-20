import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged; // Callback function for onChanged

  const AppTextField({
    required this.controller,
    required this.hintText,
    required this.onChanged, // Declare onChanged as required
    Key? key, // Key should be 'key' lowercase
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged, // Pass the provided onChanged callback
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class AppTextField extends StatelessWidget {
//   TextEditingController controller;
//   String hintText;
//
//
//   AppTextField({required this.controller, required this.hintText, super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       onChanged: (value) {
//
//       },
//       decoration: InputDecoration(
//           hintText: hintText,
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5.0))),
//     );
//   }
// }
