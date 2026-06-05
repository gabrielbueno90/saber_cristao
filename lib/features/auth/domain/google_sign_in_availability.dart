enum GoogleSignInAvailability {
  enabled,
  disabledByFlag,
  supabaseNotConfigured,
  providerDisabled,
  settingsRequestFailed,
  unknownError,
}

extension GoogleSignInAvailabilityX on GoogleSignInAvailability {
  String get label => switch (this) {
        GoogleSignInAvailability.enabled => 'enabled',
        GoogleSignInAvailability.disabledByFlag => 'disabledByFlag',
        GoogleSignInAvailability.supabaseNotConfigured => 'supabaseNotConfigured',
        GoogleSignInAvailability.providerDisabled => 'providerDisabled',
        GoogleSignInAvailability.settingsRequestFailed => 'settingsRequestFailed',
        GoogleSignInAvailability.unknownError => 'unknownError',
      };
}
