import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var hudView: SKView!
    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var dialogueView: DialogueView!
    
    var hudScene: HUDScene!
    var currentScene: GameScene!
    
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
        #if DEBUG
        self.gameView.showsFPS = true
        self.gameView.showsNodeCount = true
        self.gameView.showsPhysics = true
        #endif
        self.gameView.ignoresSiblingOrder = true
        self.changeScene(to: ChampionSelectScene.self)
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
    func changeScene(to scene: GameScene.Type) {
        let sceneName = NSStringFromClass(scene).components(separatedBy: ".").last!
        if let scene = scene.init(fileNamed: sceneName) {
            self.currentScene = scene
            scene.scaleMode = .aspectFill
            scene.dialogueDelegate = self.dialogueView
            scene.sceneDelegate = self
            scene.actionButtonDelegate = self.hudScene
            self.hudScene.hudDelegate = scene
            self.gameView.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
        }
    }
}
