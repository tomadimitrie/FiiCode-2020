//
//  Level8.swift
//  In Search of the Lost Puzzle
//
//  Created by Dimitrie-Toma Furdui on 02/05/2020.
//  Copyright © 2020 The Green Meerkats. All rights reserved.
//

import SpriteKit

class Level8: Level {
    override var helpText: String? {
        "Just don't fall"
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        for nodeName in [contact.bodyA.node?.name, contact.bodyB.node?.name].compactMap({ $0 }) {
            if
                let regex = try? NSRegularExpression(pattern: #"^tile\-wall\-(3|5)\-(\d+)$"#, options: .caseInsensitive),
                let match = regex.firstMatch(in: nodeName, options: [], range: NSRange(location: 0, length: nodeName.utf16.count)),
                let rowRange = Range(match.range(at: 1), in: nodeName),
                let columnRange = Range(match.range(at: 2), in: nodeName),
                let row = Int(nodeName[rowRange]),
                let column = Int(nodeName[columnRange])
            {
                for affectedRow in 0...row {
                    let node = self.childNode(withName: "tile-wall-\(affectedRow)-\(column)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        node?.physicsBody?.isDynamic = true
                        node?.physicsBody?.applyImpulse(.init(dx: 0, dy: -5))
                    }
                }
            }
        }
    }
}
