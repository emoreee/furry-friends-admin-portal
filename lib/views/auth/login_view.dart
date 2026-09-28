import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math'; // Ginagamit para sa random code generation

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

  // Hardcoded Capstone Demo Number
  final String _demoPhoneNumber = "09933460491";

  // ==========================================
  // ROUTING LOGIC
  // ==========================================
  void _routeToDashboard() {
    if (_selectedRole == 'doctor') {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const DoctorDashboardScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/dashboard',
      ); // Pupunta sa Admin's Portal
    }
  }

  // ==========================================
  // 2FA / OTP POPUP DIALOG (WITH SIMULATED AUTHENTICATION)
  // ==========================================
  void _showOTPAuthDialog(
    BuildContext context,
    String email,
    String expectedOTP,
  ) {
    final TextEditingController otpController = TextEditingController();
    bool isVerifying = false;
    String? dialogError;

    // Function to handle the OTP verification logic
    Future<void> handleVerification(Function setDialogState) async {
      final smsCode = otpController.text.trim();

      if (smsCode.length < 6) {
        setDialogState(() {
          dialogError = 'Please enter the complete 6-digit code.';
        });
        return;
      }

      setDialogState(() {
        isVerifying = true;
        dialogError = null;
      });

      // Simulated Delay para mukhang kumokonekta sa server
      await Future.delayed(const Duration(seconds: 1));

      // STRICT VERIFICATION LOGIC:
      if (smsCode != expectedOTP) {
        setDialogState(() {
          isVerifying = false;
          dialogError = 'Invalid authentication code. Please try again.';
        });
        return;
      }

      if (!context.mounted) return;

      // Close the dialog kung tama ang code
      Navigator.pop(context);

      // Tuloy na sa pag-route papunta sa Dashboard
      _routeToDashboard();
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Bawal i-click ang labas para ma-close
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 10,
              backgroundColor: Colors.white,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 440),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF352090,
                            ).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.security_rounded,
                            color: Color(0xFF352090),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Two-Step Verification',
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Additional security check',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFE2E8F0), height: 1),
                    const SizedBox(height: 20),

                    Text(
                      'To protect the clinic\'s data, an authentication code has been sent to your registered contact ($_demoPhoneNumber). Please enter the 6-digit code below to proceed.',
                      style: const TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        if (!isVerifying) handleVerification(setDialogState);
                      },
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      style: const TextStyle(
                        fontSize: 24,
                        letterSpacing: 8,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '••••••',
                        hintStyle: const TextStyle(
                          color: Color(0xFFCBD5E1),
                          letterSpacing: 8,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFCBD5E1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF352090),
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),

                    if (dialogError != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 16,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                dialogError!,
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: isVerifying
                              ? null
                              : () {
                                  FirebaseAuth.instance
                                      .signOut(); // I-logout kung kinancel
                                  Navigator.pop(dialogContext);
                                },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: isVerifying
                              ? null
                              : () => handleVerification(setDialogState),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF352090),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                          ),
                          child: isVerifying
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Verify & Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // FORGOT PASSWORD POPUP DIALOG
  // ==========================================
  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController resetEmailController = TextEditingController();
    bool isSending = false;
    String? dialogMessage;
    bool isSuccess = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 10,
              backgroundColor: Colors.white,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 440),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF352090,
                            ).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_reset_rounded,
                            color: Color(0xFF352090),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reset Password',
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Recover your account access',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFE2E8F0), height: 1),
                    const SizedBox(height: 20),

                    const Text(
                      'Enter your registered email address below. We will send you a secure link to reset your password.',
                      style: TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: resetEmailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                        hintText: 'e.g., admin@furryfriends.com',
                        hintStyle: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          size: 20,
                          color: Color(0xFF64748B),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFCBD5E1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFCBD5E1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF352090),
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),

                    if (dialogMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSuccess
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSuccess
                                ? Colors.green.shade200
                                : Colors.red.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSuccess
                                  ? Icons.check_circle_outline
                                  : Icons.error_outline,
                              size: 16,
                              color: isSuccess
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                dialogMessage!,
                                style: TextStyle(
                                  color: isSuccess
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: isSending
                              ? null
                              : () => Navigator.pop(dialogContext),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: isSending
                              ? null
                              : () async {
                                  final email = resetEmailController.text
                                      .trim();
                                  if (email.isEmpty) {
                                    setDialogState(() {
                                      isSuccess = false;
                                      dialogMessage =
                                          'Please enter your email address.';
                                    });
                                    return;
                                  }

                                  setDialogState(() {
                                    isSending = true;
                                    dialogMessage = null;
                                  });

                                  try {
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(email: email);
                                    setDialogState(() {
                                      isSending = false;
                                      isSuccess = true;
                                      dialogMessage =
                                          'Password reset link sent! Check your email inbox.';
                                    });
                                  } catch (e) {
                                    setDialogState(() {
                                      isSending = false;
                                      isSuccess = false;
                                      dialogMessage =
                                          'Error: Could not send reset email. Please try again.';
                                    });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF352090),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                          ),
                          child: isSending
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Send Reset Link',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // MAIN SIGN IN HANDLER
  // ==========================================
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
      try {
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
      } catch (e) {
        // Fallback to Logic A if Firestore fails
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

      // 4. GENERATE RANDOM 6-DIGIT OTP
      final String generatedOTP = (Random().nextInt(900000) + 100000)
          .toString();

      // 5. SHOW SIMULATED SMS NOTIFICATION WITH YOUR SPECIFIC NUMBER
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.mark_email_unread_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Message sent to $_demoPhoneNumber: Your Furry Friends Clinic verification code is $generatedOTP.',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(
            0xFF183F82,
          ), // Corporate Blue color para mas professional
          duration: const Duration(
            seconds: 12,
          ), // Matagal mawala para makita ng judges
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // 6. SHOW THE 2FA POPUP DIALOG WITH THE EXPECTED OTP
      _showOTPAuthDialog(context, email, generatedOTP);
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
                        textInputAction: TextInputAction.next,
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
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          if (!_isLoading) {
                            _handleSignIn();
                          }
                        },
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
                          onPressed: () => _showForgotPasswordDialog(context),
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
