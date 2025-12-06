// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get startJourney => 'Start Your Egyptian Journey';

  @override
  String get exploreSubtitle =>
      'Explore ancient wonders, hidden gems,\nand timeless treasures';

  @override
  String get login => 'Log In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get continueGuest => 'Continue as Guest';

  @override
  String get welcomeBack => 'Hey,\nWelcome \nBack';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forget Password?';

  @override
  String get forgotPasswordTitle => 'Forgot password?';

  @override
  String get forgotPasswordSubtitle =>
      'We will send you a message to set or reset your new password';

  @override
  String get authValidation => 'Email and password are required';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get verifyEmail => 'Please verify your email before signing in';

  @override
  String get loginSuccess => 'Sign in successful';

  @override
  String get orContinue => 'Or continue with';

  @override
  String get google => 'Google';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get letsGetStarted => 'Let\'s get\nstarted';

  @override
  String get name => 'Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get allFieldsRequired => 'All fields are required';

  @override
  String get passwordsNoMatch => 'Passwords do not match';

  @override
  String get signupSuccess => 'Sign up successful';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get submit => 'Submit';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get resetLinkSent =>
      'If an account exists, a password reset link has been sent to your email';

  @override
  String get browseByCategory => 'Browse By Category';

  @override
  String get topRecommendations => 'Top Recommendations';

  @override
  String get recentlyViewed => 'Recently Viewed';

  @override
  String get guest => 'Guest';

  @override
  String helloUser(String name) {
    return 'Hello, $name';
  }

  @override
  String get welcomeToGuidee => 'Welcome to Guidee';

  @override
  String get searchHint => 'Find things you\'re interested in';

  @override
  String get noCategoriesFound => 'No Categories Found';

  @override
  String get failedToLoadCategories => 'Failed to load categories';

  @override
  String get locationErrorTitle => 'Location Error';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get locationServiceDisabledTitle => 'Location Service Disabled';

  @override
  String get locationServiceDisabledMessage =>
      'The app needs location services enabled to show nearby places.\n\nDo you want to enable it now?';

  @override
  String get later => 'Later';

  @override
  String get enableLocation => 'Enable Location';

  @override
  String get permissionDeniedTitle => 'Location Permission Denied';

  @override
  String get permissionDeniedMessage =>
      'The app needs location permission to show nearby places.\n\nDo you want to grant permission?';

  @override
  String get deny => 'Deny';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get permissionDeniedForeverTitle =>
      'Location Permission Denied Forever';

  @override
  String get permissionDeniedForeverMessage =>
      'Location permission is permanently denied.\n\nPlease go to settings and enable it manually.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get permissionDeniedSnackBar =>
      'Location permission denied. The app cannot show nearby places.';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get errorLoadingProfile =>
      'Error loading profile. Please log in first.';

  @override
  String get goToLogin => 'Go to Login';

  @override
  String languageWithCode(String language) {
    return 'Language ($language)';
  }

  @override
  String get logOut => 'Log out';

  @override
  String get save => 'Save';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get takePhoto => 'Take a Photo';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get hiddenPassword => '••••••••';

  @override
  String get enterName => 'Enter your name';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get favourites => 'Favourites';

  @override
  String get loginToSeeFavorites => 'You must log in to see your favourites';

  @override
  String get noFavouritesYet => 'No favourites yet';

  @override
  String get visitList => 'Visit List';

  @override
  String get noVisitsForDay => 'No visits for this day';

  @override
  String get addToVisitList => 'Add To Visit List';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get add => 'Add';

  @override
  String get addedToVisitList => 'Added to Visit List';

  @override
  String get anytime => 'Anytime';

  @override
  String get delete => 'Delete';

  @override
  String get markUndone => 'Mark Undone';

  @override
  String get markDone => 'Mark Done';

  @override
  String get pleaseLoginFirst => 'Please login first';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';
}
