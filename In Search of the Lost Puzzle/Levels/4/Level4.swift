//
//  Level4.swift
//  In Search of the Lost Puzzle
//
//  Created by Dimitrie-Toma Furdui on 16/04/2020.
//  Copyright © 2020 The Green Meerkats. All rights reserved.
//

import SpriteKit

class Level4: Level2 {
    
    override var helpText: String? {
        "Something tells me you have a button on the screen that didn't work (until now)"
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case Mask.player.rawValue | Mask.wall.rawValue:
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8 * (self.isGravityInversed ? -1 : 1))
        default:
            break
        }
    }
    
    override func moveVertically(in direction: Direction) {
        var newPosition = CGPoint.zero
        newPosition.y += Constants.moveAmount * (direction == .bottom ? -1 : 1)
        let moveAction = SKAction.move(by: newPosition.cgVector, duration: 0.1)
        let repeatAction = SKAction.repeatForever(moveAction)
        self.physicsWorld.gravity = .zero
        self.player.run(repeatAction, withKey: direction.rawValue)
    }
}
