//
//  Level4.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 16/04/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit

class Level4: Level2 {
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case Mask.player.rawValue | Mask.wall.rawValue:
            self.physicsWorld.gravity = .zero
        default:
            break
        }
    }
    
    override func moveVertically(in direction: Direction) {
        var newPosition = CGPoint.zero
        newPosition.y += Constants.moveAmount * (direction == .bottom ? -1 : 1)
        let moveAction = SKAction.move(by: newPosition.cgVector, duration: 0.1)
        let repeatAction = SKAction.repeatForever(moveAction)
        self.player.run(repeatAction, withKey: direction.rawValue)
    }
    
    override func actionTapped() {}
}
