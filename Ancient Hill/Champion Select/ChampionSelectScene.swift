//
//  GameScene.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 22/02/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit

fileprivate enum Nodes: String {
    case camera = "camera"
    case player = "player"
    case tileMap = "tileMap"
}

class ChampionSelectScene: SKScene, HUDDelegate {
    var player: SKNode!
    var tileMap: SKTileMapNode!
    
    var currentMovingDirection: Direction?
    
    weak var actionButtonVisibilityDelegate: ActionButtonVisibilityDelegate?
        
    override func didMove(to view: SKView) {
        guard let camera = self.childNode(withName: Nodes.camera.rawValue) as? SKCameraNode else { return }
        guard let player = self.childNode(withName: Nodes.player.rawValue) else { return }
        guard let tileMap = self.childNode(withName: Nodes.tileMap.rawValue) as? SKTileMapNode else { return }
        
        self.player = player
        self.tileMap = tileMap
        
        let playerConstraint = SKConstraint.distance(.init(constantValue: 0.0), to: player)
        
        let scaledSize = CGSize(width: self.size.width * camera.xScale, height: self.size.height * camera.yScale)
        let tileMapContentRect = tileMap.calculateAccumulatedFrame()
        let xInset = min(scaledSize.width / 2, tileMapContentRect.width / 2)
        let yInset = min(scaledSize.height / 2, tileMapContentRect.height / 2)
        let insetContentRect = tileMapContentRect.insetBy(dx: xInset, dy: yInset)
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)
        let boardConstraint = SKConstraint.positionX(xRange, y: yRange)
        boardConstraint.referenceNode = tileMap
        
        camera.constraints = [playerConstraint, boardConstraint]
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
            case .action:
                break
        }
        let moveAction = SKAction.move(by: newPosition.cgVector, duration: 0.1)
        let repeatForeverAction = SKAction.repeatForever(moveAction)
        let actionSequence = SKAction.sequence([moveAction, repeatForeverAction])
        self.player.run(actionSequence, withKey: direction.rawValue)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let directions: [Direction] = [.top, .right, .bottom, .left]
        guard (directions.map { self.player.action(forKey: $0.rawValue) != nil }.contains(true)) else { return }
        var position = self.player.position
        
        let nodesAtPlayerPosition = self.nodes(at: position)
        self.actionButtonVisibilityDelegate?.toggleActionButton(to: nodesAtPlayerPosition.map { $0.name }.contains("finnachu"))
        
        switch self.currentMovingDirection {
            case .top:
                position.y += Constants.collisionThreshold
                position.y += self.player.frame.size.height / 2
            case .left:
                position.x -= Constants.collisionThreshold
                position.x -= self.player.frame.size.width / 2
            case .right:
                position.x += Constants.collisionThreshold
                position.x += self.player.frame.size.width / 2
            case .bottom:
                position.y -= Constants.collisionThreshold
                position.y -= self.player.frame.size.height / 2
            default:
                break
        }
        let tile = self.tileMap.tile(at: position)
        if tile?.name != "champion-select-road" {
            directions.forEach {
                self.hudReleased(for: $0)
            }
        }
    }
    
    func hudReleased(for direction: Direction) {
        self.player.removeAction(forKey: direction.rawValue)
    }
}
