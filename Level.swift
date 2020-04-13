//
//  Level.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 13/04/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit

private enum Nodes: String {
    case player
    case tileMap
}

private enum CategoryMask: UInt32 {
    case player = 0b01
    case wall   = 0b10
}

class Level: GameScene {
    var player: SKSpriteNode!
    var tileMap: SKTileMapNode!
    
    override func didMove(to view: SKView) {
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
        physicsBody.categoryBitMask = CategoryMask.player.rawValue
        physicsBody.collisionBitMask = CategoryMask.wall.rawValue
        physicsBody.contactTestBitMask = CategoryMask.wall.rawValue
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
                        tileNode.strokeColor = .clear
                        tileNode.position = CGPoint(x: tileX, y: tileY)
                        tableRow.append((type: tileName, position: tileNode.position))
                        let physicsBodyCenter = CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0)
                        let physicsBody = SKPhysicsBody(rectangleOf: tileSize, center: physicsBodyCenter)
                        physicsBody.isDynamic = false
                        physicsBody.categoryBitMask = CategoryMask.wall.rawValue
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
}
