import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get aboutFlauncher => 'Informazioni su LTv Extended';

  @override
  String get addCategory => 'Aggiungi categoria';

  @override
  String get addSection => 'Aggiungi sezione';

  @override
  String get alphabetical => 'Alfabetico';

  @override
  String get appCardHighlightAnimation => 'Animazione evidenziazione scheda app';

  @override
  String get appInfo => 'Info app';

  @override
  String get appKeyClick => 'Suono clic alla pressione del tasto';

  @override
  String get applications => 'Applicazioni';

  @override
  String get autoHideAppBar => 'Nascondi automaticamente barra di stato';

  @override
  String get backButtonAction => 'Azione pulsante Indietro';

  @override
  String get category => 'Categoria';

  @override
  String get categories => 'Categorie';

  @override
  String get columnCount => 'Numero di colonne';

  @override
  String get date => 'Data';

  @override
  String get dateAndTimeFormat => 'Formato data e ora';

  @override
  String get delete => 'Elimina';

  @override
  String get dialogOptionBackButtonActionDoNothing => 'Non fare nulla';

  @override
  String get dialogOptionBackButtonActionShowScreensaver => 'Mostra salvaschermo';

  @override
  String get dialogOptionBackButtonActionShowClock => 'Mostra orologio';

  @override
  String get dialogTextNoFileExplorer => 'Installa un file manager per selezionare un\'immagine.';

  @override
  String get dialogTitleBackButtonAction => 'Scegli l\'azione del pulsante Indietro';

  @override
  String disambiguateCategoryTitle(String title) {
    return '$title (Categoria)';
  }

  @override
  String formattedDate(String dateString) {
    return 'Data formattata: $dateString';
  }

  @override
  String formattedTime(String timeString) {
    return 'Ora formattata: $timeString';
  }

  @override
  String get gradient => 'Sfumatura';

  @override
  String get favoriteApps => 'App preferite';

  @override
  String get grid => 'Griglia';

  @override
  String get height => 'Altezza';

  @override
  String get hide => 'Nascondi';

  @override
  String get hiddenApplications => 'App nascoste';

  @override
  String get launcherSections => 'Sezioni';

  @override
  String get layout => 'Layout';

  @override
  String get loading => 'Caricamento';

  @override
  String get manual => 'Manuale';

  @override
  String get modifySection => 'Modifica sezione';

  @override
  String get mustNotBeEmpty => 'Non può essere vuoto';

  @override
  String get name => 'Nome';

  @override
  String get newSection => 'Nuova sezione';

  @override
  String get noDateFormatSpecified => 'Nessun formato data specificato';

  @override
  String get noTimeFormatSpecified => 'Nessun formato ora specificato';

  @override
  String get nonTvApplications => 'App non TV';

  @override
  String get open => 'Apri';

  @override
  String get orSelectFormatSpecifiers => 'Oppure seleziona specificatori di formato';

  @override
  String get picture => 'Immagine';

  @override
  String removeFrom(String name) {
    return 'Rimuovi da $name';
  }

  @override
  String get renameCategory => 'Rinomina categoria';

  @override
  String get reorder => 'Riordina';

  @override
  String get row => 'Riga';

  @override
  String get rowHeight => 'Altezza riga';

  @override
  String get save => 'Salva';

  @override
  String get spacer => 'Spaziatore';

  @override
  String get spacerMaxHeightRequirement => 'Deve essere maggiore di 0 e minore o uguale a 500';

  @override
  String get statusBar => 'Barra di stato';

  @override
  String get settings => 'Impostazioni';

  @override
  String get show => 'Mostra';

  @override
  String get showCategoryTitles => 'Mostra titoli delle categorie';

  @override
  String get themes => 'Temi';

  @override
  String get hideHighlightOutlineOnHomescreen => 'Nascondi contorno evidenziazione nella schermata Home';

  @override
  String get appSelectorTransitionAnimation => 'Animazione transizione selettore app';

  @override
  String get sort => 'Ordina';

  @override
  String get systemSettings => 'Impostazioni di sistema';

  @override
  String textAboutDialog(String repoUrl) {
    return 'LTv Extended è un launcher open-source personalizzato per Android TV, basato su FLauncher.\n\nBasato su LTvLauncher di LeanBitLab. Integrazioni di poster e contenuti multimediali di hamish henare (hamishakl).\nCodice sorgente: $repoUrl';
  }

  @override
  String get textEmptyCategory => 'Questa categoria è vuota.';

  @override
  String get time => 'Ora';

  @override
  String get titleStatusBarSettingsPage => 'Scegli cosa mostrare nella barra di stato';

  @override
  String get tvApplications => 'App TV';

  @override
  String get type => 'Tipo';

  @override
  String get typeInTheDateFormat => 'Inserisci il formato data';

  @override
  String get typeInTheHourFormat => 'Inserisci il formato ora';

  @override
  String get uninstall => 'Disinstalla';

  @override
  String get wallpaper => 'Sfondo';

  @override
  String get withEllipsisAddTo => 'Aggiungi a...';

  @override
  String get timeBasedWallpaper => 'Sfondo basato sull\'ora';

  @override
  String get pickDayWallpaper => 'Scegli sfondo diurno';

  @override
  String get pickNightWallpaper => 'Scegli sfondo notturno';

  @override
  String get accessibility => 'Accessibilità';

  @override
  String get defaultLauncherIsDefault => 'LTv Extended è il launcher predefinito';

  @override
  String get defaultLauncherNotDefault => 'LTv Extended non è il launcher predefinito';

  @override
  String get setAsDefaultLauncher => 'Imposta come launcher predefinito';

  @override
  String get defaultLauncherDescription => 'Quando impostato come launcher predefinito, il pulsante Home tornerà sempre a LTv Extended. La TV si avvierà direttamente su LTv Extended.';

  @override
  String get inputs => 'Ingressi';

  @override
  String get inputSources => 'Sorgenti di ingresso';

  @override
  String get backupAndRestore => 'Backup e Ripristino';

  @override
  String get exportBackup => 'Esporta Backup';

  @override
  String get importBackup => 'Importa Backup';

  @override
  String exportSuccess(String path) {
    return 'Backup esportato con successo in $path';
  }

  @override
  String get importSuccess => 'Backup importato con successo';

  @override
  String get importConfirm => 'Sei sicuro di voler importare il backup? Questo sovrascriverà le tue impostazioni e il layout attuali.';

  @override
  String importError(String error) {
    return 'Impossibile importare il backup: $error';
  }

  @override
  String exportError(String error) {
    return 'Impossibile esportare il backup: $error';
  }

  @override
  String get shareBackup => 'Condividi Backup';

  @override
  String get shareBackupDescription => 'Condividi il backup con altri dispositivi sulla rete locale';

  @override
  String get stopSharing => 'Interrompi condivisione';

  @override
  String get localNetworkSharingActive => 'La condivisione sulla rete locale è attiva!';

  @override
  String get localNetworkSharingInstructions => 'Collega un altro dispositivo alla stessa rete Wi-Fi e apri il seguente URL in un browser web:';

  @override
  String get localNetworkSharingDetails => 'Qui puoi scaricare le impostazioni/layout della tua TV o caricare un file di backup su questa TV.';

  @override
  String failedToStartServer(String error) {
    return 'Impossibile avviare il server di condivisione: $error';
  }

  @override
  String get notificationBell => 'Campanella notifiche';

  @override
  String get autoHideNotificationBell => 'Nascondi automaticamente campanella notifiche';

  @override
  String get continueWatching => 'Continua a guardare';

  @override
  String get showContinueWatchingOnHome => 'Mostra Continua a guardare nella Home';

  @override
  String get permissionDeniedContinueWatching => 'Autorizzazione richiesta per mostrare Continua a guardare';

  @override
  String get interface => 'Interfaccia';

  @override
  String get system => 'Sistema';

  @override
  String get accentColor => 'Colore primario';

  @override
  String get miscellaneous => 'Varie';

  @override
  String get brightnessScheduler => 'Pianificatore luminosità';

  @override
  String get screensaverSettings => 'Impostazioni salvaschermo';

  @override
  String get screensaverClockStyle => 'Stile orologio salvaschermo';

  @override
  String get dataUsagePeriod => 'Periodo utilizzo dati';

  @override
  String get notificationAccess => 'Accesso notifiche';

  @override
  String get granted => 'Concesso';

  @override
  String get permissionRequired => 'Autorizzazione richiesta';

  @override
  String get systemWidePopupAlert => 'Avviso popup di sistema';

  @override
  String get overlayPermissionRequired => 'Autorizzazione sovrapposizione richiesta';

  @override
  String get enabled => 'Abilitato';

  @override
  String get disabled => 'Disabilitato';

  @override
  String get showAppNamesBelowIcons => 'Mostra nomi app sotto le icone';

  @override
  String get dataUsage => 'Utilizzo dati';

  @override
  String get networkIndicator => 'Indicatore di rete';

  @override
  String get homeButtonFix => 'Fix pulsante Home (Google TV)';

  @override
  String get startOnBoot => 'Avvia all\'accensione (Google TV / Fire TV)';

  @override
  String get appLanguage => 'Lingua';

  @override
  String get systemDefault => 'Predefinito di sistema';

  @override
  String get english => 'Inglese';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get ukrainian => 'Ucraino';

  @override
  String get chinese => 'Cinese';

  @override
  String get french => 'Francese';

  @override
  String get german => 'Tedesco';

  @override
  String get japanese => 'Giapponese';

  @override
  String get portuguese => 'Portoghese';

  @override
  String get russian => 'Russo';

  @override
  String get italian => 'Italiano';

  @override
  String get hindi => 'Hindi';

  @override
  String get korean => 'Coreano';

  @override
  String get arabic => 'Arabo';

  @override
  String get turkish => 'Turco';

  @override
  String get hidePersistentNotifications => 'Nascondi notifiche persistenti';

  @override
  String get hidePersistentNotificationsDesc => 'Nascondi le notifiche dei servizi in background e di sistema';

  @override
  String get blockedNotificationApps => 'App bloccate';

  @override
  String get blockAppNotifications => 'Blocca notifiche';

  @override
  String get unblockAppNotifications => 'Sblocca notifiche';

  @override
  String get noBlockedApps => 'Nessuna app bloccata';

  @override
  String get persistentNotification => 'Persistente';

  @override
  String get unblockAll => 'Sblocca tutto';

  @override
  String get weather => 'Meteo';

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
  String get showWeatherWarnings => 'Mostra avvisi meteo e pioggia';

  @override
  String get temperatureUnit => 'Unità di temperatura';

  @override
  String get celsius => 'Celsius (°C)';

  @override
  String get fahrenheit => 'Fahrenheit (°F)';

  @override
  String get breezyWeatherSetupHint => 'Installa Breezy Weather e abilita \'Condivisione dati locali\' / \'Gadgetbridge\' nelle impostazioni per visualizzare meteo e avvisi di pioggia.';

  @override
  String get displayAndScreensaver => 'Schermo e salvaschermo';

  @override
  String get notifications => 'Notifiche';

  @override
  String get continueWatchingDescription => 'Mostra film e programmi TV visti di recente sulla schermata iniziale';

  @override
  String get continueWatchingPermissionDesc => 'È richiesta un\'autorizzazione speciale per leggere la cronologia di visualizzazione:';

  @override
  String get requestPermission => 'Richiedi autorizzazione';

  @override
  String get dismiss => 'Ignora';

  @override
  String get openApp => 'Apri';

  @override
  String get notificationOptions => 'Opzioni notifica';

  @override
  String get noBlockedAppsDesc => 'Tutte le applicazioni possono attualmente mostrare notifiche';

  @override
  String get notificationsAllowed => 'Notifiche consentite';

  @override
  String get notificationsBlocked => 'Notifiche bloccate';

  @override
  String get dpadDismissHint => 'Sinistra: Ignora • OK: Opzioni';

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
