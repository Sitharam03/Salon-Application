import 'package:flutter/material.dart';
import 'package:salon/app/core/values/app_colors.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "India's 1st",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Salon\n",
                style: TextStyle(
                  color: Color(0xFFE22424),
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              TextSpan(
                text: "Application",
                style: TextStyle(
                  color: Color(0xFF1E232C),
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
