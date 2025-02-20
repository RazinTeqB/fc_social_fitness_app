import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ItalianAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const ItalianAssetPickerTextDelegate();

  @override
  String get languageCode => 'it';

  @override
  String get confirm => 'Conferma';

  @override
  String get cancel => 'Cancella';

  @override
  String get edit => 'Modifica';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get loadFailed => 'Caricamento fallito';

  @override
  String get original => 'Origine';

  @override
  String get preview => 'Anteprima';

  @override
  String get select => 'Seleziona';

  @override
  String get emptyList => 'Lista vuota';

  @override
  String get unSupportedAssetType => 'Tipo HEIC non supportato.';

  @override
  String get unableToAccessAll => 'Impossibile accedere a tutti i media del dispositivo';

  @override
  String get viewingLimitedAssetsTip =>
      'Visualizza solo i media e gli album accessibili all\'app.';

  @override
  String get changeAccessibleLimitedAssets =>
      'Clicca per cambiare l\'accesso ai media';

  @override
  String get accessAllTip => 'L\'app può accedere solo ad alcuni media sul dispositivo. '
      'Vai alle impostazioni di sistema e consenti all\'app di accedere a tutti i media sul dispositivo';

  @override
  String get goToSystemSettings => 'Vai alle impostazioni di sistema';

  @override
  String get accessLimitedAssets => 'Continua con accesso limitato';

  @override
  String get accessiblePathName => 'Media accedibili';

  @override
  String get sTypeAudioLabel => 'Audio';

  @override
  String get sTypeImageLabel => 'Immagine';

  @override
  String get sTypeVideoLabel => 'Video';

  @override
  String get sTypeOtherLabel => 'Altre foto';

  @override
  String get sActionPlayHint => 'riproduci';

  @override
  String get sActionPreviewHint => 'anteprima';

  @override
  String get sActionSelectHint => 'seleziona';

  @override
  String get sActionSwitchPathLabel => 'cambia percorso';

  @override
  String get sActionUseCameraHint => 'usa fotocamera';

  @override
  String get sNameDurationLabel => 'durata';

  @override
  String get sUnitAssetCountLabel => 'timer';
}