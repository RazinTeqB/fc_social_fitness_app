import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ItalianCameraPickerTextDelegate extends CameraPickerTextDelegate {
  const ItalianCameraPickerTextDelegate();

  @override
  String get languageCode => 'it';

  @override
  String get confirm => 'Conferma';

  @override
  String get shootingTips => 'Premi per scattare una foto';

  @override
  String get shootingWithRecordingTips =>
      'Premi per scattare una foto. Tieni premuto per registrare un video.';

  @override
  String get shootingOnlyRecordingTips => 'Tieni premuto per registrare un video.';

  @override
  String get shootingTapRecordingTips => 'Premi per registrare un video.';

  @override
  String get loadFailed => 'Caricamento fallito';

  @override
  String get loading => 'Caricamento...';

  @override
  String get saving => 'Salvataggio...';

  @override
  String get sActionManuallyFocusHint => 'focus manuale';

  @override
  String get sActionPreviewHint => 'anteprima';

  @override
  String get sActionRecordHint => 'registra';

  @override
  String get sActionShootHint => 'scatta foto';

  @override
  String get sActionShootingButtonTooltip => 'shooting button';

  @override
  String get sActionStopRecordingHint => 'ferma registrazione';

  @override
  String sCameraLensDirectionLabel(CameraLensDirection value) => value.name;

  @override
  String? sCameraPreviewLabel(CameraLensDirection? value) {
    if (value == null) {
      return null;
    }
    return '${sCameraLensDirectionLabel(value)} anteprima fotocamera';
  }

  @override
  String sFlashModeLabel(FlashMode mode) => 'Flash: ${mode.name}';

  @override
  String sSwitchCameraLensDirectionLabel(CameraLensDirection value) =>
      'Passa a fotocamera ${sCameraLensDirectionLabel(value)}';
}