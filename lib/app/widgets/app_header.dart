import 'package:flutter/material.dart';
import 'package:salon/app/core/values/app_colors.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: "India's 1st\n",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: "Salon\n",
              style: TextStyle(
                color: AppColors.primaryAlt,
                fontSize: 40,
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(
              text: "Application",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
