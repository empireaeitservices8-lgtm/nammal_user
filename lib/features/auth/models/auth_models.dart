class LogoutResponse {
  final String message;

  const LogoutResponse({required this.message});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      message: (json['message'] ?? 'Logout successful').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'message': message};
}

class DeleteAccountResponse {
  final String status;
  final String message;

  const DeleteAccountResponse({
    required this.status,
    required this.message,
  });

  bool get isSuccess => status.toLowerCase() == 'success';

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponse(
      status: (json['status'] ?? 'success').toString(),
      message: (json['message'] ??
              'Your account has been deleted successfully.')
          .toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
      };
}

class SendOtpResponse {
  final String status;
  final String message;
  final String phoneNumber;
  final String? otp;
  final int otpLength;
  final int resendAfter;
  final bool isExistingUser;

  const SendOtpResponse({
    required this.status,
    required this.message,
    required this.phoneNumber,
    this.otp,
    this.otpLength = 4,
    this.resendAfter = 45,
    this.isExistingUser = false,
  });

  bool get isSuccess => status.toLowerCase() == 'success';

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      status: (json['status'] ?? 'success').toString(),
      message: (json['message'] ?? 'OTP sent successfully').toString(),
      phoneNumber: (json['phone_number'] ?? json['phone'] ?? '').toString(),
      otp: json['otp']?.toString(),
      otpLength: json['otp_length'] is int
          ? json['otp_length'] as int
          : int.tryParse(json['otp_length']?.toString() ?? '4') ?? 4,
      resendAfter: json['resend_after'] is int
          ? json['resend_after'] as int
          : int.tryParse(json['resend_after']?.toString() ?? '45') ?? 45,
      isExistingUser: json['is_existing_user'] == true,
    );
  }
}

class UserProfileDetails {
  final int id;
  final String name;
  final int? age;
  final String? dateOfBirth;
  final String? dateOfBirthDisplay;
  final String? gender;
  final String? bio;
  final String? profilePicture;
  final String? phoneNumber;
  final bool isVerified;

  const UserProfileDetails({
    required this.id,
    required this.name,
    this.age,
    this.dateOfBirth,
    this.dateOfBirthDisplay,
    this.gender,
    this.bio,
    this.profilePicture,
    this.phoneNumber,
    this.isVerified = false,
  });

  factory UserProfileDetails.fromJson(Map<String, dynamic> json) {
    return UserProfileDetails(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['name'] ?? '').toString(),
      age: json['age'] is int
          ? json['age'] as int
          : int.tryParse(json['age']?.toString() ?? ''),
      dateOfBirth: json['date_of_birth']?.toString(),
      dateOfBirthDisplay: json['date_of_birth_display']?.toString(),
      gender: json['gender']?.toString(),
      bio: json['bio']?.toString(),
      profilePicture: json['profile_picture']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      isVerified: json['is_verified'] == true,
    );
  }
}

class UserModel {
  final int id;
  final String username;
  final String? email;
  final String phoneNumber;
  final String name;
  final int? age;
  final String? gender;
  final bool isOnline;
  final bool isOnCall;
  final int coins;
  final String? createdAt;
  final bool isAgent;
  final String role;
  final String? agentStatus;
  final UserProfileDetails? profile;

  const UserModel({
    required this.id,
    required this.username,
    this.email,
    required this.phoneNumber,
    required this.name,
    this.age,
    this.gender,
    this.isOnline = true,
    this.isOnCall = false,
    this.coins = 0,
    this.createdAt,
    this.isAgent = false,
    this.role = 'user',
    this.agentStatus,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      username: (json['username'] ?? '').toString(),
      email: json['email']?.toString(),
      phoneNumber: (json['phone_number'] ?? json['phone'] ?? '').toString(),
      name: (json['name'] ?? json['first_name'] ?? '').toString(),
      age: json['age'] is int
          ? json['age'] as int
          : int.tryParse(json['age']?.toString() ?? ''),
      gender: json['gender']?.toString(),
      isOnline: json['is_online'] != false,
      isOnCall: json['is_on_call'] == true,
      coins: json['coins'] is int
          ? json['coins'] as int
          : int.tryParse(json['coins']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at']?.toString(),
      isAgent: json['is_agent'] == true,
      role: (json['role'] ?? 'user').toString(),
      agentStatus: json['agent_status']?.toString(),
      profile: json['profile'] is Map<String, dynamic>
          ? UserProfileDetails.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'name': name,
      'age': age,
      'gender': gender,
      'is_online': isOnline,
      'is_on_call': isOnCall,
      'coins': coins,
      'is_agent': isAgent,
      'role': role,
    };
  }
}

class VerifyOtpResponse {
  final String? token;
  final String role;
  final bool isAgent;
  final String? agentStatus;
  final String phoneNumber;
  final String? name;
  final int? age;
  final String? gender;
  final UserModel? user;
  final String message;
  final String status;
  final bool otpVerified;
  final bool isExistingUser;
  final String nextStep; // "home" or "onboarding"

  const VerifyOtpResponse({
    this.token,
    this.role = 'user',
    this.isAgent = false,
    this.agentStatus,
    required this.phoneNumber,
    this.name,
    this.age,
    this.gender,
    this.user,
    required this.message,
    required this.status,
    this.otpVerified = false,
    this.isExistingUser = false,
    this.nextStep = 'home',
  });

  bool get isSuccess =>
      status.toLowerCase() == 'success' || otpVerified || token != null;

  /// Check if the user should go directly to home or to onboarding
  bool get shouldGoToHome => isExistingUser || nextStep.toLowerCase() == 'home';

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : null;

    final token = json['token']?.toString();
    final isExisting = json['is_existing_user'] == true;
    final nextStep = (json['next_step'] ?? (isExisting ? 'home' : 'onboarding'))
        .toString();

    return VerifyOtpResponse(
      token: token,
      role: (json['role'] ?? 'user').toString(),
      isAgent: json['is_agent'] == true,
      agentStatus: json['agent_status']?.toString(),
      phoneNumber: (json['phone_number'] ?? '').toString(),
      name: json['name']?.toString() ?? userJson?['name']?.toString(),
      age: json['age'] is int
          ? json['age'] as int
          : int.tryParse(json['age']?.toString() ?? ''),
      gender: json['gender']?.toString() ?? userJson?['gender']?.toString(),
      user: userJson != null ? UserModel.fromJson(userJson) : null,
      message: (json['message'] ?? 'OTP verified').toString(),
      status: (json['status'] ?? 'success').toString(),
      otpVerified: json['otp_verified'] == true || token != null,
      isExistingUser: isExisting,
      nextStep: nextStep,
    );
  }
}

class RegisterUserRequest {
  final String phoneNumber;
  final String firstName;
  final String gender;
  final String day;
  final String month;
  final String year;
  final String? fcmToken;

  const RegisterUserRequest({
    required this.phoneNumber,
    required this.firstName,
    required this.gender,
    required this.day,
    required this.month,
    required this.year,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'first_name': firstName,
      'gender': gender,
      'day': day,
      'month': month,
      'year': year,
      if (fcmToken != null && fcmToken!.isNotEmpty) 'fcm_token': fcmToken,
    };
  }
}
