import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/config/app_colors.dart';
import '../../home/views/home_screen.dart';
import 'widgets/auth_widgets.dart';

class UserOnboardingScreen extends StatefulWidget {
  const UserOnboardingScreen({super.key});

  @override
  State<UserOnboardingScreen> createState() => _UserOnboardingScreenState();
}

class _UserOnboardingScreenState extends State<UserOnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  final FocusNode _dayFocus = FocusNode();
  final FocusNode _monthFocus = FocusNode();
  final FocusNode _yearFocus = FocusNode();

  String _selectedGender = 'Woman';

  String? _nameError;
  String? _dobError;

  @override
  void dispose() {
    _nameController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _dayFocus.dispose();
    _monthFocus.dispose();
    _yearFocus.dispose();
    super.dispose();
  }

  String? _validateName() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return 'Please enter your first name';
    }
    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(name)) {
      return 'Name can only contain alphabetic characters';
    }
    return null;
  }

  int? _calculateAge() {
    final dayStr = _dayController.text.trim();
    final monthStr = _monthController.text.trim();
    final yearStr = _yearController.text.trim();

    if (dayStr.isEmpty || monthStr.isEmpty || yearStr.length < 4) {
      return null;
    }

    final day = int.tryParse(dayStr);
    final month = int.tryParse(monthStr);
    final year = int.tryParse(yearStr);

    if (day == null || month == null || year == null) return null;
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;

    try {
      final date = DateTime(year, month, day);
      if (date.year != year || date.month != month || date.day != day) {
        return null;
      }
      final now = DateTime.now();
      int age = now.year - date.year;
      if (now.month < date.month ||
          (now.month == date.month && now.day < date.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return null;
    }
  }

  String? _validateDob() {
    final dayStr = _dayController.text.trim();
    final monthStr = _monthController.text.trim();
    final yearStr = _yearController.text.trim();

    if (dayStr.isEmpty || monthStr.isEmpty || yearStr.isEmpty) {
      return 'Please enter your complete date of birth';
    }

    final day = int.tryParse(dayStr);
    final month = int.tryParse(monthStr);
    final year = int.tryParse(yearStr);

    if (day == null || month == null || year == null) {
      return 'Please enter a valid date of birth';
    }

    if (month < 1 || month > 12) {
      return 'Please enter a valid month (1-12)';
    }

    if (day < 1 || day > 31) {
      return 'Please enter a valid day (1-31)';
    }

    final now = DateTime.now();
    if (year < 1920 || year > now.year) {
      return 'Please enter a valid 4-digit birth year';
    }

    try {
      final date = DateTime(year, month, day);
      if (date.year != year || date.month != month || date.day != day) {
        return 'Please enter a valid calendar date';
      }

      int age = now.year - date.year;
      if (now.month < date.month ||
          (now.month == date.month && now.day < date.day)) {
        age--;
      }

      if (age < 18) {
        return 'You must be at least 18 years old to join';
      }
      if (age > 100) {
        return 'Please enter a valid date of birth';
      }
    } catch (_) {
      return 'Please enter a valid date of birth';
    }

    return null;
  }

  void _onNext() {
    final nameErr = _validateName();
    final dobErr = _validateDob();

    setState(() {
      _nameError = nameErr;
      _dobError = dobErr;
    });

    if (nameErr != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(nameErr),
          backgroundColor: const Color(0xFFEF4444),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (dobErr != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(dobErr),
          backgroundColor: const Color(0xFFEF4444),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // All valid -> proceed to HomeScreen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final calculatedAge = _calculateAge();

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.keypadButtonBg,
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: _nameError != null
                                      ? const Color(0xFFEF4444)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _nameController,
                                      textCapitalization:
                                          TextCapitalization.words,
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
                                      onChanged: (_) {
                                        if (_nameError != null) {
                                          setState(() => _nameError = null);
                                        } else {
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                                  if (_validateName() == null &&
                                      _nameController.text.trim().isNotEmpty)
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
                            if (_nameError != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    color: Color(0xFFEF4444),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _nameError!,
                                    style: const TextStyle(
                                      color: Color(0xFFEF4444),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 10),
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

                      // Card 2: Gender identity
                      _buildSectionCard(
                        title: 'Gender identity',
                        subtitle: 'Select the option that best reflects you',
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.genderSelected.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.genderSelected.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            _selectedGender,
                            style: const TextStyle(
                              color: AppColors.genderSelected,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildGenderOption(
                                title: 'Woman',
                                isSelected: _selectedGender == 'Woman',
                                onSelect: () =>
                                    setState(() => _selectedGender = 'Woman'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildGenderOption(
                                title: 'Man',
                                isSelected: _selectedGender == 'Man',
                                onSelect: () =>
                                    setState(() => _selectedGender = 'Man'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Card 3: Date of Birth
                      _buildSectionCard(
                        title: 'Your Date of Birth',
                        trailing: calculatedAge != null && calculatedAge >= 18
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$calculatedAge yrs old',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDobField(
                                    label: 'Day',
                                    controller: _dayController,
                                    focusNode: _dayFocus,
                                    nextFocusNode: _monthFocus,
                                    maxLength: 2,
                                    hasError: _dobError != null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildDobField(
                                    label: 'Month',
                                    controller: _monthController,
                                    focusNode: _monthFocus,
                                    nextFocusNode: _yearFocus,
                                    maxLength: 2,
                                    hasError: _dobError != null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: _buildDobField(
                                    label: 'Year',
                                    controller: _yearController,
                                    focusNode: _yearFocus,
                                    maxLength: 4,
                                    hasError: _dobError != null,
                                  ),
                                ),
                              ],
                            ),
                            if (_dobError != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    color: Color(0xFFEF4444),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      _dobError!,
                                      style: const TextStyle(
                                        color: Color(0xFFEF4444),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 12),
                            const Text(
                              'Your age is displayed on your profile. You must be at least 18 years old to join.',
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
                    ],
                  ),
                ),
              ),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: PrimaryButton(text: 'Next', onPressed: _onNext),
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
    Widget? trailing,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ?trailing,
            ],
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
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required int maxLength,
    bool hasError = false,
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
            border: Border.all(
              color: hasError ? const Color(0xFFEF4444) : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(maxLength),
              ],
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (val) {
                if (_dobError != null) {
                  setState(() => _dobError = null);
                } else {
                  setState(() {});
                }
                if (val.length == maxLength && nextFocusNode != null) {
                  nextFocusNode.requestFocus();
                }
              },
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
          color: isSelected ? AppColors.genderSelected : AppColors.keypadButtonBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected ? AppColors.genderSelected : AppColors.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.genderSelected.withValues(alpha: 0.35),
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
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle_rounded,
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
