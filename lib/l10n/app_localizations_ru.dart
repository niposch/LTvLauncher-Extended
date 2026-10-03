import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get aboutFlauncher => 'О программе LTv Extended';

  @override
  String get addCategory => 'Добавить категорию';

  @override
  String get addSection => 'Добавить раздел';

  @override
  String get alphabetical => 'По алфавиту';

  @override
  String get appCardHighlightAnimation => 'Анимация выделения карточки приложения';

  @override
  String get appInfo => 'Информация о приложении';

  @override
  String get appKeyClick => 'Звук нажатия клавиши';

  @override
  String get applications => 'Приложения';

  @override
  String get autoHideAppBar => 'Автоскрытие строки состояния';

  @override
  String get backButtonAction => 'Действие кнопки назад';

  @override
  String get category => 'Категория';

  @override
  String get categories => 'Категории';

  @override
  String get columnCount => 'Количество столбцов';

  @override
  String get date => 'Дата';

  @override
  String get dateAndTimeFormat => 'Формат даты и времени';

  @override
  String get delete => 'Удалить';

  @override
  String get dialogOptionBackButtonActionDoNothing => 'Ничего не делать';

  @override
  String get dialogOptionBackButtonActionShowScreensaver => 'Показать заставку';

  @override
  String get dialogOptionBackButtonActionShowClock => 'Показать часы';

  @override
  String get dialogTextNoFileExplorer => 'Пожалуйста, установите файловый менеджер, чтобы выбрать изображение.';

  @override
  String get dialogTitleBackButtonAction => 'Выберите действие кнопки назад';

  @override
  String disambiguateCategoryTitle(String title) {
    return '$title (Категория)';
  }

  @override
  String formattedDate(String dateString) {
    return 'Форматированная дата: $dateString';
  }

  @override
  String formattedTime(String timeString) {
    return 'Форматированное время: $timeString';
  }

  @override
  String get gradient => 'Градиент';

  @override
  String get favoriteApps => 'Избранные приложения';

  @override
  String get grid => 'Сетка';

  @override
  String get height => 'Высота';

  @override
  String get hide => 'Скрыть';

  @override
  String get hiddenApplications => 'Скрытые приложения';

  @override
  String get launcherSections => 'Разделы';

  @override
  String get layout => 'Макет';

  @override
  String get loading => 'Загрузка';

  @override
  String get manual => 'Вручную';

  @override
  String get modifySection => 'Изменить раздел';

  @override
  String get mustNotBeEmpty => 'Не должно быть пустым';

  @override
  String get name => 'Имя';

  @override
  String get newSection => 'Новый раздел';

  @override
  String get noDateFormatSpecified => 'Формат даты не указан';

  @override
  String get noTimeFormatSpecified => 'Формат времени не указан';

  @override
  String get nonTvApplications => 'Приложения не для ТВ';

  @override
  String get open => 'Открыть';

  @override
  String get orSelectFormatSpecifiers => 'Или выберите спецификаторы формата';

  @override
  String get picture => 'Изображение';

  @override
  String removeFrom(String name) {
    return 'Удалить из $name';
  }

  @override
  String get renameCategory => 'Переименовать категорию';

  @override
  String get reorder => 'Изменить порядок';

  @override
  String get row => 'Строка';

  @override
  String get rowHeight => 'Высота строки';

  @override
  String get save => 'Сохранить';

  @override
  String get spacer => 'Разделитель';

  @override
  String get spacerMaxHeightRequirement => 'Должно быть больше 0 и меньше или равно 500';

  @override
  String get statusBar => 'Строка состояния';

  @override
  String get settings => 'Настройки';

  @override
  String get show => 'Показать';

  @override
  String get showCategoryTitles => 'Показывать заголовки категорий';

  @override
  String get themes => 'Темы';

  @override
  String get hideHighlightOutlineOnHomescreen => 'Скрыть контур выделения на главном экране';

  @override
  String get appSelectorTransitionAnimation => 'Анимация перехода селектора приложений';

  @override
  String get sort => 'Сортировать';

  @override
  String get systemSettings => 'Системные настройки';

  @override
  String textAboutDialog(String repoUrl) {
    return 'LTv Extended — это настраиваемый лаунчер с открытым исходным кодом для Android TV, основанный на FLauncher.\n\nОснован на LTvLauncher от LeanBitLab. Интеграции постеров и медиа от hamish henare (hamishakl).\nИсходный код: $repoUrl';
  }

  @override
  String get textEmptyCategory => 'Эта категория пуста.';

  @override
  String get time => 'Время';

  @override
  String get titleStatusBarSettingsPage => 'Выберите, что отображать в строке состояния';

  @override
  String get tvApplications => 'ТВ-приложения';

  @override
  String get type => 'Тип';

  @override
  String get typeInTheDateFormat => 'Введите формат даты';

  @override
  String get typeInTheHourFormat => 'Введите формат времени';

  @override
  String get uninstall => 'Удалить';

  @override
  String get wallpaper => 'Обои';

  @override
  String get withEllipsisAddTo => 'Добавить в...';

  @override
  String get timeBasedWallpaper => 'Обои в зависимости от времени';

  @override
  String get pickDayWallpaper => 'Выбрать дневные обои';

  @override
  String get pickNightWallpaper => 'Выбрать ночные обои';

  @override
  String get accessibility => 'Специальные возможности';

  @override
  String get defaultLauncherIsDefault => 'LTv Extended является лаунчером по умолчанию';

  @override
  String get defaultLauncherNotDefault => 'LTv Extended не является лаунчером по умолчанию';

  @override
  String get setAsDefaultLauncher => 'Установить как лаунчер по умолчанию';

  @override
  String get defaultLauncherDescription => 'При установке в качестве лаунчера по умолчанию кнопка «Домой» всегда будет возвращать к LTv Extended. ТВ также будет загружаться напрямую в LTv Extended.';

  @override
  String get inputs => 'Входы';

  @override
  String get inputSources => 'Источники ввода';

  @override
  String get backupAndRestore => 'Резервное копирование и восстановление';

  @override
  String get exportBackup => 'Экспорт резервной копии';

  @override
  String get importBackup => 'Импорт резервной копии';

  @override
  String exportSuccess(String path) {
    return 'Резервная копия успешно экспортирована в $path';
  }

  @override
  String get importSuccess => 'Резервная копия успешно импортирована';

  @override
  String get importConfirm => 'Вы уверены, что хотите импортировать резервную копию? Это перезапишет ваши текущие настройки и макет.';

  @override
  String importError(String error) {
    return 'Не удалось импортировать резервную копию: $error';
  }

  @override
  String exportError(String error) {
    return 'Не удалось экспортировать резервную копию: $error';
  }

  @override
  String get shareBackup => 'Поделиться резервной копией';

  @override
  String get shareBackupDescription => 'Поделиться резервной копией с другими устройствами в локальной сети';

  @override
  String get stopSharing => 'Остановить доступ';

  @override
  String get localNetworkSharingActive => 'Доступ в локальной сети активен!';

  @override
  String get localNetworkSharingInstructions => 'Подключите другое устройство к той же сети Wi-Fi и откройте следующий URL-адрес в веб-браузере:';

  @override
  String get localNetworkSharingDetails => 'Здесь вы можете скачать настройки/макет вашего ТВ или загрузить файл резервной копии обратно на этот ТВ.';

  @override
  String failedToStartServer(String error) {
    return 'Не удалось запустить сервер общего доступа: $error';
  }

  @override
  String get notificationBell => 'Колокольчик уведомлений';

  @override
  String get autoHideNotificationBell => 'Автоскрытие колокольчика уведомлений';

  @override
  String get continueWatching => 'Продолжить просмотр';

  @override
  String get showContinueWatchingOnHome => 'Показывать «Продолжить просмотр» на главном экране';

  @override
  String get permissionDeniedContinueWatching => 'Требуется разрешение для показа «Продолжить просмотр»';

  @override
  String get interface => 'Интерфейс';

  @override
  String get system => 'Система';

  @override
  String get accentColor => 'Акцентный цвет';

  @override
  String get miscellaneous => 'Разное';

  @override
  String get brightnessScheduler => 'Планировщик яркости';

  @override
  String get screensaverSettings => 'Настройки заставки';

  @override
  String get screensaverClockStyle => 'Стиль часов заставки';

  @override
  String get dataUsagePeriod => 'Период использования данных';

  @override
  String get notificationAccess => 'Доступ к уведомлениям';

  @override
  String get granted => 'Предоставлено';

  @override
  String get permissionRequired => 'Требуется разрешение';

  @override
  String get systemWidePopupAlert => 'Системное всплывающее предупреждение';

  @override
  String get overlayPermissionRequired => 'Требуется разрешение на наложение';

  @override
  String get enabled => 'Включено';

  @override
  String get disabled => 'Отключено';

  @override
  String get showAppNamesBelowIcons => 'Показывать названия приложений под значками';

  @override
  String get dataUsage => 'Использование данных';

  @override
  String get networkIndicator => 'Индикатор сети';

  @override
  String get homeButtonFix => 'Исправление кнопки «Домой» (Google TV)';

  @override
  String get startOnBoot => 'Запускать при включении (Google TV / Fire TV)';

  @override
  String get appLanguage => 'Язык';

  @override
  String get systemDefault => 'Системный по умолчанию';

  @override
  String get english => 'Английский';

  @override
  String get spanish => 'Испанский';

  @override
  String get ukrainian => 'Украинский';

  @override
  String get chinese => 'Китайский';

  @override
  String get french => 'Французский';

  @override
  String get german => 'Немецкий';

  @override
  String get japanese => 'Японский';

  @override
  String get portuguese => 'Португальский';

  @override
  String get russian => 'Русский';

  @override
  String get italian => 'Итальянский';

  @override
  String get hindi => 'Хинди';

  @override
  String get korean => 'Корейский';

  @override
  String get arabic => 'Арабский';

  @override
  String get turkish => 'Турецкий';

  @override
  String get hidePersistentNotifications => 'Скрыть постоянные уведомления';

  @override
  String get hidePersistentNotificationsDesc => 'Скрывать фоновые и системные уведомления';

  @override
  String get blockedNotificationApps => 'Заблокированные приложения';

  @override
  String get blockAppNotifications => 'Блокировать уведомления';

  @override
  String get unblockAppNotifications => 'Разблокировать уведомления';

  @override
  String get noBlockedApps => 'Нет заблокированных приложений';

  @override
  String get persistentNotification => 'Постоянное';

  @override
  String get unblockAll => 'Разблокировать все';

  @override
  String get weather => 'Погода';

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
  String get showWeatherWarnings => 'Показывать предупреждения о погоде и дожде';

  @override
  String get temperatureUnit => 'Единица температуры';

  @override
  String get celsius => 'Цельсий (°C)';

  @override
  String get fahrenheit => 'Фаренгейт (°F)';

  @override
  String get breezyWeatherSetupHint => 'Установите Breezy Weather и включите \'Локальный обмен данными\' / \'Gadgetbridge\' в его настройках для отображения погоды и предупреждений.';

  @override
  String get displayAndScreensaver => 'Экран и заставка';

  @override
  String get notifications => 'Уведомления';

  @override
  String get continueWatchingDescription => 'Показывать недавно просмотренные фильмы и передачи на главном экране';

  @override
  String get continueWatchingPermissionDesc => 'Для чтения истории просмотров из ТВ-приложений требуется специальное разрешение:';

  @override
  String get requestPermission => 'Запросить разрешение';

  @override
  String get dismiss => 'Закрыть';

  @override
  String get openApp => 'Открыть';

  @override
  String get notificationOptions => 'Параметры уведомления';

  @override
  String get noBlockedAppsDesc => 'Всем приложениям в данный момент разрешено показывать уведомления';

  @override
  String get notificationsAllowed => 'Уведомления разрешены';

  @override
  String get notificationsBlocked => 'Уведомления заблокированы';

  @override
  String get dpadDismissHint => 'Влево: Закрыть • OK: Параметры';

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
  String get updatesDebugHint => 'This is a debug build. You can read release notes, but release updates cannot replace it.';

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
