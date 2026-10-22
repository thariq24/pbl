
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E1F1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // Tombol kembali
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D2B4F),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // First Name dan Last Name
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      label: 'First Name',
                      hint: 'Nama depan',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildField(
                      label: 'Last Name',
                      hint: 'Nama belakang',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _buildField(
                label: 'E-mail',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 14),

              _buildField(
                label: 'Password',
                hint: 'Enter your password',
                obscureText: true,
              ),

              const SizedBox(height: 5),

              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  'Must contain 8 characters.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF52617D),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              _buildField(
                label: 'Confirm Password',
                hint: 'Confirm your password',
                obscureText: true,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    // Nanti kita sambungkan ke proses registrasi
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D2B4F),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF1D2B4F),
                    ),
                    children: [
                      const TextSpan(
                        text: 'By continuing, you agree to our ',
                      ),
                      TextSpan(
                        text: 'Terms of Service',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' and\n'),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF1D2B4F),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 42,
          child: TextField(
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Color(0xFF8B99B2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: Color(0xFF52617D),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: Color(0xFF52617D),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
