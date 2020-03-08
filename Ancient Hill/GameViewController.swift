import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var hudView: SKView!
    @IBOutlet weak var gameView: SKView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScenes()
    }

    private func setupScenes() {
        if let championSelectScene = SKScene(fileNamed: "ChampionSelectScene") as? ChampionSelectScene {
            championSelectScene.scaleMode = .aspectFill
            self.gameView.presentScene(championSelectScene)
            self.gameView.ignoresSiblingOrder = true
            #if DEBUG
            self.gameView.showsFPS = true
            self.gameView.showsNodeCount = true
            championSelectScene.view?.showsPhysics = true
            #endif
            if let hudScene = SKScene(fileNamed: "HUDScene") as? HUDScene {
                championSelectScene.actionButtonVisibilityDelegate = hudScene
                hudScene.scaleMode = .aspectFill
                hudScene.hudDelegate = championSelectScene
                hudView.presentScene(hudScene)
            }
        }
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
