import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/nexaplay_logo.dart';
import '../widgets/tv_focusable.dart';
import '../presentation/widgets/inputs/tv_num_keypad.dart';
import '../services/app_state.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;
  final VoidCallback? onGuestDemo;

  const AuthScreen({
    super.key,
    required this.onAuthenticated,
    this.onGuestDemo,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isOtpStep = false;
  final TextEditingController _phoneController =
      TextEditingController(text: '98765 43210');
  String _enteredOtp = '';
  int _resendTimer = 30;
  Timer? _timer;

  @override
  void dispose() {
    _phoneController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendTimer = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        t.cancel();
      }
    });
  }

  void _goToOtp() {
    setState(() => _isOtpStep = true);
    _startTimer();
  }

  void _appendOtpDigit(String digit) {
    if (_enteredOtp.length < 6) {
      setState(() {
        _enteredOtp += digit;
      });
      if (_enteredOtp.length == 6) {
        _verifyOtp();
      }
    }
  }

  void _backspaceOtp() {
    if (_enteredOtp.isNotEmpty) {
      setState(() {
        _enteredOtp = _enteredOtp.substring(0, _enteredOtp.length - 1);
      });
    }
  }

  void _verifyOtp() {
    AppState().login('+91 ${_phoneController.text}');
    widget.onAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTV = size.width > 700;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Ambient Glow
          Positioned(
            top: -100,
            left: size.width * 0.25,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryPurple.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Top Header (Logo + Guest Skip per PDF rule: do not force login before browsing)
          Positioned(
            top: 24,
            left: isTV ? 48 : 20,
            right: isTV ? 48 : 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const NexaPlayLogo(size: 36, fontSize: 22),
                TVFocusable(
                  onPressed: widget.onGuestDemo ?? widget.onAuthenticated,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                    child: Text(
                      'Browse as Guest',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.accentCyan,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Center Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isTV ? 480 : 380),
                child: _isOtpStep ? _buildOtpView(isTV) : _buildLoginView(isTV),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginView(bool isTV) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Welcome Back',
          style: GoogleFonts.outfit(
            fontSize: isTV ? 32 : 26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to access your profiles, watchlist and history',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Phone Input Container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: Row(
            children: [
              Text(
                '🇮🇳 +91',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Container(width: 1, height: 24, color: Colors.white24),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Mobile Number',
                    hintStyle: TextStyle(color: AppTheme.textMuted),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Continue Button
        TVFocusable(
          autoFocus: true,
          onPressed: _goToOtp,
          borderRadius: BorderRadius.circular(12),
          scaleFactor: 1.05,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: AppTheme.brandGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Continue',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.15))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'or',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.15))),
          ],
        ),
        const SizedBox(height: 20),

        // Social Buttons
        _buildSocialButton(Icons.g_mobiledata_rounded, 'Continue with Google'),
        const SizedBox(height: 12),
        _buildSocialButton(Icons.apple_rounded, 'Continue with Apple'),
        const SizedBox(height: 12),
        _buildSocialButton(Icons.mail_outline_rounded, 'Continue with Email'),
        const SizedBox(height: 28),

        // Terms
        Text(
          'By continuing, you agree to our Terms & Privacy Policy',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpView(bool isTV) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Enter OTP',
          style: GoogleFonts.outfit(
            fontSize: isTV ? 32 : 26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We have sent a 6-digit code to +91 ${_phoneController.text}',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 24),

        // 6 Digit Display Boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) {
            final hasDigit = index < _enteredOtp.length;
            final char = hasDigit ? _enteredOtp[index] : '';
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: isTV ? 48 : 42,
              height: isTV ? 56 : 50,
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: hasDigit ? AppTheme.primaryViolet : Colors.white24,
                  width: hasDigit ? 2 : 1,
                ),
                boxShadow: hasDigit
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryViolet.withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  char,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),

        // Resend Timer
        Text(
          _resendTimer > 0
              ? 'Resend OTP in 00:${_resendTimer.toString().padLeft(2, '0')}'
              : 'Didn\'t receive code? Resend Now',
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: _resendTimer > 0 ? AppTheme.textMuted : AppTheme.accentCyan,
            fontWeight: _resendTimer > 0 ? FontWeight.normal : FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),

        // On-screen TV Keypad
        TvNumKeypad(
          isTV: isTV,
          onDigit: _appendOtpDigit,
          onBackspace: _backspaceOtp,
          onClear: () => setState(() => _enteredOtp = ''),
        ),
        const SizedBox(height: 18),

        // Back to Phone
        TextButton(
          onPressed: () => setState(() => _isOtpStep = false),
          child: Text(
            'Change Mobile Number',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return TVFocusable(
      onPressed: () {
        AppState().login('user@nexaplay.tv');
        widget.onAuthenticated();
      },
      borderRadius: BorderRadius.circular(10),
      scaleFactor: 1.04,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white12, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
