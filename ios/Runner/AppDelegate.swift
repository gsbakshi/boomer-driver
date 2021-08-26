import UIKit
import Firebase
import GoogleMaps
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let mapsKey: String

  override init() {
     guard let filePath = Bundle.main.path(forResource: "Api-Keys-Info", ofType: "plist") else {
       fatalError("Couldn't find file 'Api-Keys-Info.plist'.")
     }
     let plist = NSDictionary(contentsOfFile: filePath)
     guard let key = plist?.object(forKey: "GOOGLE_MAPS_API") as? String else {
       fatalError("Couldn't find key 'GOOGLE_MAPS_API' in 'Api-Keys-Info.plist'.")
     }
     mapsKey = key
    super.init()
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey(mapsKey)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
