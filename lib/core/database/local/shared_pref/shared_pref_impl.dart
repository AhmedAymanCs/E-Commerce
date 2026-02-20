// import 'package:shared_preferences/shared_preferences.dart';

// abstract class AppPreference {
//   /// Indicates whether it's the first launch of the app.
//   bool get isFirstLaunch;
//   Future<void> setFirstLaunch(bool value);
// }

// class AppPreferenceImpl implements AppPreference {
//   AppPreferenceImpl(this.appPreference);
//   final SharedPreferences appPreference;

//   /// Indicates whether it's the first launch of the app.
//   @override
//   bool get isFirstLaunch => appPreference.getBool('isFirstLaunch') ?? true;
//   @override
//   Future<void> setFirstLaunch(bool value) =>
//       appPreference.setBool('isFirstLaunch', value);
// }
