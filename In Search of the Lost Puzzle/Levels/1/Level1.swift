//
//  Level1.swift
//  In Search of the Lost Puzzle
//
//  Created by Dimitrie-Toma Furdui on 13/04/2020.
//  Copyright © 2020 The Green Meerkats. All rights reserved.
//

import SpriteKit

class Level1: Level {
    override var helpText: String? {
        "...I don't even know how to explain this, it's too obvious"
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        for nodeName in [contact.bodyA.node?.name, contact.bodyB.node?.name].compactMap({ $0 }) {
            if nodeName.range(of: #"^(tile\-wall\-2\-1[3-4])$"#, options: .regularExpression) != nil {
                for row in 0...2 {
                    for column in 12...14 {
                        let node = self.childNode(withName: "tile-wall-\(row)-\(column)")
                        node?.physicsBody?.isDynamic = true
                        node?.physicsBody?.applyImpulse(.init(dx: 0, dy: -5))
                    }
                }
            }
        }
    }
}
