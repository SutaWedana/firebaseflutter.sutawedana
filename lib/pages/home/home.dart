import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProfileSection(),
              const SizedBox(height: 20),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        // Gambar Profil dengan Animasi
        AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(seconds: 1),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              FirebaseAuth.instance.currentUser!.photoURL ??
                  'https://www.example.com/default-profile.jpg', // Gambar default jika tidak ada
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        // Nama Pengguna
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          child: Text(
            FirebaseAuth.instance.currentUser!.displayName ?? 'User Name',
          ),
        ),
        const SizedBox(height: 10),

        // Email Pengguna
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
          child: Text(
            FirebaseAuth.instance.currentUser!.email ?? 'Email not available',
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTap: () async {
            _controller.forward();
            await AuthService().signout(context: context);
          },
          onTapDown: (_) {
            _controller.forward();
          },
          onTapUp: (_) {
            _controller.reverse();
          },
          onTapCancel: () {
            _controller.reverse();
          },
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: const Size(double.infinity, 60),
                ),
                onPressed: () async {
                  await AuthService().signout(context: context);
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
