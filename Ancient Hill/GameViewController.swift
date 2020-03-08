//
//  GameViewController.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 22/02/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var hudView: SKView!
    @IBOutlet weak var gameView: SKView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let championSelectScene = SKScene(fileNamed: "ChampionSelectScene") as? ChampionSelectScene {
            championSelectScene.scaleMode = .aspectFill
            self.gameView.presentScene(championSelectScene)
            self.gameView.ignoresSiblingOrder = true
            #if DEBUG
            self.gameView.showsFPS = true
            self.gameView.showsNodeCount = true
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
