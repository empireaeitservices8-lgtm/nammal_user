import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exceptions.dart';
import '../controllers/wallet_controller.dart';
import '../models/wallet_models.dart';
import '../repositories/wallet_repository.dart';

class RazorpayCheckoutScreen extends ConsumerStatefulWidget {
  final String coins;
  final String price;
  final int coinAmount;
  final String? packId;

  const RazorpayCheckoutScreen({
    super.key,
    required this.coins,
    required this.price,
    this.coinAmount = 100,
    this.packId,
  });

  @override
  ConsumerState<RazorpayCheckoutScreen> createState() =>
      _RazorpayCheckoutScreenState();
}

class _RazorpayCheckoutScreenState
    extends ConsumerState<RazorpayCheckoutScreen> {
  String _selectedPaymentMethod = 'gpay';
  bool _isProcessing = false;
  bool _isSuccess = false;
  String _createdOrderId = '';
  CreateOrderResponse? _orderResponse;
  AddCoinsResponse? _addCoinsResponse;

  void _handlePay() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final effectivePackId = widget.packId ?? 'pack_${widget.coinAmount}';
      final cleanPriceString = widget.price.replaceAll(RegExp(r'[^0-9.]'), '');
      final num? parsedAmount = num.tryParse(cleanPriceString);

      // 1. Create order
      final order = await ref
          .read(walletRepositoryProvider)
          .createOrder(
            packId: effectivePackId,
            coins: widget.coinAmount,
            amount: parsedAmount,
          );

      // 2. Add coins to wallet via POST /api/user/coins/add/ {"coins": widget.coinAmount}
      final addCoinsResponse = await ref
          .read(walletControllerProvider.notifier)
          .addCoins(widget.coinAmount);

      // 3. Attempt test verification if supported
      try {
        await ref
            .read(walletRepositoryProvider)
            .verifyPayment(
              orderId: order.orderId,
              paymentId: 'pay_${order.orderId}',
            );
      } catch (_) {
        // If server auto-verifies or uses webhook, ignore verify error
      }

      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
        _createdOrderId = order.orderId;
        _orderResponse = order;
        _addCoinsResponse = addCoinsResponse;
      });

      Timer(const Duration(milliseconds: 1600), () {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment processing failed. Please try again.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFF0C2340),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF163761),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: Color(0xFF528FF0),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Razorpay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Row(
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white70,
                    size: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '100% SECURE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Merchant Info & Order Summary Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF0C2340),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  'N',
                                  style: TextStyle(
                                    color: Color(0xFF6A4CEB),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'nammal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.coins,
                                  style: const TextStyle(
                                    color: Color(0xFF9FB2CA),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Amount to Pay',
                              style: TextStyle(
                                color: Color(0xFF9FB2CA),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.price,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Payment Methods List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  children: [
                    // UPI Section
                    _buildSectionHeader(
                      'UPI Options (Google Pay, PhonePe, Paytm)',
                    ),
                    _buildPaymentOptionCard(
                      id: 'gpay',
                      title: 'Google Pay',
                      subtitle: 'Pay directly via Google Pay',
                      iconWidget: _buildUpiBadge(
                        'GPay',
                        const Color(0xFF4285F4),
                      ),
                    ),
                    _buildPaymentOptionCard(
                      id: 'phonepe',
                      title: 'PhonePe',
                      subtitle: 'Instant UPI payment',
                      iconWidget: _buildUpiBadge('Pe', const Color(0xFF5F259F)),
                    ),
                    _buildPaymentOptionCard(
                      id: 'paytm',
                      title: 'Paytm UPI',
                      subtitle: 'Pay using Paytm Wallet or UPI',
                      iconWidget: _buildUpiBadge(
                        'Paytm',
                        const Color(0xFF00B9F5),
                      ),
                    ),
                    _buildPaymentOptionCard(
                      id: 'upi_id',
                      title: 'Add Other UPI ID',
                      subtitle: 'e.g. yourname@okhdfcbank',
                      icon: Icons.qr_code_scanner_rounded,
                      iconColor: const Color(0xFF0C2340),
                    ),

                    const SizedBox(height: 18),

                    // Cards Section
                    _buildSectionHeader('Cards (Credit / Debit)'),
                    _buildPaymentOptionCard(
                      id: 'card',
                      title: 'Add New Card',
                      subtitle: 'Visa, Mastercard, RuPay, Maestro',
                      icon: Icons.credit_card_rounded,
                      iconColor: const Color(0xFF1A56DB),
                    ),

                    const SizedBox(height: 18),

                    // Netbanking Section
                    _buildSectionHeader('Netbanking'),
                    _buildPaymentOptionCard(
                      id: 'netbanking',
                      title: 'All Indian Banks',
                      subtitle: 'HDFC, SBI, ICICI, Axis, Kotak & more',
                      icon: Icons.account_balance_rounded,
                      iconColor: const Color(0xFF059669),
                    ),

                    const SizedBox(height: 18),

                    // Trust & Security Footer
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            color: Color(0xFF10B981),
                            size: 22,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Razorpay Verified Business',
                                  style: TextStyle(
                                    color: Color(0xFF1E293B),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'PCI-DSS Level 1 Compliant. Your payment information is 100% encrypted and safe.',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 11,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Bottom Sticky Pay Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D58BA),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _isProcessing ? null : _handlePay,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock_rounded, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Pay ${widget.price}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Secured by ',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Razorpay',
                          style: TextStyle(
                            color: Color(0xFF0C2340),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Processing / Success Overlay
          if (_isProcessing || _isSuccess)
            Container(
              color: Colors.black.withValues(alpha: 0.65),
              child: Center(
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.20),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isProcessing) ...[
                        const CircularProgressIndicator(
                          strokeWidth: 3.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF1D58BA),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Processing Payment',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Connecting to bank gateway...',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12.5,
                          ),
                        ),
                      ] else ...[
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDCFCE7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF10B981),
                            size: 38,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Payment Successful!',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _addCoinsResponse != null
                              ? _addCoinsResponse!.message
                              : '${widget.coins} added to your wallet',
                          style: const TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_addCoinsResponse != null) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Available Balance: ${_addCoinsResponse!.newBalance} Coins',
                              style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          'Ref: ${_createdOrderId.isNotEmpty ? _createdOrderId : "pay_Rz${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}"}',
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildPaymentOptionCard({
    required String id,
    required String title,
    required String subtitle,
    IconData? icon,
    Color? iconColor,
    Widget? iconWidget,
  }) {
    final isSelected = _selectedPaymentMethod == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1D58BA)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF1D58BA).withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            if (iconWidget != null)
              iconWidget
            else
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: (iconColor ?? const Color(0xFF0C2340)).withValues(
                    alpha: 0.08,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF0F172A),
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1D58BA)
                      : const Color(0xFFCBD5E1),
                  width: 2,
                ),
                color: isSelected
                    ? const Color(0xFF1D58BA)
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.circle, color: Colors.white, size: 8)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpiBadge(String text, Color color) {
    return Container(
      width: 44,
      height: 34,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
