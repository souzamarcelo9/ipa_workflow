import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @notHaveAccountRegister.
  ///
  /// In en, this message translates to:
  /// **'Don\\\'t have an account? '**
  String get notHaveAccountRegister;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get createAnAccount;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @fillFieldWithYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Fill the field with your email.'**
  String get fillFieldWithYourEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email.'**
  String get invalidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fillFieldYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Fill the field with your password'**
  String get fillFieldYourPassword;

  /// No description provided for @passwordMustBeAtLeast6CharactersLong.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get passwordMustBeAtLeast6CharactersLong;

  /// No description provided for @passwordMustBeAtLeast20CharactersLong.
  ///
  /// In en, this message translates to:
  /// **'Password must be a maximum of 20 characters'**
  String get passwordMustBeAtLeast20CharactersLong;

  /// No description provided for @attention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get attention;

  /// No description provided for @errorOccurredLoggingAccount.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while logging into your account!\nPlease try again later.'**
  String get errorOccurredLoggingAccount;

  /// No description provided for @errorOccurredUpdatingProfile.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while updating profile!\nTry again later.'**
  String get errorOccurredUpdatingProfile;

  /// No description provided for @userAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'User already exists!\nDo not try again.'**
  String get userAlreadyExists;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'To enter'**
  String get enter;

  /// No description provided for @addProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a profile photo'**
  String get addProfilePhoto;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @fillFieldYourName.
  ///
  /// In en, this message translates to:
  /// **'Fill the field with your name.'**
  String get fillFieldYourName;

  /// No description provided for @nameMustHaveLeast3Characters.
  ///
  /// In en, this message translates to:
  /// **'The name must have at least 3 characters.'**
  String get nameMustHaveLeast3Characters;

  /// No description provided for @nameMustHaveMaximum30Characters.
  ///
  /// In en, this message translates to:
  /// **'The name must have a maximum of 30 characters'**
  String get nameMustHaveMaximum30Characters;

  /// No description provided for @cpf.
  ///
  /// In en, this message translates to:
  /// **'CPF'**
  String get cpf;

  /// No description provided for @fillFieldWithYourCpf.
  ///
  /// In en, this message translates to:
  /// **'Fill the field with your CPF.'**
  String get fillFieldWithYourCpf;

  /// No description provided for @invalidCpf.
  ///
  /// In en, this message translates to:
  /// **'Invalid CPF.'**
  String get invalidCpf;

  /// No description provided for @cpfMustHaveElevenDigits.
  ///
  /// In en, this message translates to:
  /// **'The CPF must have 11 digits.'**
  String get cpfMustHaveElevenDigits;

  /// No description provided for @cellPhone.
  ///
  /// In en, this message translates to:
  /// **'Cellphone'**
  String get cellPhone;

  /// No description provided for @fillFieldWithYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Fill the field with your Phone Number.'**
  String get fillFieldWithYourPhoneNumber;

  /// No description provided for @phoneMustHave14Digits.
  ///
  /// In en, this message translates to:
  /// **'Phone must have 14 digits.'**
  String get phoneMustHave14Digits;

  /// No description provided for @selectYourMaritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Select your Marital Status'**
  String get selectYourMaritalStatus;

  /// No description provided for @married.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get married;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get single;

  /// No description provided for @divorced.
  ///
  /// In en, this message translates to:
  /// **'Divorced'**
  String get divorced;

  /// No description provided for @widower.
  ///
  /// In en, this message translates to:
  /// **'Widower'**
  String get widower;

  /// No description provided for @selectYourGenre.
  ///
  /// In en, this message translates to:
  /// **'Select your Gender'**
  String get selectYourGenre;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @feminine.
  ///
  /// In en, this message translates to:
  /// **'Feminine'**
  String get feminine;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other(s)'**
  String get other;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @toGoOut.
  ///
  /// In en, this message translates to:
  /// **'To Go Out'**
  String get toGoOut;

  /// No description provided for @youWantDeleteYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get youWantDeleteYourAccount;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveEditions.
  ///
  /// In en, this message translates to:
  /// **'Save editions'**
  String get saveEditions;

  /// No description provided for @disconnectFromApp.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disconnect from the app?'**
  String get disconnectFromApp;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language below:'**
  String get selectPreferredLanguage;

  /// No description provided for @selectTheLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select the language'**
  String get selectTheLanguage;

  String get forgotMyPassword;

  String get recoverMyPassword;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
