//
//  Level9.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 02/05/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit

class Level9: Level {
    override var helpText: String? {
        "Don't get hit by the arrow"
    }
    
    var arrow: SKSpriteNode!
    
    var moveArrowFromBeginning = true
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.arrow = self.childNode(withName: Nodes.arrow.rawValue) as? SKSpriteNode
        self.setupArrow()
        if self.moveArrowFromBeginning {
            self.moveArrow(delayed: true)
        }
    }
    
    private func setupArrow() {
        let physicsBody = SKPhysicsBody(rectangleOf: self.arrow.frame.size)
        print(self.arrow.position)
        physicsBody.restitution = 0
        physicsBody.categoryBitMask = Mask.arrow.rawValue
        physicsBody.contactTestBitMask = Mask.portal.rawValue
        physicsBody.affectedByGravity = false
        self.arrow.physicsBody = physicsBody
    }
    
    func moveArrow(delayed: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + (delayed ? 2 : 0)) {
            self.arrow.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 0))
        }
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case Mask.player.rawValue | Mask.arrow.rawValue:
            self.arrow.removeFromParent()
            self.levelFailed()
        case Mask.arrow.rawValue | Mask.portal.rawValue:
            self.arrow.removeFromParent()
        default:
            break
        }
    }
}
