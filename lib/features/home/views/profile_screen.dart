import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/views/phone_login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileTab extends ConsumerStatefulWidget {
  final VoidCallback? onNavigateToWallet;

  const ProfileTab({super.key, this.onNavigateToWallet});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  String _name = '';
  String _phone = '+91';
  DateTime _dob = DateTime(2000, 5, 24);
  String _imagePath = '';
  String _bio = 'Looking for a meaningful connection';

  int get _age {
    final now = DateTime.now();
    int age = now.year - _dob.year;
    if (now.month < _dob.month ||
        (now.month == _dob.month && now.day < _dob.day)) {
      age--;
    }
    return age;
  }

  void _openEditProfile() async {
    final updated = await Navigator.of(context).push<UserProfileData>(
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          initialData: UserProfileData(
            name: _name,
            phone: _phone,
            dob: _dob,
            imagePath: _imagePath,
            bio: _bio,
          ),
        ),
      ),
    );

    if (updated != null && mounted) {
      setState(() {
        _name = updated.name;
        _phone = updated.phone;
        _dob = updated.dob;
        _imagePath = updated.imagePath;
        _bio = updated.bio;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _imagePath = pickedFile.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Color(0xFF10B981),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not access ${source == ImageSource.camera ? 'Camera' : 'Gallery'}: $e',
            ),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _showProfileImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Change Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Select a source to update your profile picture',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                // Camera Option
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  leading: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    'Camera',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: const Text(
                    'Take a new photo with your camera',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                  ),
                  onTap: () {
                    Navigator.of(modalCtx).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                const Divider(
                  height: 12,
                  thickness: 0.8,
                  color: Color(0xFFF3F4F6),
                ),
                // Gallery Option
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  leading: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.photo_library_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    'Gallery',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: const Text(
                    'Choose an existing photo from gallery',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                  ),
                  onTap: () {
                    Navigator.of(modalCtx).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (_imagePath.isNotEmpty &&
                    !_imagePath.startsWith('assets/')) ...[
                  const Divider(
                    height: 12,
                    thickness: 0.8,
                    color: Color(0xFFF3F4F6),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    leading: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.account_circle_outlined,
                        color: Color(0xFFEF4444),
                        size: 24,
                      ),
                    ),
                    title: const Text(
                      'Use Default Avatar',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                    subtitle: const Text(
                      'Remove photo and restore avatar',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                    ),
                    onTap: () {
                      Navigator.of(modalCtx).pop();
                      setState(() {
                        _imagePath = '';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Avatar restored'),
                          backgroundColor: Color(0xFF10B981),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarImage(String path, double width, double height) {
    if (path.isNotEmpty && !path.startsWith('assets/')) {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      }
    }

    // Modern Stylized Profile Avatar
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFEDE9FE), Color(0xFFDDD6FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: width * 0.58,
          color: AppColors.primary,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: const [
            Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 24),
            SizedBox(width: 10),
            Text(
              'Log Out',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.5,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.of(dialogCtx).pop();
              await _performLogout();
            },
            child: const Text(
              'Log Out',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    // Show non-dismissible loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    );

    String message = 'Logout successful';
    try {
      final res = await ref.read(authControllerProvider.notifier).logout();
      if (res.message.isNotEmpty) {
        message = res.message;
      }
    } catch (e) {
      debugPrint('Error during logout: $e');
    }

    if (!mounted) return;

    // Dismiss the loading dialog
    Navigator.of(context, rootNavigator: true).pop();

    // Navigate to PhoneLoginScreen and clear navigation stack so back button cannot return
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const PhoneLoginScreen()),
      (route) => false,
    );

    // User feedback notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _performDeleteAccount() async {
    // Show non-dismissible loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFFEF4444)),
        ),
      ),
    );

    String message = 'Your account has been deleted successfully.';
    try {
      final res = await ref
          .read(authControllerProvider.notifier)
          .deleteAccount();
      if (res.message.isNotEmpty) {
        message = res.message;
      }
    } catch (e) {
      debugPrint('Error during delete account: $e');
    }

    if (!mounted) return;

    // Dismiss loading indicator
    Navigator.of(context, rootNavigator: true).pop();

    // Navigate to PhoneLoginScreen and clear navigation stack so back button cannot return
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const PhoneLoginScreen()),
      (route) => false,
    );

    // User feedback notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: const [
            Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFEF4444),
              size: 26,
            ),
            SizedBox(width: 10),
            Text(
              'Delete Account?',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action is permanent and cannot be undone. All your coins, conversations, and profile details will be permanently removed.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _performDeleteAccount();
            },
            child: const Text(
              'Delete Account',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FD),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 32,
          ),
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 16),
              child: Text(
                'Profile',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Chillax Variable',
                ),
              ),
            ),

            // Card 1: Top Hero Profile Card
            _buildProfileHeroCard(context),

            const SizedBox(height: 16),

            // Card 2: Personal Info Card
            _buildPersonalInfoCard(),

            const SizedBox(height: 16),

            // Card 3: Action Menu List Card
            _buildActionMenuCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with purple outline, tap to change, and green active badge
          GestureDetector(
            onTap: _showProfileImagePicker,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: 86,
                  height: 86,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFC4B5FD),
                      width: 2.5,
                    ),
                  ),
                  child: ClipOval(child: _buildAvatarImage(_imagePath, 80, 80)),
                ),
                Positioned(
                  right: 3,
                  bottom: 3,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Name and Age
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
              children: [
                TextSpan(
                  text: '$_name ',
                  style: const TextStyle(color: Color(0xFF1E1B4B)),
                ),
                const TextSpan(
                  text: ', ',
                  style: TextStyle(color: Color(0xFF8B5CF6)),
                ),
                TextSpan(
                  text: '$_age',
                  style: const TextStyle(color: Color(0xFF8B5CF6)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Bio
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, color: Color(0xFFA78BFA), size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  _bio,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Phone verification pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF8B5CF6),
                  size: 14,
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFF8B5CF6),
                  size: 13,
                ),
                const SizedBox(width: 6),
                Text(
                  _phone,
                  style: const TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Badges Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.verified_user_outlined,
                      color: Color(0xFF8B5CF6),
                      size: 13,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Verified Member',
                      style: TextStyle(
                        color: Color(0xFF8B5CF6),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.monetization_on,
                      color: Color(0xFFF59E0B),
                      size: 14,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '1,250 Coins',
                      style: TextStyle(
                        color: Color(0xFF8B5CF6),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Edit Profile Button
          Container(
            width: double.infinity,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(23),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(23),
                onTap: _openEditProfile,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Personal Info',
                style: TextStyle(
                  color: Color(0xFF1E1B4B),
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3.5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Verified',
                  style: TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Row 1: Full Name
          _buildInfoRow('Full Name', _name),

          const SizedBox(height: 14),

          // Row 2: Age
          _buildInfoRow('Age', '$_age years old'),

          const SizedBox(height: 14),

          // Row 3: Phone Number
          _buildInfoRow('Phone Number', _phone),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1E1B4B),
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildActionMenuCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.person_outline_rounded,
            iconColor: const Color(0xFF8B5CF6),
            iconBg: const Color(0xFFF5F3FF),
            title: 'Edit Profile',
            onTap: _openEditProfile,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: const Color(0xFF8B5CF6),
            iconBg: const Color(0xFFF5F3FF),
            title: 'My Wallet',
            onTap: () {
              if (widget.onNavigateToWallet != null) {
                widget.onNavigateToWallet!();
              }
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.receipt_long_outlined,
            iconColor: const Color(0xFF6366F1),
            iconBg: const Color(0xFFEEF2FF),
            title: 'Transaction History',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.notifications_none_rounded,
            iconColor: const Color(0xFF8B5CF6),
            iconBg: const Color(0xFFF5F3FF),
            title: 'Notifications',
            showNotificationDot: true,
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF64748B),
            iconBg: const Color(0xFFF1F5F9),
            title: 'Privacy Policy',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.description_outlined,
            iconColor: const Color(0xFFD97706),
            iconBg: const Color(0xFFFEF3C7),
            title: 'Terms of Service',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.headset_mic_outlined,
            iconColor: const Color(0xFF059669),
            iconBg: const Color(0xFFD1FAE5),
            title: 'Help & Concierge',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.delete_outline_rounded,
            iconColor: const Color(0xFFEF4444),
            iconBg: const Color(0xFFFEE2E2),
            title: 'Delete Account',
            titleColor: const Color(0xFFEF4444),
            chevronColor: const Color(0xFFEF4444),
            onTap: () => _showDeleteAccountDialog(context),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.logout_rounded,
            iconColor: const Color(0xFFEF4444),
            iconBg: const Color(0xFFFEE2E2),
            title: 'Log Out',
            titleColor: const Color(0xFFEF4444),
            chevronColor: const Color(0xFFEF4444),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 62,
      endIndent: 16,
      color: Color(0xFFF3F4F6),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    Color titleColor = const Color(0xFF1E1B4B),
    Color chevronColor = const Color(0xFFD1D5DB),
    bool showNotificationDot = false,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (showNotificationDot) ...[
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5CF6),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Icon(Icons.chevron_right_rounded, color: chevronColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
