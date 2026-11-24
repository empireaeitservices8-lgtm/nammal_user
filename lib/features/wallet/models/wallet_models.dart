class CoinPackModel {
  final String id;
  final int coins;
  final num priceInr;
  final String displayPrice;
  final String? tag;
  final bool isPopular;

  const CoinPackModel({
    required this.id,
    required this.coins,
    required this.priceInr,
    required this.displayPrice,
    this.tag,
    this.isPopular = false,
  });

  factory CoinPackModel.fromJson(Map<String, dynamic> json) {
    return CoinPackModel(
      id: (json['id'] ?? '').toString(),
      coins: json['coins'] is int
          ? json['coins'] as int
          : int.tryParse(json['coins']?.toString() ?? '0') ?? 0,
      priceInr: json['price_inr'] is num
          ? json['price_inr'] as num
          : num.tryParse(json['price_inr']?.toString() ?? '0') ?? 0,
      displayPrice: (json['display_price'] ?? '₹${json['price_inr'] ?? 0}').toString(),
      tag: json['tag']?.toString(),
      isPopular: json['is_popular'] == true ||
          (json['tag'] != null &&
              json['tag'].toString().toLowerCase().contains('popular')),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'coins': coins,
    'price_inr': priceInr,
    'display_price': displayPrice,
    'tag': tag,
    'is_popular': isPopular,
  };
}

class WalletResponse {
  final String status;
  final int coins;
  final num walletBalance;
  final num coinToInr;
  final List<CoinPackModel> coinPacks;
  final List<dynamic> offers;
  final List<dynamic> transactions;

  const WalletResponse({
    required this.status,
    required this.coins,
    required this.walletBalance,
    required this.coinToInr,
    required this.coinPacks,
    this.offers = const [],
    this.transactions = const [],
  });

  bool get isSuccess => status.toLowerCase() == 'success';

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    var rawPacks = json['coin_packs'];
    List<CoinPackModel> packs = [];
    if (rawPacks is List) {
      for (var p in rawPacks) {
        if (p is Map<String, dynamic>) {
          packs.add(CoinPackModel.fromJson(p));
        } else if (p is Map) {
          packs.add(CoinPackModel.fromJson(Map<String, dynamic>.from(p)));
        }
      }
    }

    return WalletResponse(
      status: (json['status'] ?? '').toString(),
      coins: json['coins'] is int
          ? json['coins'] as int
          : int.tryParse(json['coins']?.toString() ?? '0') ?? 0,
      walletBalance: json['wallet_balance'] is num
          ? json['wallet_balance'] as num
          : num.tryParse(json['wallet_balance']?.toString() ?? '0') ?? 0,
      coinToInr: json['coin_to_inr'] is num
          ? json['coin_to_inr'] as num
          : num.tryParse(json['coin_to_inr']?.toString() ?? '1.0') ?? 1.0,
      coinPacks: packs,
      offers: json['offers'] is List ? (json['offers'] as List) : const [],
      transactions: json['transactions'] is List
          ? (json['transactions'] as List)
          : const [],
    );
  }
}

class CreateOrderPrefill {
  final String name;
  final String contact;
  final String email;

  const CreateOrderPrefill({
    this.name = '',
    this.contact = '',
    this.email = '',
  });

  factory CreateOrderPrefill.fromJson(Map<String, dynamic> json) {
    return CreateOrderPrefill(
      name: (json['name'] ?? '').toString(),
      contact: (json['contact'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'contact': contact,
    'email': email,
  };
}

class CreateOrderResponse {
  final String status;
  final String mode;
  final String orderId;
  final String razorpayKeyId;
  final int amountPaise;
  final num amountInr;
  final String displayAmount;
  final String currency;
  final int coins;
  final String packId;
  final String merchantName;
  final List<String> paymentMethods;
  final CreateOrderPrefill? prefill;

  const CreateOrderResponse({
    required this.status,
    this.mode = 'test',
    required this.orderId,
    required this.razorpayKeyId,
    this.amountPaise = 0,
    this.amountInr = 0,
    this.displayAmount = '',
    this.currency = 'INR',
    this.coins = 0,
    this.packId = '',
    this.merchantName = 'nammal',
    this.paymentMethods = const [],
    this.prefill,
  });

  bool get isSuccess => status.toLowerCase() == 'success';

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    List<String> methods = [];
    if (json['payment_methods'] is List) {
      methods = (json['payment_methods'] as List)
          .map((e) => e.toString())
          .toList();
    }

    CreateOrderPrefill? prefill;
    if (json['prefill'] is Map<String, dynamic>) {
      prefill =
          CreateOrderPrefill.fromJson(json['prefill'] as Map<String, dynamic>);
    } else if (json['prefill'] is Map) {
      prefill =
          CreateOrderPrefill.fromJson(Map<String, dynamic>.from(json['prefill']));
    }

    return CreateOrderResponse(
      status: (json['status'] ?? '').toString(),
      mode: (json['mode'] ?? 'test').toString(),
      orderId: (json['order_id'] ?? '').toString(),
      razorpayKeyId: (json['razorpay_key_id'] ?? '').toString(),
      amountPaise: json['amount_paise'] is int
          ? json['amount_paise'] as int
          : int.tryParse(json['amount_paise']?.toString() ?? '0') ?? 0,
      amountInr: json['amount_inr'] is num
          ? json['amount_inr'] as num
          : num.tryParse(json['amount_inr']?.toString() ?? '0') ?? 0,
      displayAmount: (json['display_amount'] ?? '').toString(),
      currency: (json['currency'] ?? 'INR').toString(),
      coins: json['coins'] is int
          ? json['coins'] as int
          : int.tryParse(json['coins']?.toString() ?? '0') ?? 0,
      packId: (json['pack_id'] ?? '').toString(),
      merchantName: (json['merchant_name'] ?? 'nammal').toString(),
      paymentMethods: methods,
      prefill: prefill,
    );
  }
}

class AddCoinsResponse {
  final String status;
  final String message;
  final int coinsAdded;
  final int newBalance;
  final num walletBalance;
  final dynamic transactionId;
  final dynamic referenceId;

  const AddCoinsResponse({
    required this.status,
    required this.message,
    required this.coinsAdded,
    required this.newBalance,
    required this.walletBalance,
    this.transactionId,
    this.referenceId,
  });

  bool get isSuccess => status.toLowerCase() == 'success';

  factory AddCoinsResponse.fromJson(Map<String, dynamic> json) {
    return AddCoinsResponse(
      status: (json['status'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      coinsAdded: json['coins_added'] is int
          ? json['coins_added'] as int
          : int.tryParse(json['coins_added']?.toString() ?? '0') ?? 0,
      newBalance: json['new_balance'] is int
          ? json['new_balance'] as int
          : int.tryParse(json['new_balance']?.toString() ?? '0') ?? 0,
      walletBalance: json['wallet_balance'] is num
          ? json['wallet_balance'] as num
          : num.tryParse(json['wallet_balance']?.toString() ?? '0') ?? 0,
      transactionId: json['transaction_id'],
      referenceId: json['reference_id'],
    );
  }
}

class TransactionItemModel {
  final int id;
  final String direction;
  final String transactionType;
  final String label;
  final num amount;
  final num signedAmount;
  final String? referenceId;
  final String? date;
  final String? time;
  final String? createdAt;

  const TransactionItemModel({
    required this.id,
    this.direction = 'credit',
    this.transactionType = 'coin_purchase',
    this.label = 'Coin Purchase',
    this.amount = 0,
    this.signedAmount = 0,
    this.referenceId,
    this.date,
    this.time,
    this.createdAt,
  });

  bool get isCredit =>
      direction.toLowerCase() == 'credit' || signedAmount > 0;

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) {
    return TransactionItemModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      direction: (json['direction'] ?? 'credit').toString(),
      transactionType: (json['transaction_type'] ?? 'coin_purchase').toString(),
      label: (json['label'] ?? 'Coin Purchase').toString(),
      amount: json['amount'] is num
          ? json['amount'] as num
          : num.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      signedAmount: json['signed_amount'] is num
          ? json['signed_amount'] as num
          : num.tryParse(json['signed_amount']?.toString() ?? '0') ?? 0,
      referenceId: json['reference_id']?.toString(),
      date: json['date']?.toString(),
      time: json['time']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'direction': direction,
    'transaction_type': transactionType,
    'label': label,
    'amount': amount,
    'signed_amount': signedAmount,
    'reference_id': referenceId,
    'date': date,
    'time': time,
    'created_at': createdAt,
  };
}

class TransactionsResponse {
  final String status;
  final int coins;
  final int count;
  final List<TransactionItemModel> transactions;

  const TransactionsResponse({
    required this.status,
    this.coins = 0,
    this.count = 0,
    this.transactions = const [],
  });

  bool get isSuccess => status.toLowerCase() == 'success';

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    List<TransactionItemModel> txs = [];
    final rawTxs = json['transactions'];
    if (rawTxs is List) {
      for (var item in rawTxs) {
        if (item is Map<String, dynamic>) {
          txs.add(TransactionItemModel.fromJson(item));
        } else if (item is Map) {
          txs.add(TransactionItemModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return TransactionsResponse(
      status: (json['status'] ?? '').toString(),
      coins: json['coins'] is int
          ? json['coins'] as int
          : int.tryParse(json['coins']?.toString() ?? '0') ?? 0,
      count: json['count'] is int
          ? json['count'] as int
          : int.tryParse(json['count']?.toString() ?? txs.length.toString()) ??
              txs.length,
      transactions: txs,
    );
  }
}
