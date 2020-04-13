import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // TODO: do not use magic strings
        UserDefaults.standard.removeObject(forKey: "currentScene")
        let sceneName = UserDefaults.standard.value(forKey: "currentScene") as? String ?? "Ancient_Hill.Level1"
        if
            let scene = NSClassFromString(sceneName) as? GameScene.Type,
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GameViewController") as? GameViewController
        {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            vc.changeScene(to: scene)
        }
        return true
    }
}
