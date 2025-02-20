import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var overlayWindow: UIWindow?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
   
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


  @objc private func screenCaptureDidChange() {
    if UIScreen.main.isCaptured {
      showOverlay(withMessage: "Impossibile eseguire screenshot o registrazioni schermo")
    } else {
      hideOverlay()
    }
  }

  @objc private func willTakeScreenshot() {
    showOverlay(withMessage: "Impossibile eseguire screenshot o registrazioni schermo")
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.hideOverlay()
    }
  }

  private func showOverlay(withMessage message: String) {
    if overlayWindow == nil {
      overlayWindow = UIWindow(frame: UIScreen.main.bounds)
      overlayWindow?.backgroundColor = UIColor.black

      let label = UILabel(frame: overlayWindow!.bounds)
      label.text = message
      label.textColor = .white
      label.textAlignment = .center
      label.numberOfLines = 0

      let viewController = UIViewController()
      viewController.view.backgroundColor = .black
      viewController.view.addSubview(label)

      overlayWindow?.rootViewController = viewController
    }
    overlayWindow?.isHidden = false
  }

  private func hideOverlay() {
    overlayWindow?.isHidden = true
  }

  override func applicationWillResignActive(_ application: UIApplication) {
    showOverlay(withMessage: "Impossibile eseguire screenshot o registrazioni schermo")
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    hideOverlay()
  }
}