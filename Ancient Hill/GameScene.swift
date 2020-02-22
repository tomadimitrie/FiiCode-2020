//
//  GameScene.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 22/02/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var player: SKNode? = nil
    var tileMap: SKTileMapNode? = nil
    
    override func didMove(to view: SKView) {
        guard let camera = self.childNode(withName: "//camera") as? SKCameraNode else { return }
        guard let player = self.childNode(withName: "//player") else { return }
        guard let tileMap = self.childNode(withName: "//tileMap") as? SKTileMapNode else { return }
        camera.constraints = [.distance(.init(lowerLimit: 0, upperLimit: 0), to: player)]
        self.player = player
        self.tileMap = tileMap
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let position = touch?.location(in: self) {
            let tappedNode = self.nodes(at: position)
            if let initialPosition = self.player?.position {
                var newPosition = CGPoint(x: initialPosition.x, y: initialPosition.y)
                switch tappedNode.first?.name {
                    case "top":
                        newPosition.y += Constants.moveAmount
                    case "left":
                        newPosition.x -= Constants.moveAmount
                    case "right":
                        newPosition.x += Constants.moveAmount
                    case "bottom":
                        newPosition.y -= Constants.moveAmount
                    default:
                        break
                }
                if let tileColumn = self.tileMap?.tileColumnIndex(fromPosition: newPosition), let tileRow = self.tileMap?.tileRowIndex(fromPosition: newPosition) {
                    let tile = self.tileMap?.tileDefinition(atColumn: tileColumn, row: tileRow)
                    if tile?.name == "champion-select-road" {
                        self.player?.position = newPosition
                    }
                }
            }
            
        }
    }
    
}
