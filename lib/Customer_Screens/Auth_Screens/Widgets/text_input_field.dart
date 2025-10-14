import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const TextInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Colors.grey[500],
                size: 20,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(
          fontSize: 12,
          height: 1.0,  // controls how much vertical space error text takes
        ),
        // reduce space between error and field
        errorMaxLines: 2,
        isDense: true,
      ),
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class TextInputField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final IconData? prefixIcon;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;

//   const TextInputField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     this.prefixIcon,
//     this.keyboardType = TextInputType.text,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         validator: validator,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: hintText,
//           hintStyle: TextStyle(
//             color: Colors.grey[500],
//             fontSize: 14,
//           ),
//           prefixIcon: prefixIcon != null
//               ? Icon(
//                   prefixIcon,
//                   color: Colors.grey[500],
//                   size: 20,
//                 )
//               : null,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 16,
//           ),
//         ),
//         style: const TextStyle(
//           fontSize: 16,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
// }