import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/config/app_colors.dart';
import 'widgets/auth_widgets.dart';
import 'user_onboarding_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    this.phoneNumber = '+91 9876543210',
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _enteredOtp = '582'; // Pre-filled with 3 digits to match design demo
  int _secondsRemaining = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 45;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onKeyPress(String value) {
    if (_enteredOtp.length < 4) {
      setState(() {
        _enteredOtp += value;
      });
    }
  }

  void _onBackspace() {
    if (_enteredOtp.isNotEmpty) {
      setState(() {
        _enteredOtp = _enteredOtp.substring(0, _enteredOtp.length - 1);
      });
    }
  }

  void _onClear() {
    setState(() {
      _enteredOtp = '';
    });
  }

  void _onVerify() {
    // Navigate to Onboarding screen (name, age, gender)
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const UserOnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NammalHeader(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.screenGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // Title
                      const Text(
                        'Enter verification code',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // OTP Boxes Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // 4 Digit Boxes
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(4, (index) {
                                final isFilled = index < _enteredOtp.length;
                                final isActive = index == _enteredOtp.length;
                                final digit = isFilled ? _enteredOtp[index] : '';

                                return Container(
                                  width: 62,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isActive
                                          ? AppColors.primary
                                          : (isFilled
                                              ? AppColors.primary.withValues(alpha: 0.4)
                                              : AppColors.borderSubtle),
                                      width: isActive ? 2.0 : 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: isFilled
                                        ? Text(
                                            digit,
                                            style: const TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 28,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )
                                        : (isActive
                                            ? Container(
                                                width: 2,
                                                height: 30,
                                                color: AppColors.primary,
                                              )
                                            : null),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 20),

                            // Timer & Resend
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.refresh,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Resend in 00:${_secondsRemaining.toString().padLeft(2, '0')}',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: _secondsRemaining == 0
                                      ? _startTimer
                                      : null,
                                  child: Text(
                                    'Resend now',
                                    style: TextStyle(
                                      color: _secondsRemaining == 0
                                          ? AppColors.primary
                                          : AppColors.textMuted,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Dial Pad Card
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildKeypadRow(['1', '2', '3'], ['', 'ABC', 'DEF']),
                            const SizedBox(height: 12),
                            _buildKeypadRow(['4', '5', '6'], ['GHI', 'JKL', 'MNO']),
                            const SizedBox(height: 12),
                            _buildKeypadRow(['7', '8', '9'], ['PQRS', 'TUV', 'WXYZ']),
                            const SizedBox(height: 12),
                            _buildBottomKeypadRow(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Bottom Verify Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: PrimaryButton(
                  text: 'Verify & Continue',
                  onPressed: _enteredOtp.length == 4 ? _onVerify : _onVerify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> digits, List<String> subtitles) {
    return Row(
      children: List.generate(3, (i) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _buildDialKey(
              digit: digits[i],
              subtitle: subtitles[i],
              onTap: () => _onKeyPress(digits[i]),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBottomKeypadRow() {
    return Row(
      children: [
        // Clear Key
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _onClear,
              child: Container(
                height: 56,
                alignment: Alignment.center,
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        // 0 Key
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _buildDialKey(
              digit: '0',
              subtitle: '+',
              onTap: () => _onKeyPress('0'),
            ),
          ),
        ),
        // Backspace Key
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _onBackspace,
              child: Container(
                height: 56,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.backspace_outlined,
                  color: AppColors.textPrimary,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialKey({
    required String digit,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.keypadButtonBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                digit,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
