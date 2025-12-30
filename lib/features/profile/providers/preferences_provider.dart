import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPreferences {
  final List<String> styles;
  final String height;
  final String weight;
  final bool notificationsEnabled;

  UserPreferences({
    this.styles = const ["Streetwear", "Minimalist"],
    this.height = "180cm",
    this.weight = "75kg",
    this.notificationsEnabled = true,
  });

  UserPreferences copyWith({
    List<String>? styles,
    String? height,
    String? weight,
    bool? notificationsEnabled,
  }) {
    return UserPreferences(
      styles: styles ?? this.styles,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class PreferencesNotifier extends Notifier<UserPreferences> {
  @override
  UserPreferences build() {
    return UserPreferences();
  }

  void setStyles(List<String> styles) => state = state.copyWith(styles: styles);
  void setHeight(String height) => state = state.copyWith(height: height);
  void setWeight(String weight) => state = state.copyWith(weight: weight);
  void toggleNotifications(bool enabled) =>
      state = state.copyWith(notificationsEnabled: enabled);
}

final preferencesProvider =
    NotifierProvider<PreferencesNotifier, UserPreferences>(() {
      return PreferencesNotifier();
    });
