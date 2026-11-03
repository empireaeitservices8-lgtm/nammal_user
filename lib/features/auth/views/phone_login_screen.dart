import 'package:flutter/material.dart';
import '../../../core/config/app_colors.dart';
import 'widgets/auth_widgets.dart';
import 'otp_verification_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+91';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final phoneNumber = _phoneController.text.trim();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(
          phoneNumber: '$_selectedCountryCode $phoneNumber',
        ),
      ),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 36),

                // Title & Subtitle
                const Text(
                  'Enter your mobile number',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'We will send a code to verify your number',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 36),

                // Phone Input Pill
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Country Code Selector
                      InkWell(
                        onTap: () {
                          // Placeholder for country picker
                        },
                        child: Row(
                          children: [
                            Text(
                              _selectedCountryCode,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.textPrimary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Vertical Divider
                      Container(
                        width: 1,
                        height: 28,
                        color: AppColors.borderSubtle,
                      ),
                      const SizedBox(width: 14),

                      // Number Input Field
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '00000-00000',
                            hintStyle: TextStyle(
                              color: AppColors.textPlaceholder,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Submit Button
                PrimaryButton(
                  text: 'Send Verification Code',
                  onPressed: _onContinue,
                ),
                const SizedBox(height: 18),

                // Privacy Trust Badge
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'We never share your number or spam you.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Legal Disclaimer
                const TermsFooter(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
