//
//  LevelX.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 24/04/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit

class Level6: Level {
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        for nodeName in [contact.bodyA.node?.name, contact.bodyB.node?.name].compactMap({ $0 }) {
            if nodeName == "tile-wall-4-10" {
                for row in 0...4 {
                    let node = self.childNode(withName: "tile-wall-\(row)-10")
                    node?.physicsBody?.isDynamic = true
                    node?.physicsBody?.applyImpulse(.init(dx: 0, dy: -5))
                }
            }
        }
    }
}
