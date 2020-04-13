import Foundation
import SpriteKit
import CoreGraphics

class Constants {
    static let moveAmount: CGFloat = 10
    static let jumpAmount: CGFloat = 50
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

func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
    lhs.x == rhs.x && lhs.y == rhs.y
}

func + (lhs: CGSize, rhs: CGSize) -> CGSize {
    CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}

class NodeHelper {
    class Node {
        var center: CGPoint
        var topLeft: CGPoint
        var topRight: CGPoint
        var bottomLeft: CGPoint
        var bottomRight: CGPoint
        
        init(tileSize: CGSize, center: CGPoint) {
            self.center = center
            self.topLeft = CGPoint(x: center.x - tileSize.width / 2, y: center.y + tileSize.height / 2)
            self.topRight = CGPoint(x: center.x + tileSize.width / 2, y: center.y + tileSize.height / 2)
            self.bottomLeft = CGPoint(x: center.x - tileSize.width / 2, y: center.y - tileSize.height / 2)
            self.bottomRight = CGPoint(x: center.x + tileSize.width / 2, y: center.y - tileSize.height / 2)
        }
    }
    
    static func floodFill(
        for table: inout [[(type: String, position: CGPoint)?]]
    ) -> [String: [[CGPoint]]] {
        var group = [String: [[CGPoint]]]()
        while case let (x, y, initialNode)?: (Int, Int, (type: String, position: CGPoint))? = {
            for y in 0..<table.count {
                for x in 0..<table[y].count {
                    if let node = table[y][x] {
                        return (x, y, node)
                    }
                }
            }
            return nil
        }() {
            var currentGroup = [CGPoint]()
            func _floodFill(_ x: Int, _ y: Int) {
                guard
                    x >= 0,
                    x < table[0].count,
                    y >= 0,
                    y < table.count,
                    let node = table[y][x],
                    node.type == initialNode.type
                else { return }
                currentGroup.append(node.position)
                table[y][x] = nil
                _floodFill(x + 1, y    )
                _floodFill(x - 1, y    )
                _floodFill(x    , y + 1)
                _floodFill(x    , y - 1)
            }
            _floodFill(x, y)
            currentGroup.sort {
                $0.x < $1.x && $0.y < $1.y
            }
            group[initialNode.type, default: []].append(currentGroup)
        }
        return group
    }

}
