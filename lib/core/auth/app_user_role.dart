enum AppUserRole {
  influencer,
  business,
  user,
}

AppUserRole appUserRoleFromValue(String? value) {
  switch (value?.trim().toLowerCase()) {
    case 'influencer':
      return AppUserRole.influencer;
    case 'business':
      return AppUserRole.business;
    default:
      return AppUserRole.user;
  }
}

extension AppUserRoleValue on AppUserRole {
  String get value {
    switch (this) {
      case AppUserRole.influencer:
        return 'influencer';
      case AppUserRole.business:
        return 'business';
      case AppUserRole.user:
        return 'user';
    }
  }

  String get label {
    switch (this) {
      case AppUserRole.influencer:
        return 'Influencer';
      case AppUserRole.business:
        return 'Business';
      case AppUserRole.user:
        return 'User';
    }
  }
}
