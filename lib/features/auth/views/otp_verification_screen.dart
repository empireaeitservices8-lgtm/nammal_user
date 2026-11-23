import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/config/app_colors.dart';
import 'widgets/auth_widgets.dart';
import 'user_onboarding_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, this.phoneNumber = '+91 9876543210'});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _enteredOtp = '';
  int _secondsRemaining = 45;
  Timer? _timer;
  bool _isVerifying = false;
  bool _hasError = false;
  String? _errorMessage;

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
    if (_isVerifying) return;

    if (_enteredOtp.length < 4) {
      setState(() {
        _hasError = false;
        _errorMessage = null;
        _enteredOtp += value;
      });

      // Auto verify when 4th digit is entered
      if (_enteredOtp.length == 4) {
        _onVerify();
      }
    }
  }

  void _onBackspace() {
    if (_isVerifying) return;

    if (_enteredOtp.isNotEmpty) {
      setState(() {
        _hasError = false;
        _errorMessage = null;
        _enteredOtp = _enteredOtp.substring(0, _enteredOtp.length - 1);
      });
    }
  }

  void _onClear() {
    if (_isVerifying) return;

    setState(() {
      _hasError = false;
      _errorMessage = null;
      _enteredOtp = '';
    });
  }

  void _resendCode() {
    if (_secondsRemaining > 0) return;

    setState(() {
      _enteredOtp = '';
      _hasError = false;
      _errorMessage = null;
    });
    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'A new 4-digit code has been sent to ${widget.phoneNumber}',
        ),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onVerify() async {
    if (_isVerifying) return;

    // Validation: check complete 4 digits
    if (_enteredOtp.length != 4) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Please enter all 4 digits of the verification code';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 4 digits of the verification code'),
          backgroundColor: Color(0xFFEF4444),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
      _hasError = false;
      _errorMessage = null;
    });

    // Simulated short verification latency
    await Future.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;

    setState(() {
      _isVerifying = false;
    });

    // Navigate to Onboarding screen
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const UserOnboardingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NammalHeader(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.screenGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

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
                      const SizedBox(height: 8),

                      // Subtitle with phone number and edit button
                      Row(
                        children: [
                          Text(
                            'Sent to ${widget.phoneNumber}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Edit',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
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
                                final digit = isFilled
                                    ? _enteredOtp[index]
                                    : '';

                                Color boxBorderColor;
                                double boxBorderWidth = 1.5;

                                if (_hasError) {
                                  boxBorderColor = const Color(0xFFEF4444);
                                  boxBorderWidth = 1.8;
                                } else if (isActive) {
                                  boxBorderColor = AppColors.primary;
                                  boxBorderWidth = 2.0;
                                } else if (isFilled) {
                                  boxBorderColor = AppColors.primary.withValues(
                                    alpha: 0.5,
                                  );
                                } else {
                                  boxBorderColor = AppColors.borderSubtle;
                                }

                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 62,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: boxBorderColor,
                                      width: boxBorderWidth,
                                    ),
                                    boxShadow: isActive
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.15),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : null,
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
                                                  color: _hasError
                                                      ? const Color(0xFFEF4444)
                                                      : AppColors.primary,
                                                )
                                              : null),
                                  ),
                                );
                              }),
                            ),

                            // Error Message Banner
                            if (_hasError) ...[
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    color: Color(0xFFEF4444),
                                    size: 15,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _errorMessage ??
                                        'Please enter the complete 4-digit code',
                                    style: const TextStyle(
                                      color: Color(0xFFEF4444),
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],

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
                                      ? _resendCode
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
                            _buildKeypadRow(
                              ['1', '2', '3'],
                              ['', 'ABC', 'DEF'],
                            ),
                            const SizedBox(height: 12),
                            _buildKeypadRow(
                              ['4', '5', '6'],
                              ['GHI', 'JKL', 'MNO'],
                            ),
                            const SizedBox(height: 12),
                            _buildKeypadRow(
                              ['7', '8', '9'],
                              ['PQRS', 'TUV', 'WXYZ'],
                            ),
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
                  text: _isVerifying ? 'Verifying...' : 'Verify & Continue',
                  onPressed: _isVerifying ? null : _onVerify,
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
