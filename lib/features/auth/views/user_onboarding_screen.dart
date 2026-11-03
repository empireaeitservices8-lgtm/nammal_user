import 'package:flutter/material.dart';
import '../../../core/config/app_colors.dart';
import '../../home/views/home_screen.dart';
import 'widgets/auth_widgets.dart';

class UserOnboardingScreen extends StatefulWidget {
  const UserOnboardingScreen({super.key});

  @override
  State<UserOnboardingScreen> createState() => _UserOnboardingScreenState();
}

class _UserOnboardingScreenState extends State<UserOnboardingScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Elena');
  final TextEditingController _dayController = TextEditingController(text: '14');
  final TextEditingController _monthController = TextEditingController(text: '08');
  final TextEditingController _yearController = TextEditingController(text: '2000');

  String _selectedGender = 'Woman';

  @override
  void dispose() {
    _nameController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _onNext() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Titles
                      const Text(
                        'Tell us about yourself',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This is how you will appear to potential connections on nammal.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Card 1: What is your first name?
                      _buildSectionCard(
                        title: 'What is your first name?',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              decoration: BoxDecoration(
                                color: AppColors.keypadButtonBg,
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _nameController,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter your name',
                                        hintStyle: TextStyle(
                                          color: AppColors.textPlaceholder,
                                        ),
                                      ),
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  if (_nameController.text.trim().isNotEmpty)
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.textMuted,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "You won't be able to change this later",
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Card 2: Date of Birth
                      _buildSectionCard(
                        title: 'Your Date of Birth',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDobField(
                                    label: 'Day',
                                    controller: _dayController,
                                    maxLength: 2,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildDobField(
                                    label: 'Month',
                                    controller: _monthController,
                                    maxLength: 2,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: _buildDobField(
                                    label: 'Year',
                                    controller: _yearController,
                                    maxLength: 4,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Your age is displayed on your profile. We do not show your full birthdate.',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Card 3: Gender identity
                      _buildSectionCard(
                        title: 'Gender identity',
                        subtitle: 'Select the option that best reflects you',
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildGenderOption(
                                title: 'Woman',
                                isSelected: _selectedGender == 'Woman',
                                onSelect: () => setState(() => _selectedGender = 'Woman'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildGenderOption(
                                title: 'Man',
                                isSelected: _selectedGender == 'Man',
                                onSelect: () => setState(() => _selectedGender = 'Man'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: PrimaryButton(
                  text: 'Next',
                  onPressed: _onNext,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDobField({
    required String label,
    required TextEditingController controller,
    required int maxLength,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.keypadButtonBg,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: maxLength,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption({
    required String title,
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.keypadButtonBg,
          borderRadius: BorderRadius.circular(28),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
