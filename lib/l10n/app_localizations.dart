import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('uk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ProKariera'**
  String get appTitle;

  /// No description provided for @menuAbout.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get menuAbout;

  /// No description provided for @menuServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get menuServices;

  /// No description provided for @menuAvgs.
  ///
  /// In en, this message translates to:
  /// **'AVGS'**
  String get menuAvgs;

  /// No description provided for @menuHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get menuHowItWorks;

  /// No description provided for @menuTestimonials.
  ///
  /// In en, this message translates to:
  /// **'Testimonials'**
  String get menuTestimonials;

  /// No description provided for @menuContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get menuContact;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Career Coaching with Heart'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I help Ukrainians realize their professional dreams\nFree consultation via AVGS'**
  String get heroSubtitle;

  /// No description provided for @heroButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up for Free Consultation'**
  String get heroButton;

  /// No description provided for @introTitle.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m a Career Coach'**
  String get introTitle;

  /// No description provided for @introText.
  ///
  /// In en, this message translates to:
  /// **'I\'m Valeria, a certified career coach. I help Ukrainians in Germany with applications, CVs, interview prep, and career development.'**
  String get introText;

  String get introText2;

  /// No description provided for @advantagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Benefits with Me:'**
  String get advantagesTitle;

  /// No description provided for @advantage1.
  ///
  /// In en, this message translates to:
  /// **'Individual Approach'**
  String get advantage;

  /// No description provided for @servicesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Services'**
  String get servicesTitle;

  /// No description provided for @service1Title.
  ///
  /// In en, this message translates to:
  /// **'Career Path Analysis'**
  String get service1Title;

  /// No description provided for @service1Desc.
  ///
  /// In en, this message translates to:
  /// **'We define your career goal and steps to achieve it'**
  String get service1Desc;

  /// No description provided for @service2Title.
  ///
  /// In en, this message translates to:
  /// **'CV Creation'**
  String get service2Title;

  /// No description provided for @service2Desc.
  ///
  /// In en, this message translates to:
  /// **'I help craft an effective CV for the German job market.'**
  String get service2Desc;

  /// No description provided for @service3Title.
  ///
  /// In en, this message translates to:
  /// **'Interview Preparation'**
  String get service3Title;

  /// No description provided for @service3Desc.
  ///
  /// In en, this message translates to:
  /// **'We practice confident answers to employer questions.'**
  String get service3Desc;

  /// No description provided for @service4Title.
  ///
  /// In en, this message translates to:
  /// **'Job Search Training'**
  String get service4Title;

  /// No description provided for @service4Desc.
  ///
  /// In en, this message translates to:
  /// **'I teach effective methods for finding jobs in Germany.'**
  String get service4Desc;

  /// No description provided for @service5Title.
  ///
  /// In en, this message translates to:
  /// **'AVGS Support'**
  String get service5Title;

  /// No description provided for @service5Desc.
  ///
  /// In en, this message translates to:
  /// **'I explain how to obtain the coupon and start free coaching.'**
  String get service5Desc;

  /// No description provided for @service6Title.
  ///
  /// In en, this message translates to:
  /// **'Individual Consultations'**

  /// No description provided for @service6Desc.
  ///
  /// In en, this message translates to:
  /// **'Personal sessions to address specific career questions.'**

  /// No description provided for @avgsTitle.
  ///
  /// In en, this message translates to:
  /// **'AVGS – Free Career Coaching'**
  String get avgsTitle;

  /// No description provided for @avgsText.
  ///
  /// In en, this message translates to:
  /// **'AVGS (Activation and Placement Voucher) is a government coupon for free career coaching.'**
  String get avgsText;

  /// No description provided for @avgsHelp1.
  ///
  /// In en, this message translates to:
  /// **'Get the voucher from the Jobcenter / Employment Agency'**
  ///
  String get avgsHelp;

  String get avgsHelp1;

  /// No description provided for @avgsHelp2.
  ///
  /// In en, this message translates to:
  /// **'Understand how the funding works'**
  String get avgsHelp2;

  /// No description provided for @avgsHelp3.
  ///
  /// In en, this message translates to:
  /// **'Start individual sessions with me — for free'**
  String get avgsHelp3;

  /// No description provided for @avgsButton.
  ///
  /// In en, this message translates to:
  /// **'Don\'t wait — check your AVGS eligibility!'**
  String get avgsButton;

  /// No description provided for @howItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How Our Collaboration Works'**
  String get howItWorksTitle;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'1 Request'**
  String get step1Title;

  /// No description provided for @step1Desc.
  ///
  /// In en, this message translates to:
  /// **'You send a request — I contact you to discuss the format.'**
  String get step1Desc;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'2 Consultation'**
  String get step2Title;

  /// No description provided for @step2Desc.
  ///
  /// In en, this message translates to:
  /// **'We define your goals and needs and choose the direction.'**
  String get step2Desc;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'3 Work'**
  String get step3Title;

  /// No description provided for @step3Desc.
  ///
  /// In en, this message translates to:
  /// **'We work on your CV, interview prep, and career development.'**
  String get step3Desc;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'4 Result'**
  String get step4Title;

  /// No description provided for @step4Desc.
  ///
  /// In en, this message translates to:
  /// **'You move confidently toward your goal with a clear action plan.'**
  String get step4Desc;

  /// No description provided for @testimonialsTitle.
  ///
  /// In en, this message translates to:
  /// **'Testimonials'**
  String get testimonialsTitle;

  /// No description provided for @contactTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave a Message'**
  String get contactTitle;

  /// No description provided for @contactNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get contactNameLabel;

  /// No description provided for @contactEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get contactEmailLabel;

  /// No description provided for @contactMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get contactMessageLabel;

  /// No description provided for @contactSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get contactSendButton;

  /// No description provided for @contactInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInfoTitle;

  /// No description provided for @contactEmail.
  ///
  /// In en, this message translates to:
  /// **'hello@prokariera.de'**
  String get contactEmail;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'+49 123 456 789'**
  String get contactPhone;

  /// Price section
  String get priceTitle; // "Preis" / "Вартість"
  String
  get priceCard; // "Privates Coaching — 100 € (bis zu 90 Min.)" / "Приватний коучинг — 100 € (до 90 хв)"
  String get azavNote;

  /// AVGS-Status section
  String get avgsStatusTitle; // "AVGS-Status" / "Статус AVGS"
  String get avgsStatusText; // короткий статус AZAV
  String get avgsStatusFaqTitle; // "Was ist AVGS?" / "Що таке AVGS?"
  String get avgsStatusFaqAnswer; // краткий ответ

  ///faq
  String get faqTitle;
  String get faqQ1;
  String get faqA1;
  String get faqQ2;
  String get faqA2;
  String get faqQ3;
  String get faqA3;
  String get faqQ4;
  String get faqA4;
  String get faqQ5;
  String get faqA5;
  String get faqQ6;
  String get faqA6;
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
      <String>['de', 'en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
