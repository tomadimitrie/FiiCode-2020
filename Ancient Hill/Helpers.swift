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

func floodFill(for table: inout [[(type: String, rect: CGRect)?]]) -> [String: [[CGRect]]] {
    var group = [String: [[CGRect]]]()
    while case let (x, y, initialNode)?: (Int, Int, (type: String, rect: CGRect))? = {
        for y in 0..<table.count {
            for x in 0..<table[y].count {
                if let node = table[y][x] {
                    return (x, y, node)
                }
            }
        }
        return nil
    }() {
        var currentGroup = [CGRect]()
        func _floodFill(_ x: Int, _ y: Int) {
            guard
                x >= 0,
                x < table[0].count,
                y >= 0,
                y < table.count,
                let node = table[y][x],
                node.type == initialNode.type
            else { return }
            currentGroup.append(node.rect)
            table[y][x] = nil
            _floodFill(x + 1, y    )
            _floodFill(x - 1, y    )
            _floodFill(x    , y + 1)
            _floodFill(x    , y - 1)
        }
        _floodFill(x, y)
        currentGroup.sort {
            $0.origin.x < $1.origin.x && $0.origin.y < $1.origin.y
        }
        group[initialNode.type, default: []].append(currentGroup)
    }
    return group
}
