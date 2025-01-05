part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsReset extends SettingsEvent {
  const SettingsReset();
}

class ReauthenticateAndDeleteAccount extends SettingsEvent {
  final String id;
  final String email;
  final String password;

  ReauthenticateAndDeleteAccount({
    required this.id,
    required this.email,
    required this.password,
  });
}

class LoadSettings extends SettingsEvent {
  final User user;

  const LoadSettings({required this.user});

  @override
  List<Object?> get props => [user];
}

class SettingsConnectDiscord extends SettingsEvent {
  final User user;
  final String discordId;

  const SettingsConnectDiscord({required this.user, required this.discordId});

  @override
  List<Object> get props => [user, discordId];
}
