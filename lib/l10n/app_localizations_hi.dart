import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get aboutFlauncher => 'LTv Extended के बारे में';

  @override
  String get addCategory => 'श्रेणी जोड़ें';

  @override
  String get addSection => 'अनुभाग जोड़ें';

  @override
  String get alphabetical => 'वर्णानुक्रम';

  @override
  String get appCardHighlightAnimation => 'ऐप कार्ड हाइलाइट एनिमेशन';

  @override
  String get appInfo => 'ऐप जानकारी';

  @override
  String get appKeyClick => 'कुंजी दबाने पर क्लिक ध्वनि';

  @override
  String get applications => 'एप्लिकेशन';

  @override
  String get autoHideAppBar => 'स्टेटस बार को स्वचालित रूप से छिपाएं';

  @override
  String get backButtonAction => 'बैक बटन एक्शन';

  @override
  String get category => 'श्रेणी';

  @override
  String get categories => 'श्रेणियाँ';

  @override
  String get columnCount => 'कॉलम संख्या';

  @override
  String get date => 'दिनांक';

  @override
  String get dateAndTimeFormat => 'दिनांक और समय प्रारूप';

  @override
  String get delete => 'हटाएं';

  @override
  String get dialogOptionBackButtonActionDoNothing => 'कुछ न करें';

  @override
  String get dialogOptionBackButtonActionShowScreensaver => 'स्क्रीनसेवर दिखाएं';

  @override
  String get dialogOptionBackButtonActionShowClock => 'घड़ी दिखाएं';

  @override
  String get dialogTextNoFileExplorer => 'कृपया चित्र चुनने के लिए फ़ाइल एक्सप्लोरर इंस्टॉल करें।';

  @override
  String get dialogTitleBackButtonAction => 'बैक बटन एक्शन चुनें';

  @override
  String disambiguateCategoryTitle(String title) {
    return '$title (श्रेणी)';
  }

  @override
  String formattedDate(String dateString) {
    return 'फ़ॉर्मेट किया गया दिनांक: $dateString';
  }

  @override
  String formattedTime(String timeString) {
    return 'फ़ॉर्मेट किया गया समय: $timeString';
  }

  @override
  String get gradient => 'ग्रेडिएंट';

  @override
  String get favoriteApps => 'पसंदीदा ऐप्स';

  @override
  String get grid => 'ग्रिड';

  @override
  String get height => 'ऊंचाई';

  @override
  String get hide => 'छिपाएं';

  @override
  String get hiddenApplications => 'छिपे हुए ऐप्स';

  @override
  String get launcherSections => 'अनुभाग';

  @override
  String get layout => 'लेआउट';

  @override
  String get loading => 'लोड हो रहा है';

  @override
  String get manual => 'मैनुअल';

  @override
  String get modifySection => 'अनुभाग संशोधित करें';

  @override
  String get mustNotBeEmpty => 'खाली नहीं होना चाहिए';

  @override
  String get name => 'नाम';

  @override
  String get newSection => 'नया अनुभाग';

  @override
  String get noDateFormatSpecified => 'कोई दिनांक प्रारूप निर्दिष्ट नहीं';

  @override
  String get noTimeFormatSpecified => 'कोई समय प्रारूप निर्दिष्ट नहीं';

  @override
  String get nonTvApplications => 'गैर-टीवी ऐप्स';

  @override
  String get open => 'खोलें';

  @override
  String get orSelectFormatSpecifiers => 'या प्रारूप निर्दिष्टकर्ता चुनें';

  @override
  String get picture => 'चित्र';

  @override
  String removeFrom(String name) {
    return '$name से हटाएं';
  }

  @override
  String get renameCategory => 'श्रेणी का नाम बदलें';

  @override
  String get reorder => 'पुन: व्यवस्थित करें';

  @override
  String get row => 'पंक्ति';

  @override
  String get rowHeight => 'पंक्ति की ऊंचाई';

  @override
  String get save => 'सहेजें';

  @override
  String get spacer => 'स्पेसर';

  @override
  String get spacerMaxHeightRequirement => '0 से अधिक और 500 से कम या बराबर होना चाहिए';

  @override
  String get statusBar => 'स्टेटस बार';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get show => 'दिखाएं';

  @override
  String get showCategoryTitles => 'श्रेणी शीर्षक दिखाएं';

  @override
  String get themes => 'थीम';

  @override
  String get hideHighlightOutlineOnHomescreen => 'होम स्क्रीन पर हाइलाइट आउटलाइन छिपाएं';

  @override
  String get appSelectorTransitionAnimation => 'ऐप सेलेक्टर ट्रांज़िशन एनिमेशन';

  @override
  String get sort => 'क्रमबद्ध करें';

  @override
  String get systemSettings => 'सिस्टम सेटिंग्स';

  @override
  String textAboutDialog(String repoUrl) {
    return 'LTv Extended FLauncher पर आधारित Android TV के लिए एक अनुकूलित ओपन-सोर्स लॉन्चर है।\n\nLeanBitLab के LTvLauncher पर आधारित। पोस्टर और मीडिया एकीकरण hamish henare (hamishakl) द्वारा।\nस्रोत कोड: $repoUrl';
  }

  @override
  String get textEmptyCategory => 'यह श्रेणी खाली है।';

  @override
  String get time => 'समय';

  @override
  String get titleStatusBarSettingsPage => 'चुनें कि स्टेटस बार में क्या दिखाना है';

  @override
  String get tvApplications => 'टीवी ऐप्स';

  @override
  String get type => 'प्रकार';

  @override
  String get typeInTheDateFormat => 'दिनांक प्रारूप टाइप करें';

  @override
  String get typeInTheHourFormat => 'समय प्रारूप टाइप करें';

  @override
  String get uninstall => 'अनइंस्टॉल करें';

  @override
  String get wallpaper => 'वॉलपेपर';

  @override
  String get withEllipsisAddTo => 'इसमें जोड़ें...';

  @override
  String get timeBasedWallpaper => 'समय आधारित वॉलपेपर';

  @override
  String get pickDayWallpaper => 'दिन का वॉलपेपर चुनें';

  @override
  String get pickNightWallpaper => 'रात का वॉलपेपर चुनें';

  @override
  String get accessibility => 'पहुंच (एक्सेसिबिलिटी)';

  @override
  String get defaultLauncherIsDefault => 'LTv Extended डिफ़ॉल्ट लॉन्चर है';

  @override
  String get defaultLauncherNotDefault => 'LTv Extended डिफ़ॉल्ट लॉन्चर नहीं है';

  @override
  String get setAsDefaultLauncher => 'डिफ़ॉल्ट लॉन्चर के रूप में सेट करें';

  @override
  String get defaultLauncherDescription => 'डिफ़ॉल्ट लॉन्चर के रूप में सेट होने पर, होम बटन हमेशा LTv Extended पर वापस आएगा। टीवी भी सीधे LTv Extended में बूट होगा।';

  @override
  String get inputs => 'इनपुट';

  @override
  String get inputSources => 'इनपुट स्रोत';

  @override
  String get backupAndRestore => 'बैकअप और पुनर्स्थापना';

  @override
  String get exportBackup => 'बैकअप निर्यात करें';

  @override
  String get importBackup => 'बैकअप आयात करें';

  @override
  String exportSuccess(String path) {
    return 'बैकअप सफलतापूर्वक $path में निर्यात किया गया';
  }

  @override
  String get importSuccess => 'बैकअप सफलतापूर्वक आयात किया गया';

  @override
  String get importConfirm => 'क्या आप वाकई बैकअप आयात करना चाहते हैं? यह आपकी वर्तमान सेटिंग्स और लेआउट को ओवरराइट कर देगा।';

  @override
  String importError(String error) {
    return 'बैकअप आयात करने में विफल: $error';
  }

  @override
  String exportError(String error) {
    return 'बैकअप निर्यात करने में विफल: $error';
  }

  @override
  String get shareBackup => 'बैकअप साझा करें';

  @override
  String get shareBackupDescription => 'स्थानीय नेटवर्क पर अन्य डिवाइसों के साथ बैकअप साझा करें';

  @override
  String get stopSharing => 'साझा करना बंद करें';

  @override
  String get localNetworkSharingActive => 'स्थानीय नेटवर्क साझाकरण सक्रिय है!';

  @override
  String get localNetworkSharingInstructions => 'किसी अन्य डिवाइस को उसी Wi-Fi नेटवर्क से कनेक्ट करें और वेब ब्राउज़र में निम्न URL खोलें:';

  @override
  String get localNetworkSharingDetails => 'यहां आप अपने टीवी की सेटिंग्स/लेआउट डाउनलोड कर सकते हैं या बैकअप फ़ाइल को इस टीवी पर वापस अपलोड कर सकते हैं।';

  @override
  String failedToStartServer(String error) {
    return 'साझाकरण सर्वर प्रारंभ करने में विफल: $error';
  }

  @override
  String get notificationBell => 'सूचना घंटी';

  @override
  String get autoHideNotificationBell => 'सूचना घंटी को स्वचालित रूप से छिपाएं';

  @override
  String get continueWatching => 'देखना जारी रखें';

  @override
  String get showContinueWatchingOnHome => 'होम पर \'देखना जारी रखें\' दिखाएं';

  @override
  String get permissionDeniedContinueWatching => '\'देखना जारी रखें\' दिखाने के लिए अनुमति आवश्यक है';

  @override
  String get interface => 'इंटरफ़ेस';

  @override
  String get system => 'सिस्टम';

  @override
  String get accentColor => 'एक्सेंट रंग';

  @override
  String get miscellaneous => 'विविध';

  @override
  String get brightnessScheduler => 'चमक शेड्यूलर';

  @override
  String get screensaverSettings => 'स्क्रीनसेवर सेटिंग्स';

  @override
  String get screensaverClockStyle => 'स्क्रीनसेवर घड़ी शैली';

  @override
  String get dataUsagePeriod => 'डेटा उपयोग अवधि';

  @override
  String get notificationAccess => 'सूचना पहुंच';

  @override
  String get granted => 'प्रदान किया गया';

  @override
  String get permissionRequired => 'अनुमति आवश्यक है';

  @override
  String get systemWidePopupAlert => 'सिस्टम-वाइड पॉपअप अलर्ट';

  @override
  String get overlayPermissionRequired => 'ओवरले अनुमति आवश्यक है';

  @override
  String get enabled => 'सक्षम';

  @override
  String get disabled => 'अक्षम';

  @override
  String get showAppNamesBelowIcons => 'आइकन के नीचे ऐप नाम दिखाएं';

  @override
  String get dataUsage => 'डेटा उपयोग';

  @override
  String get networkIndicator => 'नेटवर्क संकेतक';

  @override
  String get homeButtonFix => 'होम बटन फिक्स (Google TV)';

  @override
  String get startOnBoot => 'बूट पर शुरू करें (Google TV / Fire TV)';

  @override
  String get appLanguage => 'भाषा';

  @override
  String get systemDefault => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get spanish => 'स्पेनिश';

  @override
  String get ukrainian => 'यूक्रेनियन';

  @override
  String get chinese => 'चीनी';

  @override
  String get french => 'फ्रेंच';

  @override
  String get german => 'जर्मन';

  @override
  String get japanese => 'जापानी';

  @override
  String get portuguese => 'पुर्तगाली';

  @override
  String get russian => 'रूसी';

  @override
  String get italian => 'इतालवी';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get korean => 'कोरियाई';

  @override
  String get arabic => 'अरबी';

  @override
  String get turkish => 'तुर्की';

  @override
  String get hidePersistentNotifications => 'स्थायी सूचनाएं छिपाएं';

  @override
  String get hidePersistentNotificationsDesc => 'पृष्ठभूमि सेवा और सिस्टम सूचनाएं छिपाएं';

  @override
  String get blockedNotificationApps => 'अवरुद्ध ऐप्स';

  @override
  String get blockAppNotifications => 'सूचनाएं अवरुद्ध करें';

  @override
  String get unblockAppNotifications => 'सूचनाएं अनब्लॉक करें';

  @override
  String get noBlockedApps => 'कोई अवरुद्ध ऐप नहीं';

  @override
  String get persistentNotification => 'स्थायी';

  @override
  String get unblockAll => 'सभी अनब्लॉक करें';

  @override
  String get weather => 'मौसम';

  @override
  String get showWeatherHighLow => 'Show today\'s high and low';

  @override
  String get showWeatherRainChance => 'Show today\'s rain / snow chance';

  @override
  String weatherRainChance(int chance) {
    return 'Precip. $chance%';
  }

  @override
  String get weatherLocation => 'Weather location';

  @override
  String get weatherAutomatic => 'Clear location / use Breezy Weather';

  @override
  String get weatherLocationHint => 'Search for your city to use Open-Meteo weather at that location.';

  @override
  String get searchWeatherCity => 'City or postal code';

  @override
  String get weatherSearch => 'Search';

  @override
  String get weatherNoLocations => 'No locations found. Try a city name or postal code.';

  @override
  String get weatherSearchFailed => 'Could not search locations. Check your connection and try again.';

  @override
  String get weatherSetupHint => 'Choose a location above to show weather from Open-Meteo. You can also use an existing Breezy Weather configuration.';

  @override
  String get showWeatherWarnings => 'मौसम और बारिश की चेतावनी दिखाएं';

  @override
  String get temperatureUnit => 'तापमान इकाई';

  @override
  String get celsius => 'सेल्सियस (°C)';

  @override
  String get fahrenheit => 'फ़ारेनहाइट (°F)';

  @override
  String get breezyWeatherSetupHint => 'मौसम और बारिश की चेतावनी देखने के लिए Breezy Weather इंस्टॉल करें और उसकी सेटिंग्स में \'स्थानीय डेटा साझाकरण\' सक्षम करें।';

  @override
  String get displayAndScreensaver => 'डिस्प्ले और स्क्रीनसेवर';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get continueWatchingDescription => 'होम स्क्रीन पर हाल ही में देखी गई फिल्में और टीवी शो दिखाएं';

  @override
  String get continueWatchingPermissionDesc => 'टीवी ऐप्स से देखने का इतिहास पढ़ने के लिए विशेष अनुमति की आवश्यकता है:';

  @override
  String get requestPermission => 'अनुमति का अनुरोध करें';

  @override
  String get dismiss => 'हटाएं';

  @override
  String get openApp => 'खोलें';

  @override
  String get notificationOptions => 'सूचना विकल्प';

  @override
  String get noBlockedAppsDesc => 'सभी ऐप्स को वर्तमान में सूचनाएं दिखाने की अनुमति है';

  @override
  String get notificationsAllowed => 'सूचनाएं चालू हैं';

  @override
  String get notificationsBlocked => 'सूचनाएं अवरुद्ध हैं';

  @override
  String get dpadDismissHint => 'बायां: हटाएं • ठीक है: विकल्प';

  @override
  String get configureWeather => 'Click to configure weather';

  @override
  String get weatherSettings => 'Weather settings';

  @override
  String get weatherNoLocation => 'No location selected';

  @override
  String get weatherUpdating => 'Updating weather…';

  @override
  String get weatherUnavailable => 'Weather unavailable';

  @override
  String get updatesTitle => 'Updates';

  @override
  String get updatesAvailable => 'Update available';

  @override
  String get updatesAutomatic => 'Check automatically';

  @override
  String get updatesAutomaticHint => 'Check GitHub once a day while the launcher is open. Updates appear here; downloads start only when you choose them.';

  @override
  String get updatesCheck => 'Check for updates';

  @override
  String get updatesChecking => 'Checking…';

  @override
  String updatesInstalled(String version) {
    return 'Installed: $version';
  }

  @override
  String updatesLastChecked(String date) {
    return 'Last checked: $date';
  }

  @override
  String updatesNewVersion(String version) {
    return 'Update available: $version';
  }

  @override
  String get updatesUpToDate => 'You are up to date';

  @override
  String get updatesNoReleases => 'No published releases yet';

  @override
  String get updatesChangelog => 'What’s new';

  @override
  String get updatesDebugHint => 'Updates cannot be installed in LTv Extended (Debug). Open LTv Extended to download and install release updates. You can read changelogs here.';

  @override
  String get updatesLegacyHint => 'This older release has no in-app update metadata. Download it from the project’s GitHub Releases page.';

  @override
  String updatesDownload(String size) {
    return 'Download update ($size)';
  }

  @override
  String updatesDownloading(String percent) {
    return 'Downloading: $percent%';
  }

  @override
  String get updatesCancel => 'Cancel download';

  @override
  String get updatesCancelled => 'Download cancelled';

  @override
  String get updatesVerifying => 'Verifying update…';

  @override
  String get updatesInstall => 'Install update';

  @override
  String get updatesAllowInstalls => 'Allow updates from this app';

  @override
  String get updatesPermissionHint => 'Allow this app to install unknown apps in Android settings, then return here and choose Install update.';

  @override
  String get updatesInstallerOpened => 'Finish installation in Android’s confirmation screen. If you cancelled, you can try again.';

  @override
  String get updatesHistory => 'Release history';

  @override
  String get updatesScrollHint => 'Up / Down: scroll • OK: close';

  @override
  String get updatesNoNotes => 'No changelog was provided for this release.';

  @override
  String get updatesClose => 'Close';

  @override
  String get updatesNetworkError => 'Could not connect to GitHub or download the update. Check your connection and try again.';

  @override
  String get updatesRateLimit => 'GitHub’s request limit was reached. Please try again later.';

  @override
  String get updatesMetadataError => 'This release has invalid update information. Please try again later.';

  @override
  String get updatesIntegrityError => 'The download is incomplete or could not be verified. Download it again.';

  @override
  String get updatesSignatureError => 'This APK is not signed for your installed app. Install updates from the same source as your current installation.';

  @override
  String get updatesVersionError => 'This APK does not contain a newer matching version.';

  @override
  String get updatesSdkError => 'This update requires a newer Android version.';

  @override
  String get updatesInstallerError => 'Android’s installer or install settings could not be opened on this device.';
}
