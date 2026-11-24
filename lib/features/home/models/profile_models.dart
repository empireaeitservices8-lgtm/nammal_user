class ProfileUserModel {
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

  const ProfileUserModel({
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
  });

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      username: (json['username'] ?? '').toString(),
      email: json['email']?.toString(),
      phoneNumber: (json['phone_number'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      age: json['age'] is int
          ? json['age'] as int
          : int.tryParse(json['age']?.toString() ?? ''),
      gender: json['gender']?.toString(),
      isOnline: json['is_online'] == true,
      isOnCall: json['is_on_call'] == true,
      coins: json['coins'] is int
          ? json['coins'] as int
          : int.tryParse(json['coins']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at']?.toString(),
      isAgent: json['is_agent'] == true,
      role: (json['role'] ?? 'user').toString(),
      agentStatus: json['agent_status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
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
        'created_at': createdAt,
        'is_agent': isAgent,
        'role': role,
        'agent_status': agentStatus,
      };
}

class UserProfileDataModel {
  final int id;
  final String name;
  final int? age;
  final String? dateOfBirth;
  final String? dateOfBirthDisplay;
  final String? gender;
  final String? phoneNumber;
  final String? bio;
  final String? profilePicture;
  final bool isVerified;
  final String? createdAt;
  final String? updatedAt;
  final ProfileUserModel? user;

  const UserProfileDataModel({
    required this.id,
    required this.name,
    this.age,
    this.dateOfBirth,
    this.dateOfBirthDisplay,
    this.gender,
    this.phoneNumber,
    this.bio,
    this.profilePicture,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory UserProfileDataModel.fromJson(Map<String, dynamic> json) {
    return UserProfileDataModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['name'] ?? json['user']?['name'] ?? '').toString(),
      age: json['age'] is int
          ? json['age'] as int
          : int.tryParse(json['age']?.toString() ?? ''),
      dateOfBirth: json['date_of_birth']?.toString(),
      dateOfBirthDisplay: json['date_of_birth_display']?.toString(),
      gender: json['gender']?.toString(),
      phoneNumber: (json['phone_number'] ?? json['user']?['phone_number'])?.toString(),
      bio: (json['bio'] ?? '').toString(),
      profilePicture: json['profile_picture']?.toString(),
      isVerified: json['is_verified'] == true,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      user: json['user'] is Map<String, dynamic>
          ? ProfileUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'date_of_birth': dateOfBirth,
        'date_of_birth_display': dateOfBirthDisplay,
        'gender': gender,
        'phone_number': phoneNumber,
        'bio': bio,
        'profile_picture': profilePicture,
        'is_verified': isVerified,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'user': user?.toJson(),
      };
}

class UserProfileResponse {
  final String status;
  final UserProfileDataModel profile;
  final int coins;
  final bool isOnline;
  final bool isOnCall;
  final bool isVerified;
  final int unreadNotifications;
  final String role;

  const UserProfileResponse({
    required this.status,
    required this.profile,
    this.coins = 0,
    this.isOnline = true,
    this.isOnCall = false,
    this.isVerified = false,
    this.unreadNotifications = 0,
    this.role = 'user',
  });

  bool get isSuccess => status.toLowerCase() == 'success';

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      status: (json['status'] ?? 'success').toString(),
      profile: json['profile'] is Map<String, dynamic>
          ? UserProfileDataModel.fromJson(json['profile'] as Map<String, dynamic>)
          : const UserProfileDataModel(id: 0, name: ''),
      coins: json['coins'] is int
          ? json['coins'] as int
          : int.tryParse(json['coins']?.toString() ?? '0') ?? 0,
      isOnline: json['is_online'] == true,
      isOnCall: json['is_on_call'] == true,
      isVerified: json['is_verified'] == true,
      unreadNotifications: json['unread_notifications'] is int
          ? json['unread_notifications'] as int
          : int.tryParse(json['unread_notifications']?.toString() ?? '0') ?? 0,
      role: (json['role'] ?? 'user').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'profile': profile.toJson(),
        'coins': coins,
        'is_online': isOnline,
        'is_on_call': isOnCall,
        'is_verified': isVerified,
        'unread_notifications': unreadNotifications,
        'role': role,
      };
}

class UpdateProfileResponse {
  final String status;
  final String message;
  final UserProfileDataModel profile;

  const UpdateProfileResponse({
    required this.status,
    required this.message,
    required this.profile,
  });

  bool get isSuccess => status.toLowerCase() == 'success';

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      status: (json['status'] ?? 'success').toString(),
      message: (json['message'] ?? 'Profile updated successfully').toString(),
      profile: json['profile'] is Map<String, dynamic>
          ? UserProfileDataModel.fromJson(
              json['profile'] as Map<String, dynamic>)
          : const UserProfileDataModel(id: 0, name: ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'profile': profile.toJson(),
      };
}
