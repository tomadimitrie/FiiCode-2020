import SpriteKit

private enum Nodes: String {
    case camera
    case player
    case person = "finnachu"
    case tileMap
    case wall
    case road
}

private enum CategoryMask: UInt32 {
    case player = 0b0001
    case road   = 0b0010
    case wall   = 0b0100
    case person = 0b1000
}

class ChampionSelectScene: SKScene {
    var player: SKNode!
    var person: SKNode!
    var tileMap: SKTileMapNode!

    var currentMovingDirection: Direction?

    weak var actionButtonVisibilityDelegate: ActionButtonVisibilityDelegate?

    override func didMove(to view: SKView) {
        self.setupNodes()
        self.setupCameraConstraints()
    }

    private func setupNodes() {
        guard let camera = self.childNode(withName: Nodes.camera.rawValue) as? SKCameraNode else { return }
        guard let player = self.childNode(withName: Nodes.player.rawValue) else { return }
        guard let person = self.childNode(withName: Nodes.person.rawValue) else { return }
        guard let tileMap = self.childNode(withName: Nodes.tileMap.rawValue) as? SKTileMapNode else { return }

        self.player = player
        self.person = person
        self.tileMap = tileMap
        self.camera = camera

        self.physicsWorld.contactDelegate = self

        self.setupPlayer()
        self.setupPerson()
        self.setupTileMap()
    }

    private func setupPlayer() {
        let physicsBody = SKPhysicsBody(rectangleOf: self.player.frame.size)
        physicsBody.allowsRotation = false
        physicsBody.categoryBitMask = CategoryMask.player.rawValue
        physicsBody.collisionBitMask = CategoryMask.wall.rawValue
        physicsBody.contactTestBitMask = CategoryMask.wall.rawValue | CategoryMask.person.rawValue
        self.player.physicsBody = physicsBody
    }

    private func setupPerson() {
        let physicsBody = SKPhysicsBody(rectangleOf: self.player.frame.size)
        physicsBody.categoryBitMask = CategoryMask.person.rawValue
        physicsBody.isDynamic = false
        self.person.physicsBody = physicsBody
    }

    private func setupTileMap() {
        var table: [[Int?]] = [
            [1, 1, 1, 1, 2, 2, 1, 1],
            [1, 1, 1, 2, 2, 2, 1, 1],
            [2, 2, 2, 2, 2, 1, 3, 3],
            [2, 2, 1, 1, 1, 1, 3, 3],
            [2, 2, 3, 3, 3, 3, 3, 3]
        ]

        func floodFill<T>(for table: inout [[T?]])
            -> [(type: T, nodes: [(node: T, x: Int, y: Int)])]
            where T: Equatable & ExpressibleByIntegerLiteral
        {
            var group = [(type: T, nodes: [(node: T, x: Int, y: Int)])]()
            while case let (x, y, initialNode)?: (Int, Int, T)? = {
                for y in 0..<table.count {
                    for x in 0..<table[y].count {
                        if let node = table[y][x] {
                            return (x, y, node)
                        }
                    }
                }
                return nil
            }() {
                var currentGroup = [(node: T, x: Int, y: Int)]()
                func _floodFill(_ x: Int, _ y: Int) {
                    guard
                        x >= 0,
                        x < table[0].count,
                        y >= 0,
                        y < table.count,
                        let node = table[y][x],
                        node == initialNode
                    else { return }
                    currentGroup.append(
                        (
                            node: node,
                            x: x,
                            y: y
                        )
                    )
                    table[y][x] = nil
                    _floodFill(x + 1, y    )
                    _floodFill(x - 1, y    )
                    _floodFill(x    , y + 1)
                    _floodFill(x    , y - 1)
                }
                _floodFill(x, y)
                group.append((type: initialNode, nodes: currentGroup))
            }
            return group
        }

        let flood = floodFill(for: &table)
        for e in flood {
            print("Type \(e.type):")
            for f in e.nodes {
                print("x: \(f.x), y: \(f.y)")
            }
            print("\n")
        }

        let tileSize = self.tileMap.tileSize
        let halfWidth = CGFloat(self.tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(self.tileMap.numberOfRows) / 2.0 * tileSize.height
        for column in 0..<self.tileMap.numberOfColumns {
            for row in 0..<self.tileMap.numberOfRows {
                if
                    let tileDefinition = self.tileMap.tileDefinition(atColumn: column, row: row),
                    tileDefinition.name == Nodes.wall.rawValue
                {
                    let tileX = CGFloat(column) * tileSize.width - halfWidth
                    let tileY = CGFloat(row) * tileSize.height - halfHeight
                    let rect = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
                    let tileNode = SKShapeNode(rect: rect)
                    tileNode.strokeColor = .clear
                    tileNode.position = CGPoint(x: tileX, y: tileY)
                    let physicsBodyCenter = CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0)
                    let physicsBody = SKPhysicsBody(rectangleOf: tileSize, center: physicsBodyCenter)
                    physicsBody.isDynamic = false
                    physicsBody.categoryBitMask = CategoryMask.wall.rawValue
                    tileNode.physicsBody = physicsBody
                    self.tileMap.addChild(tileNode)
                }
            }
        }
    }

    private func setupCameraConstraints() {
        guard let camera = self.camera else { return }

        let playerConstraint = SKConstraint.distance(.init(constantValue: 0.0), to: self.player)

        let scaledSize = CGSize(
            width: self.size.width * camera.xScale,
            height: self.size.height * camera.yScale
        )
        let tileMapContentRect = tileMap.calculateAccumulatedFrame()
        let xInset = min(scaledSize.width / 2, tileMapContentRect.width / 2)
        let yInset = min(scaledSize.height / 2, tileMapContentRect.height / 2)
        let insetContentRect = tileMapContentRect.insetBy(dx: xInset, dy: yInset)
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)
        let boardConstraint = SKConstraint.positionX(xRange, y: yRange)
        boardConstraint.referenceNode = tileMap

        camera.constraints = [playerConstraint, boardConstraint]
    }
}

extension ChampionSelectScene: HUDDelegate {
    func hudTapped(for direction: Direction) {
        self.currentMovingDirection = direction
        var newPosition = CGPoint.zero
        switch direction {
        case .top:
            newPosition.y += Constants.moveAmount
        case .left:
            newPosition.x -= Constants.moveAmount
        case .right:
            newPosition.x += Constants.moveAmount
        case .bottom:
            newPosition.y -= Constants.moveAmount
        case .action:
            break
        }
        let moveAction = SKAction.move(by: newPosition.cgVector, duration: 0.1)
        let repeatForeverAction = SKAction.repeatForever(moveAction)
        let actionSequence = SKAction.sequence([moveAction, repeatForeverAction])
        self.player.run(actionSequence, withKey: direction.rawValue)
    }

    func hudReleased(for direction: Direction) {
        self.player.removeAction(forKey: direction.rawValue)
    }
}

extension ChampionSelectScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if
            contact.bodyA.categoryBitMask == CategoryMask.player.rawValue &&
            contact.bodyB.categoryBitMask == CategoryMask.person.rawValue
        {
            self.actionButtonVisibilityDelegate?.toggleActionButton(to: true)
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        if
            contact.bodyA.categoryBitMask == CategoryMask.player.rawValue &&
            contact.bodyB.categoryBitMask == CategoryMask.person.rawValue
        {
            self.actionButtonVisibilityDelegate?.toggleActionButton(to: false)
        }
    }
}
