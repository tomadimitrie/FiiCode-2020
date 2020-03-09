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

func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
    lhs.x == rhs.x && lhs.y == rhs.y
}

func + (lhs: CGSize, rhs: CGSize) -> CGSize {
    CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}
