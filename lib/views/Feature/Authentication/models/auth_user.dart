class AuthUser {
  const AuthUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    this.vehiclePlate,
    this.isEmailVerified = false,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final String? vehiclePlate;
  final bool isEmailVerified;

  String get fullName {
    final name = [
      firstName,
      lastName,
    ].where((part) => part.trim().isNotEmpty).join(' ');
    return name.isEmpty ? 'Parkealo User' : name;
  }

  String get initials {
    final value =
        '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';
    return value.isEmpty ? 'P' : value.toUpperCase();
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      email: json['email']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      vehiclePlate: json['vehiclePlate']?.toString(),
      isEmailVerified: json['isEmailVerified'] == true,
    );
  }
}

class AccountProfile {
  const AccountProfile({
    required this.user,
    required this.fullName,
    required this.licensePlateLabel,
    required this.licensePlateRegistered,
    required this.emailVerifiedLabel,
  });

  final AuthUser user;
  final String fullName;
  final String licensePlateLabel;
  final bool licensePlateRegistered;
  final String emailVerifiedLabel;

  factory AccountProfile.fromJson(Map<String, dynamic> json) {
    final profile = Map<String, dynamic>.from(json);
    final licensePlateStatus = profile['licensePlateStatus'] is Map
        ? Map<String, dynamic>.from(profile['licensePlateStatus'] as Map)
        : <String, dynamic>{};
    final emailVerification = profile['emailVerification'] is Map
        ? Map<String, dynamic>.from(profile['emailVerification'] as Map)
        : <String, dynamic>{};

    return AccountProfile(
      user: AuthUser.fromJson(profile),
      fullName: (profile['fullName'] ?? '').toString(),
      licensePlateLabel:
          (licensePlateStatus['label'] ??
                  profile['vehiclePlate'] ??
                  'No license plate registered')
              .toString(),
      licensePlateRegistered:
          licensePlateStatus['registered'] == true ||
          profile['vehiclePlate'] != null,
      emailVerifiedLabel:
          (emailVerification['label'] ??
                  (profile['isEmailVerified'] == true
                      ? 'Verified'
                      : 'Not verified'))
              .toString(),
    );
  }
}
