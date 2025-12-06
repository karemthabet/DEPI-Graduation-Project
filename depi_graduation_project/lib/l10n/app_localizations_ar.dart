// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get helloWorld => 'مرحبا بك!';

  @override
  String get startJourney => 'ابدأ رحلتك المصرية';

  @override
  String get exploreSubtitle => 'استكشف العجائب القديمة والجواهر المخفية\nوالكنوز الخالدة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get continueGuest => 'المتابعة كضيف';

  @override
  String get welcomeBack => 'مرحباً،\nأهلاً بك \nمن جديد';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نصيت كلمة المرور؟';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordSubtitle => 'سنرسل لك رسالة لتعيين أو إعادة تعيين كلمة مرور جديدة';

  @override
  String get authValidation => 'البريد الإلكتروني وكلمة المرور مطلوبان';

  @override
  String get invalidCredentials => 'بيانات الاعتماد غير صالحة';

  @override
  String get verifyEmail => 'يرجى التحقق من بريدك الإلكتروني قبل تسجيل الدخول';

  @override
  String get loginSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get orContinue => 'أو تابع باستخدام';

  @override
  String get google => 'جوجل';

  @override
  String get noAccount => 'ليس لديك حساب؟ ';

  @override
  String get letsGetStarted => 'هيا \nنبدأ';

  @override
  String get name => 'الاسم';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get allFieldsRequired => 'جميع الحقول مطلوبة';

  @override
  String get passwordsNoMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get signupSuccess => 'تم إنشاء الحساب بنجاح';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get submit => 'إرسال';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get resetLinkSent => 'إذا كان الحساب موجوداً، تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني';

  @override
  String get browseByCategory => 'تصفح حسب الفئة';

  @override
  String get topRecommendations => 'أفضل التوصيات';

  @override
  String get recentlyViewed => 'شوهد مؤخراً';

  @override
  String get guest => 'زائر';

  @override
  String helloUser(String name) {
    return 'مرحبا، $name';
  }

  @override
  String get welcomeToGuidee => 'مرحبا بك في Guidee';

  @override
  String get searchHint => 'اعثر على أشياء تهمك';

  @override
  String get noCategoriesFound => 'لم يتم العثور على فئات';

  @override
  String get failedToLoadCategories => 'فشل تحميل الفئات';

  @override
  String get locationErrorTitle => 'خطأ في الموقع';

  @override
  String get cancel => 'إلغاء';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get locationServiceDisabledTitle => 'خدمة الموقع غير مفعلة';

  @override
  String get locationServiceDisabledMessage => 'يحتاج التطبيق إلى تفعيل خدمة الموقع (GPS) لعرض الأماكن القريبة منك.\n\nهل تريد تفعيل خدمة الموقع الآن؟';

  @override
  String get later => 'لاحقاً';

  @override
  String get enableLocation => 'تفعيل الموقع';

  @override
  String get permissionDeniedTitle => 'إذن الوصول للموقع';

  @override
  String get permissionDeniedMessage => 'يحتاج التطبيق إلى إذن الوصول لموقعك لعرض الأماكن القريبة منك.\n\nهل تريد منح الإذن؟';

  @override
  String get deny => 'رفض';

  @override
  String get grantPermission => 'منح الإذن';

  @override
  String get permissionDeniedForeverTitle => 'تم رفض إذن الموقع';

  @override
  String get permissionDeniedForeverMessage => 'تم رفض إذن الوصول للموقع بشكل نهائي.\n\nيرجى الذهاب إلى إعدادات التطبيق وتفعيل إذن الموقع يدوياً.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get permissionDeniedSnackBar => 'تم رفض إذن الوصول للموقع. لن يتمكن التطبيق من عرض الأماكن القريبة.';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get errorLoadingProfile => 'خطأ في تحميل الملف الشخصي. يرجى تسجيل الدخول أولاً.';

  @override
  String get goToLogin => 'الذهاب لتسجيل الدخول';

  @override
  String languageWithCode(String language) {
    return 'اللغة ($language)';
  }

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get save => 'حفظ';

  @override
  String get chooseFromGallery => 'اختر من المعرض';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get removePhoto => 'إزالة الصورة';

  @override
  String get hiddenPassword => '••••••••';

  @override
  String get enterName => 'أدخل اسمك';

  @override
  String get enterEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get favourites => 'المفضلة';

  @override
  String get loginToSeeFavorites => 'يجب تسجيل الدخول لرؤية المفضلة';

  @override
  String get noFavouritesYet => 'لا توجد عناصر مفضلة بعد';

  @override
  String get visitList => 'قائمة الزيارات';

  @override
  String get noVisitsForDay => 'لا توجد زيارات لهذا اليوم';

  @override
  String get addToVisitList => 'إضافة إلى قائمة الزيارات';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get add => 'إضافة';

  @override
  String get addedToVisitList => 'تمت الإضافة إلى قائمة الزيارات';

  @override
  String get anytime => 'في أي وقت';

  @override
  String get delete => 'حذف';

  @override
  String get markUndone => 'تعيين كغير مكتمل';

  @override
  String get markDone => 'تعيين كمكتمل';

  @override
  String get pleaseLoginFirst => 'يرجى تسجيل الدخول أولاً';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';
}
