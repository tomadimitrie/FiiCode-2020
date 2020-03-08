//
//  Constants.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 22/02/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import Foundation
import SpriteKit

class Constants {
    static let moveAmount: CGFloat = 50
    static let collisionThreshold: CGFloat = 10
}

extension CGVector {
    var cgPoint: CGPoint {
        CGPoint(x: self.dx, y: self.dy)
    }
}

extension CGPoint {
    var cgVector: CGVector {
        CGVector(dx: self.x, dy: self.y)
    }
}

extension SKTileMapNode {
    func tile(at point: CGPoint) -> SKTileDefinition? {
        let tileColumn = self.tileColumnIndex(fromPosition: point)
        let tileRow = self.tileRowIndex(fromPosition: point)
        return self.tileDefinition(atColumn: tileColumn, row: tileRow)
    }
}

func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
