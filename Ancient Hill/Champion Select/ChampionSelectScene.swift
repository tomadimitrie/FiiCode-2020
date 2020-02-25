//
//  GameScene.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 22/02/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit

class ChampionSelectScene: SKScene, HUDDelegate {
    var player: SKNode!
    var tileMap: SKTileMapNode!
    
    var currentMovingDirection: Direction?
    
    override func didMove(to view: SKView) {
        guard let camera = self.childNode(withName: "//camera") as? SKCameraNode else { return }
        guard let player = self.childNode(withName: "//player") else { return }
        guard let tileMap = self.childNode(withName: "//tileMap") as? SKTileMapNode else { return }
        camera.constraints = [.distance(.init(lowerLimit: 0, upperLimit: 0), to: player)]
        self.player = player
        self.tileMap = tileMap
    }
    
    func hudTapped(for direction: Direction) {
        self.currentMovingDirection = direction
        var newPosition = CGPoint.zero
        switch direction {
            case .top:
                newPosition.y += Constants.moveAmount
            case .left:
                newPosition.x -= Constants.moveAmount
            case .right:
                newPosition.x += Constants.moveAmount
            case .bottom:
                newPosition.y -= Constants.moveAmount
        }
        let moveAction = SKAction.move(by: newPosition.cgVector, duration: 0.1)
        let repeatForeverAction = SKAction.repeatForever(moveAction)
        let actionSequence = SKAction.sequence([moveAction, repeatForeverAction])
        self.player.run(actionSequence, withKey: direction.rawValue)
    }
    
    override func update(_ currentTime: TimeInterval) {
        var position = self.player.position
        switch self.currentMovingDirection {
            case .top:
                position.y += Constants.moveAmount
                position.y += self.player.frame.size.height / 2
            case .left:
                position.x -= Constants.moveAmount
                position.x -= self.player.frame.size.width / 2
            case .right:
                position.x += Constants.moveAmount
                position.x += self.player.frame.size.width / 2
            case .bottom:
                position.y -= Constants.moveAmount
                position.y -= self.player.frame.size.height / 2
            case .none:
                break
        }
        let tile = self.tileMap.tile(at: position)
        if tile?.name != "champion-select-road" {
            let directions: [Direction] = [.top, .right, .bottom, .left]
            directions.forEach {
                self.hudReleased(for: $0)
            }
        }
    }
    
    func hudReleased(for direction: Direction) {
        self.player.removeAction(forKey: direction.rawValue)
    }
}
