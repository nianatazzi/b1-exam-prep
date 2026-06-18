import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ru'),
  ];

  /// Generic loading indicator label
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// Shown when a network request fails
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorNetwork;

  /// Shown on auth errors
  ///
  /// In en, this message translates to:
  /// **'Authentication error. Please sign in again.'**
  String get errorAuth;

  /// Shown when a Firestore document is missing
  ///
  /// In en, this message translates to:
  /// **'Content not found'**
  String get errorNotFound;

  /// Button label to retry a failed action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Primary forward-action button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// Navigation back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Dismiss / cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save action
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Auth screen main heading
  ///
  /// In en, this message translates to:
  /// **'Welcome to LinguoByte'**
  String get authWelcomeTitle;

  /// Auth screen subheading
  ///
  /// In en, this message translates to:
  /// **'Learn a language, step by step'**
  String get authWelcomeSubtitle;

  /// Email input label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password input label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Sign-in button / tab label
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Sign-up button / tab label
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// Link to password recovery
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Password reset screen title and button
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// Confirmation after password reset email is sent
  ///
  /// In en, this message translates to:
  /// **'A reset link has been sent to your email.'**
  String get resetPasswordSent;

  /// Prompt to switch to sign-up
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// Prompt to switch to sign-in
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get hasAccount;

  /// Home screen title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// Language selection prompt on home screen
  ///
  /// In en, this message translates to:
  /// **'Choose a language'**
  String get chooseLanguage;

  /// Section header for in-progress language
  ///
  /// In en, this message translates to:
  /// **'Continue learning'**
  String get continueLearning;

  /// Lesson screen title
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get lessonTitle;

  /// Theory sub-screen label
  ///
  /// In en, this message translates to:
  /// **'Theory'**
  String get theory;

  /// Practice sub-screen label
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// Additional materials sub-screen label
  ///
  /// In en, this message translates to:
  /// **'Additional'**
  String get additional;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// User XP / points label
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// Settings section label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Sign out button
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Setting label for UI locale selection
  ///
  /// In en, this message translates to:
  /// **'Interface language'**
  String get languageLabel;

  /// Setting label for the language being studied
  ///
  /// In en, this message translates to:
  /// **'Learning language'**
  String get learningLanguageLabel;

  /// Name of the English learning language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// Name of the Spanish learning language option
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get langSpanish;

  /// Name of the French learning language option
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get langFrench;

  /// Name of the Russian learning language option
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get langRussian;

  /// Profile first name field label
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get nameLabel;

  /// Profile last name field label
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get surnameLabel;

  /// Snackbar message after successful profile save
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// Edit profile button label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editLabel;

  /// Lesson card badge — lesson completed
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusDone;

  /// Lesson card badge — lesson currently active
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statusInProgress;

  /// Lesson card badge — lesson not yet available
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get statusLocked;

  /// General label for the lexical step in lesson card and nav panel
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get lexicalSection;

  /// Label for the verbs step in lesson card and nav panel
  ///
  /// In en, this message translates to:
  /// **'Verb conjugation'**
  String get verbsSection;

  /// Label for additional materials in lesson nav panel
  ///
  /// In en, this message translates to:
  /// **'Additional materials'**
  String get additionalSection;

  /// Button/tooltip to open lesson navigation panel
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get lessonContents;

  /// Button to proceed from content to exercises in a lesson step
  ///
  /// In en, this message translates to:
  /// **'To exercises'**
  String get toExercisesButton;

  /// Advance to next exercise
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// Mark current lesson step as completed
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get completeStepButton;

  /// Shown when the user finishes all steps in a lesson
  ///
  /// In en, this message translates to:
  /// **'Lesson complete!'**
  String get lessonCompleteTitle;

  /// Shown when the user finishes the last lesson
  ///
  /// In en, this message translates to:
  /// **'Course complete!'**
  String get courseCompleteTitle;

  /// Button to return to HomeScreen after completing a lesson or course
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHomeButton;

  /// Header of the translation column in the verb conjugation table
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get verbTranslationColumn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
