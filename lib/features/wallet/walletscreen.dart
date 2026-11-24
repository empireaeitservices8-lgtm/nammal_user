import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nammal_user/features/wallet/views/razorpay_checkout_screen.dart';
import 'package:nammal_user/features/wallet/views/transaction_history_screen.dart';

import '../../core/config/app_colors.dart';
import '../home/controllers/home_controller.dart';
import '../home/controllers/profile_controller.dart';
import 'controllers/wallet_controller.dart';
import 'models/wallet_models.dart';

class WalletTab extends ConsumerStatefulWidget {
  const WalletTab({super.key});

  @override
  ConsumerState<WalletTab> createState() => WalletTabState();
}

class WalletTabState extends ConsumerState<WalletTab> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walletControllerProvider.notifier).fetchWallet();
    });
  }

  void _buyCoins(
    String coinsText,
    String price,
    int amount, {
    String? packId,
  }) async {
    final success = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => RazorpayCheckoutScreen(
          coins: coinsText,
          price: price,
          coinAmount: amount,
          packId: packId,
        ),
      ),
    );

    if (success == true && mounted) {
      // Refresh wallet and home / profile data
      ref.read(walletControllerProvider.notifier).fetchWallet(isRefresh: true);
      ref.read(homeControllerProvider.notifier).refresh();
      ref.read(profileControllerProvider.notifier).refresh();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$coinsText successfully added to your wallet!'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  void _selectAndBuy(
    int index,
    String coinsText,
    String price,
    int amount, {
    String? packId,
  }) async {
    setState(() {
      _selectedIndex = index;
    });
    // Brief delay so the user immediately sees the primary border selection feedback before checkout
    await Future.delayed(const Duration(milliseconds: 150));
    if (mounted) {
      _buyCoins(coinsText, price, amount, packId: packId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final walletData = walletState.data;

    // Use API coin packs or fallback to default packs if list is empty
    final coinPacks = (walletData?.coinPacks.isNotEmpty ?? false)
        ? walletData!.coinPacks
        : _defaultCoinPacks;

    final coinsBalance = walletData?.coins ?? 0;
    final walletBalance = walletData?.walletBalance ?? 0;
    final formattedCoins = NumberFormat('#,###').format(coinsBalance);

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
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined, color: AppColors.primary),
            tooltip: 'Transaction History',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const TransactionHistoryScreen(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            tooltip: 'Refresh',
            onPressed: () => ref
                .read(walletControllerProvider.notifier)
                .fetchWallet(isRefresh: true),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.screenGradient),
        child: RefreshIndicator(
          onRefresh: () => ref
              .read(walletControllerProvider.notifier)
              .fetchWallet(isRefresh: true),
          color: AppColors.primary,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Available Balance',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        if (walletState.isLoading && walletData != null)
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white70,
                              ),
                            ),
                          ),
                      ],
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
                          '$formattedCoins Coins',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    if (walletBalance > 0) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Cash Balance: ₹${walletBalance.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Error State Banner (if any)
              if (walletState.error != null && walletData == null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFCA5A5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Color(0xFFEF4444),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          walletState.error!,
                          style: const TextStyle(
                            color: Color(0xFF991B1B),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref
                            .read(walletControllerProvider.notifier)
                            .fetchWallet(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ],

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

              // Coin Packages
              if (walletState.isLoading && walletData == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else
                ...List.generate(coinPacks.length, (index) {
                  final pack = coinPacks[index];
                  final formattedPackCoins = NumberFormat(
                    '#,###',
                  ).format(pack.coins);
                  final packTitle = '$formattedPackCoins Coins';
                  return _CoinPackageCard(
                    coins: packTitle,
                    price: pack.displayPrice,
                    tag: pack.tag,
                    isPopular: pack.isPopular,
                    isSelected: _selectedIndex == index,
                    onTap: () => _selectAndBuy(
                      index,
                      packTitle,
                      pack.displayPrice,
                      pack.coins,
                      packId: pack.id,
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  static const List<CoinPackModel> _defaultCoinPacks = [
    CoinPackModel(
      id: 'pack_100',
      coins: 100,
      priceInr: 99,
      displayPrice: '₹99',
      isPopular: false,
    ),
    CoinPackModel(
      id: 'pack_250',
      coins: 250,
      priceInr: 229,
      displayPrice: '₹229',
      tag: 'Popular',
      isPopular: true,
    ),
    CoinPackModel(
      id: 'pack_500',
      coins: 500,
      priceInr: 449,
      displayPrice: '₹449',
      isPopular: false,
    ),
    CoinPackModel(
      id: 'pack_1250',
      coins: 1250,
      priceInr: 999,
      displayPrice: '₹999',
      isPopular: false,
    ),
  ];
}

class _CoinPackageCard extends StatelessWidget {
  final String coins;
  final String price;
  final String? tag;
  final bool isPopular;
  final bool isSelected;
  final VoidCallback onTap;

  const _CoinPackageCard({
    required this.coins,
    required this.price,
    this.tag,
    this.isPopular = false,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final showTag = (tag != null && tag!.isNotEmpty) || isPopular;
    final tagLabel = (tag != null && tag!.isNotEmpty) ? tag! : 'Popular';

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
                    if (showTag) ...[
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
                        child: Text(
                          tagLabel,
                          style: const TextStyle(
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
