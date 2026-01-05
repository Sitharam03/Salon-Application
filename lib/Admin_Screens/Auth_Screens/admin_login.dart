import 'package:flutter/material.dart';
import 'package:salon/Admin_Screens/Auth_Screens/admin_otp.dart';
import 'package:salon/Customer_Screens/Auth_Screens/login.dart';
import 'package:salon/Customer_Screens/Auth_Screens/Widgets/app_header.dart';
import 'package:salon/Customer_Screens/Auth_Screens/Widgets/button.dart';
import 'package:salon/Customer_Screens/Auth_Screens/Widgets/phonenumber.dart';
import 'package:salon/Customer_Screens/Auth_Screens/Widgets/termscheckbox.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      _showSnackBar('Please enter a valid email address');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate login
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        // Navigate to success or home
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _goToVendorSignup() {
    Navigator.pushNamed(context, '/admin/signup');
  }

  void _goToCustomerLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'India\'s 1st',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Salon',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE22424),
                  ),
                ),
                const Text(
                  'Application',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E232C),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Become a Vendor/Service Provider',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please enter your details to continue',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Email Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                      hintText: 'Email Address',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      hintText: 'Password',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/admin/forgot-password'),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFFE22424),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE22424),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              const SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _goToVendorSignup,
                      child: Text(
                        'Sign up as Vendor?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[600],
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _goToCustomerLogin,
                      child: Text(
                        'Back to user login',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[600],
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
    
  }
}
