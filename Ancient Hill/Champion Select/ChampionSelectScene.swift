import SpriteKit

private enum Nodes: String {
    case camera
    case player
    case person = "finnachu"
    case tileMap
    case wall
    case road
    case portal
}

private enum CategoryMask: UInt32 {
    case player = 0b00001
    case road   = 0b00010
    case wall   = 0b00100
    case person = 0b01000
    case portal = 0b10000
}

class ChampionSelectScene: GameScene {
    var player: SKSpriteNode!
    var person: SKSpriteNode!
    var tileMap: SKTileMapNode!
    var portal: SKSpriteNode!

    var currentMovingDirection: Direction?

    override func didMove(to view: SKView) {
        self.setupNodes()
        self.setupCameraConstraints()
    }

    private func setupNodes() {
        guard let camera = self.childNode(withName: Nodes.camera.rawValue) as? SKCameraNode else { return }
        guard let player = self.childNode(withName: Nodes.player.rawValue) as? SKSpriteNode else { return }
        guard let person = self.childNode(withName: Nodes.person.rawValue) as? SKSpriteNode else { return }
        guard let tileMap = self.childNode(withName: Nodes.tileMap.rawValue) as? SKTileMapNode else { return }
        guard let portal = self.childNode(withName: Nodes.portal.rawValue) as? SKSpriteNode else { return }

        self.player = player
        self.person = person
        self.tileMap = tileMap
        self.portal = portal
        self.camera = camera

        self.physicsWorld.contactDelegate = self

        self.setupPlayer()
        self.setupPerson()
        self.setupTileMap()
        self.setupPortal()
    }

    private func setupPlayer() {
        let physicsBody = SKPhysicsBody(rectangleOf: self.player.frame.size)
        physicsBody.allowsRotation = false
        physicsBody.categoryBitMask = CategoryMask.player.rawValue
        physicsBody.collisionBitMask = CategoryMask.wall.rawValue
        physicsBody.contactTestBitMask = CategoryMask.wall.rawValue | CategoryMask.person.rawValue | CategoryMask.portal.rawValue
        self.player.physicsBody = physicsBody
    }

    private func setupPerson() {
        let physicsBody = SKPhysicsBody(rectangleOf: self.player.frame.size)
        physicsBody.categoryBitMask = CategoryMask.person.rawValue
        physicsBody.isDynamic = false
        self.person.physicsBody = physicsBody
    }

    private func setupTileMap() {
        let tileSize = self.tileMap.tileSize
        let halfWidth = CGFloat(self.tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(self.tileMap.numberOfRows) / 2.0 * tileSize.height
        var table = [[(type: String, position: CGPoint)?]]()
        for row in 0..<self.tileMap.numberOfRows {
            var tableRow = [(type: String, position: CGPoint)?]()
            for column in 0..<self.tileMap.numberOfColumns {
                if
                    let tileDefinition = self.tileMap.tileDefinition(atColumn: column, row: row),
                    let tileName = tileDefinition.name
                {
                    switch tileName {
                    case "wall":
                        let tileX = CGFloat(column) * tileSize.width - halfWidth
                        let tileY = CGFloat(row) * tileSize.height - halfHeight
                        let rect = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
                        let tileNode = SKShapeNode(rect: rect)
                        tileNode.strokeColor = .clear
                        tileNode.position = CGPoint(x: tileX, y: tileY)
                        tableRow.append((type: tileName, position: tileNode.position))
                        let physicsBodyCenter = CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0)
                        let physicsBody = SKPhysicsBody(rectangleOf: tileSize, center: physicsBodyCenter)
                        physicsBody.isDynamic = false
                        physicsBody.categoryBitMask = CategoryMask.wall.rawValue
                        tileNode.physicsBody = physicsBody
                        self.tileMap.addChild(tileNode)
                   
                    default:
                        break
                    }
                }
            }
            table.append(tableRow)
        }
//        let flood = NodeHelper.floodFill(for: &table).mapValues {
//            $0.map {
//                $0.map {
//                    NodeHelper.Node(tileSize: tileSize, center: $0)
//                }
//            }
//        }
    }
    
    private func setupPortal() {
        let physicsBody = SKPhysicsBody(rectangleOf: self.portal.frame.size)
        physicsBody.categoryBitMask = CategoryMask.portal.rawValue
        physicsBody.isDynamic = false
        self.portal.physicsBody = physicsBody
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
    
    override func hudTapped(for direction: Direction) {
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
            self.dialogueDelegate?.toggleDialogue(to: true)
            return
        default:
            return
        }
        let textures = AssetsLoader.textures(for: .finnachu, direction: direction)
        var frameAction: SKAction? = nil
        if let textures = textures {
            self.player.texture = textures[0]
            frameAction = SKAction.repeatForever(
                SKAction.animate(with: textures, timePerFrame: 0.25, resize: false, restore: true)
            )
        }
        let moveAction = SKAction.repeatForever(
            SKAction.move(by: newPosition.cgVector, duration: 0.1)
        )
        let actionGroup = SKAction.group([frameAction, moveAction].compactMap { $0 })
        self.player.run(actionGroup, withKey: direction.rawValue)
    }

    override func hudReleased(for direction: Direction) {
        self.player.removeAction(forKey: direction.rawValue)
    }
}

extension ChampionSelectScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == CategoryMask.player.rawValue {
            switch contact.bodyB.categoryBitMask {
            case CategoryMask.person.rawValue:
                self.actionButtonDelegate?.toggleActionButton(to: true)
            case CategoryMask.portal.rawValue:
                self.sceneDelegate?.changeScene(to: ChampionSelectScene.self)
            default:
                break
            }
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        if
            contact.bodyA.categoryBitMask == CategoryMask.player.rawValue &&
            contact.bodyB.categoryBitMask == CategoryMask.person.rawValue
        {
            self.actionButtonDelegate?.toggleActionButton(to: false)
        }
    }
}
