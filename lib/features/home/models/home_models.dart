class HomeUserData {
  final int id;
  final String name;
  final String? avatarUrl;
  final int coins;
  final num walletBalance;

  const HomeUserData({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.coins,
    required this.walletBalance,
  });

  factory HomeUserData.fromJson(Map<String, dynamic> json) {
    return HomeUserData(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['name'] ?? '').toString(),
      avatarUrl: json['avatar_url'] as String?,
      coins: json['coins'] is int
          ? json['coins'] as int
          : int.tryParse(json['coins']?.toString() ?? '0') ?? 0,
      walletBalance: json['wallet_balance'] is num
          ? json['wallet_balance'] as num
          : num.tryParse(json['wallet_balance']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar_url': avatarUrl,
        'coins': coins,
        'wallet_balance': walletBalance,
      };
}

class HomeRates {
  final num audioCoinsPerMin;
  final num videoCoinsPerMin;
  final double coinToInr;

  const HomeRates({
    required this.audioCoinsPerMin,
    required this.videoCoinsPerMin,
    required this.coinToInr,
  });

  factory HomeRates.fromJson(Map<String, dynamic> json) {
    return HomeRates(
      audioCoinsPerMin: json['audio_coins_per_min'] is num
          ? json['audio_coins_per_min'] as num
          : 10,
      videoCoinsPerMin: json['video_coins_per_min'] is num
          ? json['video_coins_per_min'] as num
          : 20,
      coinToInr: (json['coin_to_inr'] is num
              ? json['coin_to_inr'] as num
              : 1.0)
          .toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'audio_coins_per_min': audioCoinsPerMin,
        'video_coins_per_min': videoCoinsPerMin,
        'coin_to_inr': coinToInr,
      };
}

class HomeHost {
  final int id;
  final String name;
  final String age;
  final String imageUrl;
  final bool isOnline;
  final bool isBusy;

  const HomeHost({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    this.isOnline = true,
    this.isBusy = false,
  });

  factory HomeHost.fromJson(Map<String, dynamic> json) {
    return HomeHost(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['name'] ?? json['username'] ?? 'Host').toString(),
      age: (json['age'] ?? json['profile']?['age'] ?? '24').toString(),
      imageUrl: (json['avatar_url'] ??
              json['avatar'] ??
              json['image'] ??
              json['profile_picture'] ??
              '')
          .toString(),
      isOnline: json['is_online'] == true ||
          (json['status']?.toString().toLowerCase() == 'online'),
      isBusy: json['is_busy'] == true ||
          (json['status']?.toString().toLowerCase() == 'busy'),
    );
  }
}

class HomeScreenResponse {
  final String status;
  final HomeUserData user;
  final int onlineCount;
  final List<dynamic> onlineHosts;
  final int busyCount;
  final List<dynamic> busyHosts;
  final int offlineCount;
  final List<dynamic> offlineHosts;
  final HomeRates rates;

  const HomeScreenResponse({
    required this.status,
    required this.user,
    required this.onlineCount,
    required this.onlineHosts,
    required this.busyCount,
    required this.busyHosts,
    required this.offlineCount,
    required this.offlineHosts,
    required this.rates,
  });

  bool get isSuccess => status.toLowerCase() == 'success';

  factory HomeScreenResponse.fromJson(Map<String, dynamic> json) {
    return HomeScreenResponse(
      status: (json['status'] ?? 'success').toString(),
      user: json['user'] is Map<String, dynamic>
          ? HomeUserData.fromJson(json['user'] as Map<String, dynamic>)
          : const HomeUserData(
              id: 0,
              name: '',
              coins: 0,
              walletBalance: 0,
            ),
      onlineCount: json['online_count'] is int
          ? json['online_count'] as int
          : int.tryParse(json['online_count']?.toString() ?? '0') ?? 0,
      onlineHosts: json['online_hosts'] is List
          ? json['online_hosts'] as List<dynamic>
          : const [],
      busyCount: json['busy_count'] is int
          ? json['busy_count'] as int
          : int.tryParse(json['busy_count']?.toString() ?? '0') ?? 0,
      busyHosts: json['busy_hosts'] is List
          ? json['busy_hosts'] as List<dynamic>
          : const [],
      offlineCount: json['offline_count'] is int
          ? json['offline_count'] as int
          : int.tryParse(json['offline_count']?.toString() ?? '0') ?? 0,
      offlineHosts: json['offline_hosts'] is List
          ? json['offline_hosts'] as List<dynamic>
          : const [],
      rates: json['rates'] is Map<String, dynamic>
          ? HomeRates.fromJson(json['rates'] as Map<String, dynamic>)
          : const HomeRates(
              audioCoinsPerMin: 10,
              videoCoinsPerMin: 20,
              coinToInr: 1.0,
            ),
    );
  }
}
