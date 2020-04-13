//
//  Level.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 13/04/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit

fileprivate enum Nodes: String {
    case player
    case tileMap
}

fileprivate enum Mask: UInt32 {
    case player = 0b01
    case wall   = 0b10
}

class Level: GameScene {
    var player: SKSpriteNode!
    var tileMap: SKTileMapNode!
    
    var isPlayerStanding = false
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.setupNodes()
        self.setupTileMap()
        self.setupPlayer()
    }
    
    private func setupNodes() {
        self.player = self.childNode(withName: Nodes.player.rawValue) as? SKSpriteNode
        self.tileMap = self.childNode(withName: Nodes.tileMap.rawValue) as? SKTileMapNode
    }
    
    private func setupPlayer() {
        let physicsBody = SKPhysicsBody(rectangleOf: self.player.frame.size)
        physicsBody.allowsRotation = false
        physicsBody.categoryBitMask = Mask.player.rawValue
        physicsBody.collisionBitMask = Mask.wall.rawValue
        physicsBody.contactTestBitMask = Mask.wall.rawValue
        physicsBody.restitution = 0
        self.player.physicsBody = physicsBody
    }
    
    private func setupTileMap() {
        let tileSize = self.tileMap.tileSize
        let halfWidth = CGFloat(self.tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(self.tileMap.numberOfRows) / 2.0 * tileSize.height
        var table = [[(type: String, position: CGPoint)?]]()
        for row in 0..<self.tileMap.numberOfRows {
            var tableRow = [(type: String, position: CGPoint)?]()
            for column in 0..<self.tileMap.numberOfColumns {
                if
                    let tileDefinition = self.tileMap.tileDefinition(atColumn: column, row: row),
                    let tileName = tileDefinition.name
                {
                    switch tileName {
                    case "wall":
                        let tileX = CGFloat(column) * tileSize.width - halfWidth
                        let tileY = CGFloat(row) * tileSize.height - halfHeight
                        let rect = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
                        let tileNode = SKShapeNode(rect: rect)
                        tileNode.name = "wall"
                        tileNode.strokeColor = .clear
                        tileNode.position = CGPoint(x: tileX, y: tileY)
                        tableRow.append((type: tileName, position: tileNode.position))
                        let physicsBodyCenter = CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0)
                        let physicsBody = SKPhysicsBody(rectangleOf: tileSize, center: physicsBodyCenter)
                        physicsBody.isDynamic = false
                        physicsBody.categoryBitMask = Mask.wall.rawValue
                        physicsBody.restitution = 0
                        tileNode.physicsBody = physicsBody
                        self.tileMap.addChild(tileNode)
                        
                    default:
                        break
                    }
                }
            }
            table.append(tableRow)
        }
    }
    
    override func hudTapped(for direction: Direction) {
        switch direction {
        case .left, .right:
            var newPosition = CGPoint.zero
            newPosition.x += Constants.moveAmount * (direction == .left ? -1 : 1)
            let textures = AssetsLoader.textures(for: .finnachu, direction: direction)
            self.player.texture = textures[0]
            let frameAction = SKAction.repeatForever(
                SKAction.animate(with: textures, timePerFrame: 0.25, resize: false, restore: true)
            )
            let moveAction = SKAction.move(by: newPosition.cgVector, duration: 0.1)
            let repeatAction = SKAction.repeatForever(moveAction)
            let actionGroup = SKAction.group([frameAction, repeatAction])
            self.player.run(actionGroup, withKey: direction.rawValue)
        default:
            return
        }
    }
    
    override func hudReleased(for direction: Direction) {
        if direction != .top {
            self.player.removeAction(forKey: direction.rawValue)
        }
    }
    
    override func actionTapped() {
        if self.isPlayerStanding {
            self.player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5))
        }
    }
}

extension Level: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if
            contact.bodyA.categoryBitMask == Mask.wall.rawValue &&
            contact.bodyB.categoryBitMask == Mask.player.rawValue
        {
            self.isPlayerStanding = true
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if
            contact.bodyA.categoryBitMask == Mask.wall.rawValue &&
            contact.bodyB.categoryBitMask == Mask.player.rawValue
        {
            self.isPlayerStanding = false
        }
    }
}
