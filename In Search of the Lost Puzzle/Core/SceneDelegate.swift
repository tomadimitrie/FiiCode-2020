import SpriteKit

protocol SceneDelegate: class {
    func changeScene(to scene: GameScene.Type)
    func runSegue(name: String)
}
