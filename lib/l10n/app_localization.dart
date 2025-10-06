import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;


import 'app_localization_en.dart';
import 'app_localization_fr.dart';


// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localization.dart';
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
    Locale('fr'),
  ];

  /// No description provided for @a.
  ///
  /// In en, this message translates to:
  /// **'RUN `dart run grinder sort-translations --quiet` FOR ORDERING'**
  String get a;

  /// No description provided for @aboutHeadline.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutHeadline;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @backTooltip.
  ///
  /// In en, this message translates to:
  /// **'Return back'**
  String get backTooltip;


  /// No description provided for @btnAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get btnAdd;

  /// No description provided for @btnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnCancel;

  /// No description provided for @btnConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get btnConfirm;

  /// No description provided for @btnMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get btnMore;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Drop Value'**
  String get clear;

  /// No description provided for @closeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeTooltip;

  /// No description provided for @closedAt.
  ///
  /// In en, this message translates to:
  /// **'Finished till Date'**
  String get closedAt;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @colorTooltip.
  ///
  /// In en, this message translates to:
  /// **'Select a Color'**
  String get colorTooltip;

  /// No description provided for @confirmHeader.
  ///
  /// In en, this message translates to:
  /// **'Confirm Action'**
  String get confirmHeader;

  /// No description provided for @confirmTooltip.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? This action cannot be undone.'**
  String get confirmTooltip;

  /// No description provided for @dateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get dateTooltip;

  /// No description provided for @dtAm.
  ///
  /// In en, this message translates to:
  /// **'am'**
  String get dtAm;

  /// No description provided for @dtPm.
  ///
  /// In en, this message translates to:
  /// **'pm'**
  String get dtPm;


  /// No description provided for @helpTooltip.
  ///
  /// In en, this message translates to:
  /// **'[Help] Show Description of that Page'**
  String get helpTooltip;

  /// No description provided for @homeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeHeadline;

  /// No description provided for @homeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to Main Page'**
  String get homeTooltip;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @iconTooltip.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get iconTooltip;

  /// No description provided for @isRequired.
  ///
  /// In en, this message translates to:
  /// **'required'**
  String get isRequired;

  /// No description provided for @navigationTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open main menu'**
  String get navigationTooltip;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @orderPin.
  ///
  /// In en, this message translates to:
  /// **'Prioritized order'**
  String get orderPin;

  /// No description provided for @orderUnpin.
  ///
  /// In en, this message translates to:
  /// **'Generalized order'**
  String get orderUnpin;

  /// No description provided for @outputFile.
  ///
  /// In en, this message translates to:
  /// **'Destination for the file'**
  String get outputFile;


  /// No description provided for @returnBack.
  ///
  /// In en, this message translates to:
  /// **'Return Back'**
  String get returnBack;


  /// No description provided for @settingsHeadline.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsHeadline;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'spent'**
  String get spent;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'As an open-source project, subscribing will not unlock any additional features. However, it would serve as an investment in the continuous evolution and improvement of the application, and to preserve its availability.'**
  String get subscription;


  /// No description provided for @subscriptionHeadline.
  ///
  /// In en, this message translates to:
  /// **'Sponsorship'**
  String get subscriptionHeadline;


  /// No description provided for @tapToOpen.
  ///
  /// In en, this message translates to:
  /// **'Tap to Open'**
  String get tapToOpen;


  /// No description provided for @typeButton.
  ///
  /// In en, this message translates to:
  /// **'Button'**
  String get typeButton;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username (Account)'**
  String get username;

  /// No description provided for @uuid.
  ///
  /// In en, this message translates to:
  /// **'Unique Transaction Identifier'**
  String get uuid;

  /// No description provided for @zoomState.
  ///
  /// In en, this message translates to:
  /// **'Zoom In / Zoom Out'**
  String get zoomState;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'fr',
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    default:
      return AppLocalizationsEn();

  }

}
