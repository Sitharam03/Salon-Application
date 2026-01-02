import 'package:flutter/material.dart';
import 'package:salon/app/core/values/app_colors.dart';

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
            activeColor: AppColors.primaryAlt,
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
                  const TextSpan(
                    text: 'Terms and Conditions.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
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
