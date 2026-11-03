import 'package:flutter/material.dart';
import '../../../core/config/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _DiscoverPeopleTab(),
          _WalletTab(),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.borderSubtle.withValues(alpha: 0.6)),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.explore, 'Home'),
                _buildNavItem(1, Icons.account_balance_wallet_outlined, 'Wallet'),
                _buildNavItem(2, Icons.person_outline_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEDE9FE) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- TAB 1: Discover People (Matching Screenshot) -----------------
class _DiscoverPeopleTab extends StatelessWidget {
  const _DiscoverPeopleTab();

  @override
  Widget build(BuildContext context) {
    final agents = [
      {
        'name': 'Liya',
        'age': '26',
        'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=600&auto=format&fit=crop&q=80',
        'isOnline': true,
      },
      {
        'name': 'Amal',
        'age': '32',
        'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&auto=format&fit=crop&q=80',
        'isOnline': true,
      },
      {
        'name': 'Liam',
        'age': '26',
        'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=600&auto=format&fit=crop&q=80',
        'isOnline': true,
      },
      {
        'name': 'Chloe',
        'age': '23',
        'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=600&auto=format&fit=crop&q=80',
        'isOnline': true,
      },
      {
        'name': 'Daniel',
        'age': '27',
        'image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=600&auto=format&fit=crop&q=80',
        'isOnline': true,
      },
      {
        'name': 'Olivia',
        'age': '28',
        'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600&auto=format&fit=crop&q=80',
        'isOnline': true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatar + Logo
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE4DCFD),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'nammal',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),

                // Coin Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EFFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.monetization_on, color: Color(0xFFF59E0B), size: 16),
                      SizedBox(width: 6),
                      Text(
                        '1,250 Coins',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18, 14, 18, 12),
              child: Text(
                'Discover People',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.64,
                crossAxisSpacing: 14,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final agent = agents[index];
                  return _AgentCard(
                    name: agent['name'] as String,
                    age: agent['age'] as String,
                    imageUrl: agent['image'] as String,
                    isOnline: agent['isOnline'] as bool,
                  );
                },
                childCount: agents.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}

class _AgentCard extends StatelessWidget {
  final String name;
  final String age;
  final String imageUrl;
  final bool isOnline;

  const _AgentCard({
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image Area with Overlays
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.keypadButtonBg,
                        child: Center(
                          child: Text(
                            name[0],
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Gradient Overlay for text readability
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.0),
                          Colors.black.withValues(alpha: 0.65),
                        ],
                        stops: const [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),
                ),

                // Online Badge
                if (isOnline)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Color(0xFF10B981), size: 8),
                          SizedBox(width: 4),
                          Text(
                            'Online',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Name and Age
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Text(
                    '$name, $age',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Buttons (Voice Call & Video Call)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                // Voice Call Button
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Starting voice call with $name...'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B77FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Video Call Button
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Starting video call with $name...'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFECE6FE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.videocam_rounded,
                        color: Color(0xFF6A4CEB),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------- TAB 2: Wallet Screen -----------------
class _WalletTab extends StatelessWidget {
  const _WalletTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Wallet',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.screenGradient,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.monetization_on, color: Color(0xFFFFD700), size: 32),
                      SizedBox(width: 10),
                      Text(
                        '1,250 Coins',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Buy Coins',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: const [
                  _CoinPackageCard(coins: '100 Coins', price: '₹99'),
                  _CoinPackageCard(coins: '250 Coins', price: '₹229', isPopular: true),
                  _CoinPackageCard(coins: '500 Coins', price: '₹449'),
                  _CoinPackageCard(coins: '1,250 Coins', price: '₹999'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoinPackageCard extends StatelessWidget {
  final String coins;
  final String price;
  final bool isPopular;

  const _CoinPackageCard({
    required this.coins,
    required this.price,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isPopular ? AppColors.primary : AppColors.borderSubtle,
          width: isPopular ? 1.8 : 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Color(0xFFE5A100), size: 24),
              const SizedBox(width: 12),
              Text(
                coins,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (isPopular) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Popular',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.keypadButtonBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              price,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------- TAB 3: Profile Screen -----------------
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.screenGradient,
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Center(
              child: CircleAvatar(
                radius: 46,
                backgroundColor: AppColors.keypadButtonBg,
                child: Icon(Icons.person, size: 50, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Elena',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Center(
              child: Text(
                '+91 9876543210',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildTile(Icons.edit_outlined, 'Edit Profile'),
            _buildTile(Icons.history_rounded, 'Transaction History'),
            _buildTile(Icons.notifications_outlined, 'Notifications'),
            _buildTile(Icons.privacy_tip_outlined, 'Privacy Policy'),
            _buildTile(Icons.description_outlined, 'Terms of Service'),
            _buildTile(Icons.delete_outline, 'Delete Account', isDestructive: true),
            _buildTile(Icons.logout, 'Log Out', isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
        onTap: () {},
      ),
    );
  }
}
