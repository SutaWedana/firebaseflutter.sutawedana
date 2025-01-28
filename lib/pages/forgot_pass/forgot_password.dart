import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart'; // Import Lottie for JSON animation

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 5, 5, 5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 4, 4, 4)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE3FDFD), // Soft Light Blue
              Color(0xFFCBF1F5), // Soft Cyan
              Color(0xFFA6E3E9), // Soft Teal
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // Small Image using Lottie for JSON animation
            Lottie.asset(
              'assets/riset.json', // Path to your JSON animation
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'Enter your email address and we will send you a link to your email to reset your password.',
              style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87, // Dark text color for contrast
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                labelText: "Email Address",
                hintText: "Masukkan email anda!",
                labelStyle: GoogleFonts.raleway(),
                hintStyle: GoogleFonts.raleway(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (emailController.text.trim().isEmpty) {
                  showSnackBar(context, "Tolong input email anda!");
                  return;
                }
                try {
                  await auth.sendPasswordResetEmail(
                    email: emailController.text.trim(),
                  );
                  showSnackBar(
                    context,
                    "Link reset password telah dikirim ke email anda!",
                  );
                  Navigator.pop(context);
                } catch (error) {
                  showSnackBar(context, error.toString());
                }
              },
              child: Text(
                'Reset Password',
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s),
      ),
    );
  }
}
