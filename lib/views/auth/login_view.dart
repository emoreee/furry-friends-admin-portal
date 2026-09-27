import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import the Doctor Dashboard directly
import '../dashboard/doctor_dashboard.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // Role selection state: 'staff' or 'doctor'
  String _selectedRole = 'staff';

  Future<void> _handleSignIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // 1. Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Role Validation (Authorization Check)
      bool isAuthorized = false;

      // Logic A: Quick Validation base sa Email format
      if (_selectedRole == 'doctor' && email.contains('.doctor@')) {
        isAuthorized = true;
      } else if (_selectedRole == 'staff' &&
          (email.contains('.admin@') || email.contains('admin'))) {
        isAuthorized = true;
      }

      // Logic B: Firestore Database Validation
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userData = userQuery.docs.first.data();
        final userRole = (userData['role'] ?? '').toString().toLowerCase();

        if (_selectedRole == 'doctor' && userRole == 'doctor') {
          isAuthorized = true;
        } else if (_selectedRole == 'staff' &&
            (userRole == 'admin' || userRole == 'staff')) {
          isAuthorized = true;
        } else {
          isAuthorized = false;
        }
      }

      // 3. Reject at i-logout ang user kung hindi tugma ang role
      if (!isAuthorized) {
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMessage = _selectedRole == 'doctor'
              ? 'Access Denied: Ang account na ito ay hindi pang-Doctor.'
              : 'Access Denied: Ang account na ito ay hindi pang-Admin/Staff.';
        });
        return;
      }

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      // 4. UPDATED ROUTING: Direktang pag-route sa Main Dashboard
      if (_selectedRole == 'doctor') {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) =>
                const DoctorDashboardScreen(),
            transitionDuration: Duration.zero,
          ),
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/dashboard',
        ); // Pupunta sa Admin's Portal
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        if (e.code == 'user-not-found' || e.code == 'invalid-email') {
          _errorMessage = 'Walang nahanap na account para sa email na ito.';
        } else if (e.code == 'wrong-password' ||
            e.code == 'invalid-credential') {
          _errorMessage = 'Mali ang email o password. Subukan muli.';
        } else {
          _errorMessage = 'Authentication error: ${e.message}';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'May nangyaring hindi inaasahang error.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/clinic_lab_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF352090).withValues(alpha: 0.35),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 48,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Mas malaking logo nang walang circular background border
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/furryFriendsLogo.png',
                          width: 64,
                          height: 64,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.pets,
                              size: 54,
                              color: Color(0xFF352090),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Welcome back! Log in to access health monitoring tools and keep tails wagging at Furry Friends Animal Clinic.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF525252),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Role Selection Switcher
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedRole = 'staff'),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'staff'
                                        ? const Color(0xFF352090)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Clinic Staff',
                                    style: TextStyle(
                                      color: _selectedRole == 'staff'
                                          ? Colors.white
                                          : const Color(0xFF64748B),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedRole = 'doctor'),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'doctor'
                                        ? const Color(0xFF352090)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Doctor',
                                    style: TextStyle(
                                      color: _selectedRole == 'doctor'
                                          ? Colors.white
                                          : const Color(0xFF64748B),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFF525252),
                          ),
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Color(0xFF525252)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Color(0xFF352090),
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your email' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF525252),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF525252),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Color(0xFF525252)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Color(0xFF352090),
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your password'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF525252),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF352090),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: _isLoading ? null : _handleSignIn,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  _selectedRole == 'doctor'
                                      ? 'Log In as Doctor'
                                      : 'Log In as Clinic Staff',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
