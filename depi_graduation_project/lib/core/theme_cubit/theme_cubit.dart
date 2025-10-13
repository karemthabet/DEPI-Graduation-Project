import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants/app_constants.dart';
import 'theme_cubit_state.dart';

class ThemeCubit extends Cubit<ThemeCubitState> {
  final GetStorage _box = GetStorage();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  ThemeCubit() : super(LightThemeState()) {
    getCurrentTheme();
  }

  Future<void> getCurrentTheme() async {
    try {
      // First try to get from secure storage
      final secureValue = await _secureStorage.read(key: AppConstants.kIsDarkMode);
      bool? isDark;
      
      if (secureValue != null) {
        isDark = secureValue.toLowerCase() == 'true';
      } else {
        // Fallback to GetStorage if not found in secure storage
        isDark = _box.read<bool>(AppConstants.kIsDarkMode);
      }
      
      if (isDark == true) {
        emit(DarkThemeState());
      } else {
        emit(LightThemeState());
      }
    } catch (e) {
      // Default to light theme if there's an error
      debugPrint('Error getting theme: $e');
      emit(LightThemeState());
    }
  }

  Future<void> toggleTheme() async {
    try {
      final isDark = state is DarkThemeState;
      final newValue = !isDark;
      
      // Save to both secure storage and GetStorage for redundancy
      await _secureStorage.write(
        key: AppConstants.kIsDarkMode,
        value: newValue.toString(),
      );
      await _box.write(AppConstants.kIsDarkMode, newValue);
      
      getCurrentTheme();
    } catch (e) {
      debugPrint('Error toggling theme: $e');
      // Re-throw the error to be handled by the UI if needed
      rethrow;
    }
  }
}
