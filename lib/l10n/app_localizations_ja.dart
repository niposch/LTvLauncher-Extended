import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get aboutFlauncher => 'LTv Extendedについて';

  @override
  String get addCategory => 'カテゴリを追加';

  @override
  String get addSection => 'セクションを追加';

  @override
  String get alphabetical => 'アルファベット順';

  @override
  String get appCardHighlightAnimation => 'アプリカードのハイライトアニメーション';

  @override
  String get appInfo => 'アプリ情報';

  @override
  String get appKeyClick => 'キー押下時のクリック音';

  @override
  String get applications => 'アプリケーション';

  @override
  String get autoHideAppBar => 'ステータスバーを自動非表示';

  @override
  String get backButtonAction => '戻るボタンの動作';

  @override
  String get category => 'カテゴリ';

  @override
  String get categories => 'カテゴリ';

  @override
  String get columnCount => '列数';

  @override
  String get date => '日付';

  @override
  String get dateAndTimeFormat => '日付と時刻の形式';

  @override
  String get delete => '削除';

  @override
  String get dialogOptionBackButtonActionDoNothing => '何もしない';

  @override
  String get dialogOptionBackButtonActionShowScreensaver => 'スクリーンセーバーを表示';

  @override
  String get dialogOptionBackButtonActionShowClock => '時計を表示';

  @override
  String get dialogTextNoFileExplorer => '画像を選択するにはファイルエクスプローラーをインストールしてください。';

  @override
  String get dialogTitleBackButtonAction => '戻るボタンの動作を選択';

  @override
  String disambiguateCategoryTitle(String title) {
    return '$title (カテゴリ)';
  }

  @override
  String formattedDate(String dateString) {
    return '書式化された日付: $dateString';
  }

  @override
  String formattedTime(String timeString) {
    return '書式化された時刻: $timeString';
  }

  @override
  String get gradient => 'グラデーション';

  @override
  String get favoriteApps => 'お気に入りアプリ';

  @override
  String get grid => 'グリッド';

  @override
  String get height => '高さ';

  @override
  String get hide => '非表示';

  @override
  String get hiddenApplications => '非表示のアプリ';

  @override
  String get launcherSections => 'セクション';

  @override
  String get layout => 'レイアウト';

  @override
  String get loading => '読み込み中';

  @override
  String get manual => '手動';

  @override
  String get modifySection => 'セクションを変更';

  @override
  String get mustNotBeEmpty => '空にすることはできません';

  @override
  String get name => '名前';

  @override
  String get newSection => '新しいセクション';

  @override
  String get noDateFormatSpecified => '日付形式が指定されていません';

  @override
  String get noTimeFormatSpecified => '時刻形式が指定されていません';

  @override
  String get nonTvApplications => '非TVアプリ';

  @override
  String get open => '開く';

  @override
  String get orSelectFormatSpecifiers => 'または形式指定子を選択';

  @override
  String get picture => '画像';

  @override
  String removeFrom(String name) {
    return '$nameから削除';
  }

  @override
  String get renameCategory => 'カテゴリ名を変更';

  @override
  String get reorder => '並べ替え';

  @override
  String get row => '行';

  @override
  String get rowHeight => '行の高さ';

  @override
  String get save => '保存';

  @override
  String get spacer => 'スペーサー';

  @override
  String get spacerMaxHeightRequirement => '0より大きく500以下である必要があります';

  @override
  String get statusBar => 'ステータスバー';

  @override
  String get settings => '設定';

  @override
  String get show => '表示';

  @override
  String get showCategoryTitles => 'カテゴリタイトルを表示';

  @override
  String get themes => 'テーマ';

  @override
  String get hideHighlightOutlineOnHomescreen => 'ホーム画面でハイライトのアウトラインを非表示';

  @override
  String get appSelectorTransitionAnimation => 'アプリセレクターの遷移アニメーション';

  @override
  String get sort => '並べ替え';

  @override
  String get systemSettings => 'システム設定';

  @override
  String textAboutDialog(String repoUrl) {
    return 'LTv ExtendedはFLauncherをベースにしたAndroid TV用のカスタムオープンソースランチャーです。\n\nLeanBitLab の LTvLauncher を基にしています。ポスターとメディアの統合は hamish henare (hamishakl) によるものです。\nソースコード: $repoUrl';
  }

  @override
  String get textEmptyCategory => 'このカテゴリは空です。';

  @override
  String get time => '時刻';

  @override
  String get titleStatusBarSettingsPage => 'ステータスバーに表示するものを選択';

  @override
  String get tvApplications => 'TVアプリ';

  @override
  String get type => '種類';

  @override
  String get typeInTheDateFormat => '日付形式を入力';

  @override
  String get typeInTheHourFormat => '時刻形式を入力';

  @override
  String get uninstall => 'アンインストール';

  @override
  String get wallpaper => '壁紙';

  @override
  String get withEllipsisAddTo => '追加...';

  @override
  String get timeBasedWallpaper => '時間ベースの壁紙';

  @override
  String get pickDayWallpaper => '昼の壁紙を選択';

  @override
  String get pickNightWallpaper => '夜の壁紙を選択';

  @override
  String get accessibility => 'アクセシビリティ';

  @override
  String get defaultLauncherIsDefault => 'LTv Extendedはデフォルトのランチャーです';

  @override
  String get defaultLauncherNotDefault => 'LTv Extendedはデフォルトのランチャーではありません';

  @override
  String get setAsDefaultLauncher => 'デフォルトのランチャーに設定';

  @override
  String get defaultLauncherDescription => 'デフォルトのランチャーに設定すると、ホームボタンは常にLTv Extendedに戻ります。TVの起動時も直接LTv Extendedが起動します。';

  @override
  String get inputs => '入力';

  @override
  String get inputSources => '入力ソース';

  @override
  String get backupAndRestore => 'バックアップと復元';

  @override
  String get exportBackup => 'バックアップをエクスポート';

  @override
  String get importBackup => 'バックアップをインポート';

  @override
  String exportSuccess(String path) {
    return 'バックアップが$pathに正常にエクスポートされました';
  }

  @override
  String get importSuccess => 'バックアップが正常にインポートされました';

  @override
  String get importConfirm => 'バックアップをインポートしますか？現在の設定とレイアウトが上書きされます。';

  @override
  String importError(String error) {
    return 'バックアップのインポートに失敗しました: $error';
  }

  @override
  String exportError(String error) {
    return 'バックアップのエクスポートに失敗しました: $error';
  }

  @override
  String get shareBackup => 'バックアップを共有';

  @override
  String get shareBackupDescription => 'ローカルネットワーク上の他のデバイスとバックアップを共有';

  @override
  String get stopSharing => '共有を停止';

  @override
  String get localNetworkSharingActive => 'ローカルネットワーク共有が有効です！';

  @override
  String get localNetworkSharingInstructions => '他のデバイスを同じWi-Fiネットワークに接続し、Webブラウザで次のURLを開きます：';

  @override
  String get localNetworkSharingDetails => 'ここでTVの設定/レイアウトをダウンロードするか、バックアップファイルをこのTVにアップロードできます。';

  @override
  String failedToStartServer(String error) {
    return '共有サーバーの起動に失敗しました: $error';
  }

  @override
  String get notificationBell => '通知ベル';

  @override
  String get autoHideNotificationBell => '通知ベルを自動非表示';

  @override
  String get continueWatching => '続きを見る';

  @override
  String get showContinueWatchingOnHome => 'ホームに「続きを見る」を表示';

  @override
  String get permissionDeniedContinueWatching => '「続きを見る」を表示するには権限が必要です';

  @override
  String get interface => 'インターフェース';

  @override
  String get system => 'システム';

  @override
  String get accentColor => 'アクセントカラー';

  @override
  String get miscellaneous => 'その他';

  @override
  String get brightnessScheduler => '明るさスケジューラー';

  @override
  String get screensaverSettings => 'スクリーンセーバー設定';

  @override
  String get screensaverClockStyle => 'スクリーンセーバー時計スタイル';

  @override
  String get dataUsagePeriod => 'データ使用期間';

  @override
  String get notificationAccess => '通知アクセス';

  @override
  String get granted => '許可済み';

  @override
  String get permissionRequired => '権限が必要です';

  @override
  String get systemWidePopupAlert => 'システム全体のポップアップアラート';

  @override
  String get overlayPermissionRequired => 'オーバーレイ権限が必要です';

  @override
  String get enabled => '有効';

  @override
  String get disabled => '無効';

  @override
  String get showAppNamesBelowIcons => 'アイコンの下にアプリ名を表示';

  @override
  String get dataUsage => 'データ使用量';

  @override
  String get networkIndicator => 'ネットワークインジケーター';

  @override
  String get homeButtonFix => 'ホームボタン修正 (Google TV)';

  @override
  String get startOnBoot => '起動時に開始 (Google TV / Fire TV)';

  @override
  String get appLanguage => '言語';

  @override
  String get systemDefault => 'システムのデフォルト';

  @override
  String get english => '英語';

  @override
  String get spanish => 'スペイン語';

  @override
  String get ukrainian => 'ウクライナ語';

  @override
  String get chinese => '中国語';

  @override
  String get french => 'フランス語';

  @override
  String get german => 'ドイツ語';

  @override
  String get japanese => '日本語';

  @override
  String get portuguese => 'ポルトガル語';

  @override
  String get russian => 'ロシア語';

  @override
  String get italian => 'イタリア語';

  @override
  String get hindi => 'ヒンディー語';

  @override
  String get korean => '韓国語';

  @override
  String get arabic => 'アラビア語';

  @override
  String get turkish => 'トルコ語';

  @override
  String get hidePersistentNotifications => '常駐通知を非表示';

  @override
  String get hidePersistentNotificationsDesc => 'バックグラウンドサービスやシステムの常駐通知を非表示';

  @override
  String get blockedNotificationApps => 'ブロックされたアプリ';

  @override
  String get blockAppNotifications => '通知をブロック';

  @override
  String get unblockAppNotifications => '通知のブロックを解除';

  @override
  String get noBlockedApps => 'ブロックされたアプリはありません';

  @override
  String get persistentNotification => '常駐';

  @override
  String get unblockAll => 'すべてブロック解除';

  @override
  String get weather => '天気';

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
  String get showWeatherWarnings => '天気と雨の警告を表示';

  @override
  String get temperatureUnit => '温度単位';

  @override
  String get celsius => '摂氏 (°C)';

  @override
  String get fahrenheit => '華氏 (°F)';

  @override
  String get breezyWeatherSetupHint => 'Breezy Weather をインストールし、設定で「ローカルデータ共有」/「Gadgetbridge」を有効にすると、天気と雨の警告が表示されます。';

  @override
  String get displayAndScreensaver => 'ディスプレイとスクリーンセーバー';

  @override
  String get notifications => '通知';

  @override
  String get continueWatchingDescription => 'ホーム画面に最近再生した映画や番組を表示します';

  @override
  String get continueWatchingPermissionDesc => 'TVアプリの視聴履歴を読み取るには特別な権限が必要です:';

  @override
  String get requestPermission => '権限をリクエスト';

  @override
  String get dismiss => '非表示';

  @override
  String get openApp => '開く';

  @override
  String get notificationOptions => '通知のオプション';

  @override
  String get noBlockedAppsDesc => '現在、すべてのアプリで通知の表示が許可されています';

  @override
  String get notificationsAllowed => '通知を許可';

  @override
  String get notificationsBlocked => '通知をブロック';

  @override
  String get dpadDismissHint => '左: 非表示 • OK: オプション';

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
