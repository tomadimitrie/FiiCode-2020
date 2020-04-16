import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var hudView: SKView!
    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var dialogueView: DialogueView!
    @IBOutlet weak var actionButtonView: SKView!
    
    var hudScene: HUDScene!
    var actionButtonScene: ActionButtonScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScenes()
    }
    
    private func setupScenes() {
        if let hudScene = HUDScene(fileNamed: "HUDScene") {
            self.hudScene = hudScene
            self.hudScene.scaleMode = .aspectFill
            self.hudView.presentScene(self.hudScene)
        }
        if let actionButtonScene = ActionButtonScene(fileNamed: "ActionButtonScene") {
            self.actionButtonScene = actionButtonScene
            self.actionButtonScene.scaleMode = .aspectFill
            self.actionButtonView.presentScene(self.actionButtonScene)
        }
        #if DEBUG
        self.gameView.showsFPS = true
        self.gameView.showsNodeCount = true
        self.gameView.showsPhysics = true
        #endif
        self.gameView.ignoresSiblingOrder = true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: SceneDelegate {
    func changeScene(to sceneType: GameScene.Type) {
        let sceneName = NSStringFromClass(sceneType).components(separatedBy: ".").last!
        let scene = sceneType.init(fileNamed: sceneName)!
        scene.scaleMode = .aspectFill
        scene.dialogueDelegate = self.dialogueView
        scene.sceneDelegate = self
        self.hudScene.hudDelegate = scene
        self.actionButtonScene.actionButtonDelegate = scene
        self.gameView.presentScene(scene)
    }
}
