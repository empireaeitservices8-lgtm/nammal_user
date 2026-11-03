class ApiEndpoints {
  // Replace with your real backend base URL or development IP
  static const String baseUrl = 'https://api.nammal.app/api/v1';

  // Request Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // --- Auth Endpoints ---
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';

  // --- User Profile ---
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String deleteAccount = '/user/account/delete';

  // --- Agents Discovery ---
  static const String onlineAgents = '/agents/online';
  static const String agentDetails = '/agents'; // + '/{agentId}'

  // --- Agora Calling & Signaling ---
  static const String initiateCall = '/calls/initiate';
  static const String endCall = '/calls/end';
  static const String callHeartbeat =
      '/calls/heartbeat'; // For per-minute coin sync
  static const String callHistory = '/calls/history';

  // --- Wallet & Coins ---
  static const String walletBalance = '/wallet/balance';
  static const String coinPackages = '/wallet/packages';
  static const String verifyPurchase = '/wallet/verify-purchase';
  static const String transactions = '/wallet/transactions';
}
