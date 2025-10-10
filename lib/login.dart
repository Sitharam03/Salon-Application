import 'package:flutter/material.dart';

class LoginScren extends StatelessWidget {
  const LoginScren({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "India’s 1st\n",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(
                    text: "Salon\n",
                    style: TextStyle(
                      color: Color.fromRGBO(226, 36, 36, 1.0),
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
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
          ),
        ],
      ),
    );
  }
}
