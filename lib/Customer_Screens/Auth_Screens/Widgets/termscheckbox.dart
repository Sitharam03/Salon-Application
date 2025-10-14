import 'package:flutter/material.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onLearnMore;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color.fromRGBO(226, 36, 36, 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onLearnMore,
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'I agree ',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  TextSpan(
                    text: 'Terms and Conditions.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      // decoration: TextDecoration.underline,
                    ),
                  ),
                  // const TextSpan(
                  //   text: ' . ',
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     color: Colors.red,
                  //   ),
                  // ),
                  TextSpan(
                    text: 'Learn more',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[600],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
