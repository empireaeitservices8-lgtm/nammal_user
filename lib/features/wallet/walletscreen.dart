import 'package:flutter/material.dart';
import 'package:nammal_user/features/wallet/views/razorpay_checkout_screen.dart';

import '../../core/config/app_colors.dart';

class WalletTab extends StatefulWidget {
  const WalletTab({super.key});

  @override
  State<WalletTab> createState() => WalletTabState();
}

class WalletTabState extends State<WalletTab> {
  int _balance = 0;
  int? _selectedIndex;

  void _buyCoins(String coins, String price, int amount) async {
    final success = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => RazorpayCheckoutScreen(
          coins: coins,
          price: price,
          coinAmount: amount,
        ),
      ),
    );

    if (success == true && mounted) {
      setState(() {
        _balance += amount;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$coins successfully added to your wallet!'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  void _selectAndBuy(int index, String coins, String price, int amount) async {
    setState(() {
      _selectedIndex = index;
    });
    // Brief delay so the user immediately sees the primary border selection feedback before checkout
    await Future.delayed(const Duration(milliseconds: 150));
    if (mounted) {
      _buyCoins(coins, price, amount);
    }
  }

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
        decoration: const BoxDecoration(gradient: AppColors.screenGradient),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Color(0xFFFFD700),
                        size: 32,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$_balance Coins',
                        style: const TextStyle(
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
                children: [
                  _CoinPackageCard(
                    coins: '100 Coins',
                    price: '₹99',
                    isSelected: _selectedIndex == 0,
                    onTap: () => _selectAndBuy(0, '100 Coins', '₹99', 100),
                  ),
                  _CoinPackageCard(
                    coins: '250 Coins',
                    price: '₹229',
                    isPopular: true,
                    isSelected: _selectedIndex == 1,
                    onTap: () => _selectAndBuy(1, '250 Coins', '₹229', 250),
                  ),
                  _CoinPackageCard(
                    coins: '500 Coins',
                    price: '₹449',
                    isSelected: _selectedIndex == 2,
                    onTap: () => _selectAndBuy(2, '500 Coins', '₹449', 500),
                  ),
                  _CoinPackageCard(
                    coins: '1,250 Coins',
                    price: '₹999',
                    isSelected: _selectedIndex == 3,
                    onTap: () => _selectAndBuy(3, '1,250 Coins', '₹999', 1250),
                  ),
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
  final bool isSelected;
  final VoidCallback onTap;

  const _CoinPackageCard({
    required this.coins,
    required this.price,
    this.isPopular = false,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.04)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.borderSubtle,
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Color(0xFFE5A100),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      coins,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (isPopular) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.keypadButtonBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    price,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
