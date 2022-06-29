
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
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
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
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
    Locale('es')
  ];

  /// No description provided for @lets_cooking.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Cooking'**
  String get lets_cooking;

  /// No description provided for @slogan.
  ///
  /// In en, this message translates to:
  /// **'Find the best food recipes'**
  String get slogan;

  /// No description provided for @main_title.
  ///
  /// In en, this message translates to:
  /// **'Find best recipes for cooking'**
  String get main_title;

  /// No description provided for @trending_now.
  ///
  /// In en, this message translates to:
  /// **'Trending now'**
  String get trending_now;

  /// No description provided for @see_all.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get see_all;

  /// No description provided for @popular_categories.
  ///
  /// In en, this message translates to:
  /// **'Popular by category'**
  String get popular_categories;

  /// No description provided for @no_results.
  ///
  /// In en, this message translates to:
  /// **'No Results'**
  String get no_results;

  /// No description provided for @recent_recipes.
  ///
  /// In en, this message translates to:
  /// **'Recent recipes'**
  String get recent_recipes;

  /// No description provided for @popular_creators.
  ///
  /// In en, this message translates to:
  /// **'Popular creators'**
  String get popular_creators;

  /// No description provided for @saved_recipes.
  ///
  /// In en, this message translates to:
  /// **'Saved recipes'**
  String get saved_recipes;

  /// No description provided for @main_photo.
  ///
  /// In en, this message translates to:
  /// **'Main Photo'**
  String get main_photo;

  /// No description provided for @serves.
  ///
  /// In en, this message translates to:
  /// **'Serves'**
  String get serves;

  /// No description provided for @cooking_time.
  ///
  /// In en, this message translates to:
  /// **'Cooking time'**
  String get cooking_time;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @item_name.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get item_name;

  /// No description provided for @add_new_ingredient.
  ///
  /// In en, this message translates to:
  /// **'Add new ingredient'**
  String get add_new_ingredient;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @steps_to_follow.
  ///
  /// In en, this message translates to:
  /// **'Steps to follow'**
  String get steps_to_follow;

  /// No description provided for @uploaded_photo.
  ///
  /// In en, this message translates to:
  /// **'Uploaded photo'**
  String get uploaded_photo;

  /// No description provided for @add_another_step.
  ///
  /// In en, this message translates to:
  /// **'Add another step'**
  String get add_another_step;

  /// No description provided for @save_recipe.
  ///
  /// In en, this message translates to:
  /// **'Save Recipe'**
  String get save_recipe;

  /// No description provided for @my_profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get my_profile;

  /// No description provided for @recipe.
  ///
  /// In en, this message translates to:
  /// **'Recipe'**
  String get recipe;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @select_image_from.
  ///
  /// In en, this message translates to:
  /// **'Select Image From'**
  String get select_image_from;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @select_categories.
  ///
  /// In en, this message translates to:
  /// **'Select Categories'**
  String get select_categories;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @order_by.
  ///
  /// In en, this message translates to:
  /// **'Order By'**
  String get order_by;

  /// No description provided for @search_recipe.
  ///
  /// In en, this message translates to:
  /// **'Search Recipes'**
  String get search_recipe;

  /// No description provided for @select_type.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get select_type;

  /// No description provided for @recipes_by_creator.
  ///
  /// In en, this message translates to:
  /// **'Recipes By Creator'**
  String get recipes_by_creator;

  /// No description provided for @rate_it.
  ///
  /// In en, this message translates to:
  /// **'Rate it'**
  String get rate_it;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @trending_recipes.
  ///
  /// In en, this message translates to:
  /// **'Trending Recipes'**
  String get trending_recipes;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
