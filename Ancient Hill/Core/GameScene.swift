//
//  GameScene.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 13/04/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, HUDDelegate, ActionButtonDelegate {
    func hudTapped(for direction: Direction) {}
    
    func hudReleased(for direction: Direction) {}
    
    func actionTapped() {}
    
    var dialogueDelegate: DialogueDelegate?
    var sceneDelegate: SceneDelegate?
    
    var helpText: String? {
        nil
    }
    
    override func didMove(to view: SKView) {
        UserDefaults.standard.set(NSStringFromClass(Self.self), forKey: "currentScene")
    }
}
