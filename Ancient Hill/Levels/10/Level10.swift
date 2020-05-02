//
//  Level10.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 02/05/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit

class Level10: Level9 {
    override var helpText: String? {
        "You have to avoid a specific tile... or dodge the arrow"
    }
    
    override func didMove(to view: SKView) {
        self.moveArrowFromBeginning = false
        super.didMove(to: view)
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        for nodeName in [contact.bodyA.node?.name, contact.bodyB.node?.name].compactMap({ $0 }) {
            if nodeName == "tile-wall-5-12" {
                self.moveArrow(delayed: false)
            }
        }
    }
}
