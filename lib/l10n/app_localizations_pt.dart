import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get aboutFlauncher => 'Sobre o LTv Extended';

  @override
  String get addCategory => 'Adicionar categoria';

  @override
  String get addSection => 'Adicionar seção';

  @override
  String get alphabetical => 'Alfabético';

  @override
  String get appCardHighlightAnimation => 'Animação de destaque do cartão do app';

  @override
  String get appInfo => 'Informações do app';

  @override
  String get appKeyClick => 'Som de clique ao pressionar tecla';

  @override
  String get applications => 'Aplicativos';

  @override
  String get autoHideAppBar => 'Ocultar barra de status automaticamente';

  @override
  String get backButtonAction => 'Ação do botão voltar';

  @override
  String get category => 'Categoria';

  @override
  String get categories => 'Categorias';

  @override
  String get columnCount => 'Contagem de colunas';

  @override
  String get date => 'Data';

  @override
  String get dateAndTimeFormat => 'Formato de data e hora';

  @override
  String get delete => 'Excluir';

  @override
  String get dialogOptionBackButtonActionDoNothing => 'Não fazer nada';

  @override
  String get dialogOptionBackButtonActionShowScreensaver => 'Mostrar protetor de tela';

  @override
  String get dialogOptionBackButtonActionShowClock => 'Mostrar relógio';

  @override
  String get dialogTextNoFileExplorer => 'Por favor, instale um explorador de arquivos para escolher uma imagem.';

  @override
  String get dialogTitleBackButtonAction => 'Escolha a ação do botão voltar';

  @override
  String disambiguateCategoryTitle(String title) {
    return '$title (Categoria)';
  }

  @override
  String formattedDate(String dateString) {
    return 'Data formatada: $dateString';
  }

  @override
  String formattedTime(String timeString) {
    return 'Hora formatada: $timeString';
  }

  @override
  String get gradient => 'Gradiente';

  @override
  String get favoriteApps => 'Apps favoritos';

  @override
  String get grid => 'Grade';

  @override
  String get height => 'Altura';

  @override
  String get hide => 'Ocultar';

  @override
  String get hiddenApplications => 'Apps ocultos';

  @override
  String get launcherSections => 'Seções';

  @override
  String get layout => 'Layout';

  @override
  String get loading => 'Carregando';

  @override
  String get manual => 'Manual';

  @override
  String get modifySection => 'Modificar seção';

  @override
  String get mustNotBeEmpty => 'Não pode estar vazio';

  @override
  String get name => 'Nome';

  @override
  String get newSection => 'Nova seção';

  @override
  String get noDateFormatSpecified => 'Nenhum formato de data especificado';

  @override
  String get noTimeFormatSpecified => 'Nenhum formato de hora especificado';

  @override
  String get nonTvApplications => 'Apps não-TV';

  @override
  String get open => 'Abrir';

  @override
  String get orSelectFormatSpecifiers => 'Ou selecione especificadores de formato';

  @override
  String get picture => 'Imagem';

  @override
  String removeFrom(String name) {
    return 'Remover de $name';
  }

  @override
  String get renameCategory => 'Renomear categoria';

  @override
  String get reorder => 'Reordenar';

  @override
  String get row => 'Linha';

  @override
  String get rowHeight => 'Altura da linha';

  @override
  String get save => 'Salvar';

  @override
  String get spacer => 'Espaçador';

  @override
  String get spacerMaxHeightRequirement => 'Deve ser maior que 0 e menor ou igual a 500';

  @override
  String get statusBar => 'Barra de status';

  @override
  String get settings => 'Configurações';

  @override
  String get show => 'Mostrar';

  @override
  String get showCategoryTitles => 'Mostrar títulos das categorias';

  @override
  String get themes => 'Temas';

  @override
  String get hideHighlightOutlineOnHomescreen => 'Ocultar contorno de destaque na tela inicial';

  @override
  String get appSelectorTransitionAnimation => 'Animação de transição do seletor de apps';

  @override
  String get sort => 'Ordenar';

  @override
  String get systemSettings => 'Configurações do sistema';

  @override
  String textAboutDialog(String repoUrl) {
    return 'O LTv Extended é um launcher open-source personalizado para Android TV, baseado no FLauncher.\n\nBaseado no LTvLauncher da LeanBitLab. Integrações de pôsteres e mídia por hamish henare (hamishakl).\nCódigo-fonte: $repoUrl';
  }

  @override
  String get textEmptyCategory => 'Esta categoria está vazia.';

  @override
  String get time => 'Hora';

  @override
  String get titleStatusBarSettingsPage => 'Escolha o que exibir na barra de status';

  @override
  String get tvApplications => 'Apps de TV';

  @override
  String get type => 'Tipo';

  @override
  String get typeInTheDateFormat => 'Digite o formato de data';

  @override
  String get typeInTheHourFormat => 'Digite o formato de hora';

  @override
  String get uninstall => 'Desinstalar';

  @override
  String get wallpaper => 'Papel de parede';

  @override
  String get withEllipsisAddTo => 'Adicionar a...';

  @override
  String get timeBasedWallpaper => 'Papel de parede baseado no tempo';

  @override
  String get pickDayWallpaper => 'Escolher papel de parede diurno';

  @override
  String get pickNightWallpaper => 'Escolher papel de parede noturno';

  @override
  String get accessibility => 'Acessibilidade';

  @override
  String get defaultLauncherIsDefault => 'LTv Extended é o launcher padrão';

  @override
  String get defaultLauncherNotDefault => 'LTv Extended não é o launcher padrão';

  @override
  String get setAsDefaultLauncher => 'Definir como launcher padrão';

  @override
  String get defaultLauncherDescription => 'Quando definido como launcher padrão, o botão Home sempre retornará ao LTv Extended. A TV também iniciará diretamente no LTv Extended.';

  @override
  String get inputs => 'Entradas';

  @override
  String get inputSources => 'Fontes de entrada';

  @override
  String get backupAndRestore => 'Backup e Restauração';

  @override
  String get exportBackup => 'Exportar Backup';

  @override
  String get importBackup => 'Importar Backup';

  @override
  String exportSuccess(String path) {
    return 'Backup exportado com sucesso para $path';
  }

  @override
  String get importSuccess => 'Backup importado com sucesso';

  @override
  String get importConfirm => 'Tem certeza de que deseja importar o backup? Isso substituirá suas configurações e layout atuais.';

  @override
  String importError(String error) {
    return 'Falha ao importar backup: $error';
  }

  @override
  String exportError(String error) {
    return 'Falha ao exportar backup: $error';
  }

  @override
  String get shareBackup => 'Compartilhar Backup';

  @override
  String get shareBackupDescription => 'Compartilhar backup com outros dispositivos na rede local';

  @override
  String get stopSharing => 'Parar Compartilhamento';

  @override
  String get localNetworkSharingActive => 'O compartilhamento na rede local está ativo!';

  @override
  String get localNetworkSharingInstructions => 'Conecte outro dispositivo à mesma rede Wi-Fi e abra a seguinte URL em um navegador da web:';

  @override
  String get localNetworkSharingDetails => 'Aqui você pode baixar as configurações/layout da sua TV ou enviar um arquivo de backup de volta para esta TV.';

  @override
  String failedToStartServer(String error) {
    return 'Falha ao iniciar o servidor de compartilhamento: $error';
  }

  @override
  String get notificationBell => 'Sino de Notificação';

  @override
  String get autoHideNotificationBell => 'Ocultar Sino de Notificação automaticamente';

  @override
  String get continueWatching => 'Continuar assistindo';

  @override
  String get showContinueWatchingOnHome => 'Mostrar Continuar assistindo na tela inicial';

  @override
  String get permissionDeniedContinueWatching => 'Permissão necessária para mostrar Continuar assistindo';

  @override
  String get interface => 'Interface';

  @override
  String get system => 'Sistema';

  @override
  String get accentColor => 'Cor de destaque';

  @override
  String get miscellaneous => 'Diversos';

  @override
  String get brightnessScheduler => 'Agendador de brilho';

  @override
  String get screensaverSettings => 'Configurações do protetor de tela';

  @override
  String get screensaverClockStyle => 'Estilo de relógio do protetor de tela';

  @override
  String get dataUsagePeriod => 'Período de uso de dados';

  @override
  String get notificationAccess => 'Acesso a notificações';

  @override
  String get granted => 'Concedido';

  @override
  String get permissionRequired => 'Permissão Necessária';

  @override
  String get systemWidePopupAlert => 'Alerta pop-up de todo o sistema';

  @override
  String get overlayPermissionRequired => 'Permissão de sobreposição necessária';

  @override
  String get enabled => 'Ativado';

  @override
  String get disabled => 'Desativado';

  @override
  String get showAppNamesBelowIcons => 'Mostrar nomes dos apps abaixo dos ícones';

  @override
  String get dataUsage => 'Uso de dados';

  @override
  String get networkIndicator => 'Indicador de rede';

  @override
  String get homeButtonFix => 'Correção do botão Home (Google TV)';

  @override
  String get startOnBoot => 'Iniciar ao ligar (Google TV / Fire TV)';

  @override
  String get appLanguage => 'Idioma';

  @override
  String get systemDefault => 'Padrão do sistema';

  @override
  String get english => 'Inglês';

  @override
  String get spanish => 'Espanhol';

  @override
  String get ukrainian => 'Ucraniano';

  @override
  String get chinese => 'Chinês';

  @override
  String get french => 'Francês';

  @override
  String get german => 'Alemão';

  @override
  String get japanese => 'Japonês';

  @override
  String get portuguese => 'Português';

  @override
  String get russian => 'Russo';

  @override
  String get italian => 'Italiano';

  @override
  String get hindi => 'Hindi';

  @override
  String get korean => 'Coreano';

  @override
  String get arabic => 'Árabe';

  @override
  String get turkish => 'Turco';

  @override
  String get hidePersistentNotifications => 'Ocultar notificações persistentes';

  @override
  String get hidePersistentNotificationsDesc => 'Ocultar notificações de serviços em segundo plano e do sistema';

  @override
  String get blockedNotificationApps => 'Aplicativos bloqueados';

  @override
  String get blockAppNotifications => 'Bloquear notificações';

  @override
  String get unblockAppNotifications => 'Desbloquear notificações';

  @override
  String get noBlockedApps => 'Nenhum aplicativo bloqueado';

  @override
  String get persistentNotification => 'Persistente';

  @override
  String get unblockAll => 'Desbloquear tudo';

  @override
  String get weather => 'Clima';

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
  String get showWeatherWarnings => 'Mostrar alertas de chuva e clima';

  @override
  String get temperatureUnit => 'Unidade de temperatura';

  @override
  String get celsius => 'Celsius (°C)';

  @override
  String get fahrenheit => 'Fahrenheit (°F)';

  @override
  String get breezyWeatherSetupHint => 'Instale o Breezy Weather e ative o \'Compartilhamento local de dados\' / \'Gadgetbridge\' nas configurações para ver o clima e alertas de chuva.';

  @override
  String get displayAndScreensaver => 'Tela e protetor de tela';

  @override
  String get notifications => 'Notificações';

  @override
  String get continueWatchingDescription => 'Mostrar filmes e programas assistidos recentemente na tela inicial';

  @override
  String get continueWatchingPermissionDesc => 'É necessária uma permissão especial para ler o histórico de reprodução:';

  @override
  String get requestPermission => 'Solicitar permissão';

  @override
  String get dismiss => 'Descartar';

  @override
  String get openApp => 'Abrir';

  @override
  String get notificationOptions => 'Opções de notificação';

  @override
  String get noBlockedAppsDesc => 'Todos os aplicativos estão atualmente autorizados a exibir notificações';

  @override
  String get notificationsAllowed => 'Notificações permitidas';

  @override
  String get notificationsBlocked => 'Notificações bloqueadas';

  @override
  String get dpadDismissHint => 'Esquerda: Descartar • OK: Opções';

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
