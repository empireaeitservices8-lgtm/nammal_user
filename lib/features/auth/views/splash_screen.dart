import 'package:flutter/material.dart';
import '../../../core/config/app_colors.dart';
import 'widgets/auth_widgets.dart';
import 'phone_login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              children: [
                const Spacer(flex: 3),

                // Center Logo & Tagline
                const Text(
                  'nammal',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Connecting you with verified agents instantly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),

                const Spacer(flex: 4),

                // Action Buttons
                PrimaryButton(
                  text: 'Create Account',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PhoneLoginScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                SecondaryButton(
                  text: 'I already have an account / Log in',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PhoneLoginScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Footer
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
