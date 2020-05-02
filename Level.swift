//
//  Level.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 13/04/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit

enum Nodes: String {
    case player
    case tileMap
    case portal
    case arrow
}

enum Mask: UInt32, CaseIterable {
    case player    = 0b00000001
    case wall      = 0b00000010
    case portal    = 0b00000100
    case arrow     = 0b00001000
    case `default` = 0b11111111
    
    static func fromType(_ type: String) -> Self {
        return self.allCases.first{ "\($0)" == type } ?? .default
    }
}

class Level: GameScene {
    var player: SKSpriteNode!
    var tileMap: SKTileMapNode!
    var portal: SKSpriteNode!
    
    var label = SKLabelNode()
    
    var isPlayerStanding = false
    var isGravityInversed = false
    
    func getLevelNumber(from string: String) -> Int {
        if
            let regex = try? NSRegularExpression(pattern: #"Level(\d+)$"#, options: .caseInsensitive),
            let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)),
            let numberRange = Range(match.range(at: 1), in: string),
            let number = Int(string[numberRange])
        {
            return number
        } else {
            fatalError()
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.physicsWorld.contactDelegate = self
        self.setupNodes()
        self.setupPortal()
        self.setupTileMap()
        self.setupPlayer()
        let levelString = String(NSStringFromClass(Self.self))
        self.showLabel(with: "Level \(self.getLevelNumber(from: levelString))")
    }
    
    private func setupNodes() {
        self.player = self.childNode(withName: Nodes.player.rawValue) as? SKSpriteNode
        self.tileMap = self.childNode(withName: Nodes.tileMap.rawValue) as? SKTileMapNode
        self.portal = self.childNode(withName: Nodes.portal.rawValue) as? SKSpriteNode
        self.addChild(self.label)
    }
    
    private func setupPortal() {
        let physicsBody = SKPhysicsBody(rectangleOf: self.portal.frame.size)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = Mask.portal.rawValue
        self.portal.physicsBody = physicsBody
    }
    
    private func setupPlayer() {
        var rect = self.player.frame.size
        rect.width -= 5
        let physicsBody = SKPhysicsBody(rectangleOf: rect)
        physicsBody.allowsRotation = false
        physicsBody.categoryBitMask = Mask.player.rawValue
        physicsBody.collisionBitMask = Mask.wall.rawValue | Mask.portal.rawValue
        physicsBody.contactTestBitMask = Mask.wall.rawValue | Mask.portal.rawValue | Mask.arrow.rawValue
        physicsBody.restitution = 0
        self.player.physicsBody = physicsBody
    }
    
    private func showLabel(with text: String, completionHandler: @escaping () -> Void = {}) {
        self.label.text = text
        self.label.fontName = "ThaleahFat"
        self.label.fontSize = 20
        self.label.position = .zero
        self.label.alpha = 0
        self.label.run(.sequence([
            .fadeAlpha(by: 1, duration: 1),
            .wait(forDuration: 1),
            .fadeAlpha(by: -1, duration: 1),
            .run(completionHandler)
        ]))
    }
    
    private func setupTileMap() {
        self.tileMap.isHidden = true
        let tileSize = self.tileMap.tileSize
        let halfWidth = CGFloat(self.tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(self.tileMap.numberOfRows) / 2.0 * tileSize.height
        for row in 0..<self.tileMap.numberOfRows {
            for column in 0..<self.tileMap.numberOfColumns {
                if
                    let tileDefinition = self.tileMap.tileDefinition(atColumn: column, row: row),
                    let tileName = tileDefinition.name
                {
                    let tileX = CGFloat(column) * tileSize.width - halfWidth
                    let tileY = CGFloat(row) * tileSize.height - halfHeight
                    let rect = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
                    let tileNode = SKShapeNode(rect: rect)
                    tileNode.name = tileName
                    tileNode.strokeColor = .clear
                    tileNode.fillColor = .white
                    tileNode.fillTexture = SKTexture(image: UIImage(named: tileName)!)
                    tileNode.position = CGPoint(x: tileX, y: tileY)
                    tileNode.name = "tile-\(tileName)-\(row)-\(column)"
                    let physicsBodyCenter = CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0)
                    let physicsBody = SKPhysicsBody(rectangleOf: tileSize, center: physicsBodyCenter)
                    physicsBody.isDynamic = false
                    physicsBody.categoryBitMask = Mask.fromType(tileName).rawValue
                    physicsBody.restitution = 0
                    tileNode.physicsBody = physicsBody
                    self.addChild(tileNode)
                }
            }
        }
    }
    
    override func hudTapped(for direction: Direction) {
        switch direction {
        case .left, .right:
            self.moveHorizontally(in: direction)
        case .top, .bottom:
            self.moveVertically(in: direction)
        default:
            return
        }
    }
    
    func moveHorizontally(in direction: Direction) {
        var newPosition = CGPoint.zero
        newPosition.x += Constants.moveAmount * (direction == .left ? -1 : 1)
        var direction = direction
        if isGravityInversed {
            if direction == .left {
                direction = .right
            } else {
                direction = .left
            }
        }
        let textures = AssetsLoader.textures(for: .finnachu, direction: direction)
        self.player.texture = textures[0]
        let frameAction = SKAction.repeatForever(
            SKAction.animate(with: textures, timePerFrame: 0.25, resize: false, restore: true)
        )
        let moveAction = SKAction.move(by: newPosition.cgVector, duration: 0.1)
        let repeatAction = SKAction.repeatForever(moveAction)
        let actionGroup = SKAction.group([frameAction, repeatAction])
        self.player.run(actionGroup, withKey: direction.rawValue)
    }
    
    func moveVertically(in direction: Direction) {}
    
    override func hudReleased(for direction: Direction) {
        self.player.removeAction(forKey: direction.rawValue)
    }
    
    override func actionTapped() {
        if self.isPlayerStanding {
            self.player.physicsBody?.applyImpulse(.init(dx: 0, dy: 3))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let bodies = self.player.physicsBody?.allContactedBodies() {
            self.isPlayerStanding =
                bodies.contains(where: {
                    $0.node?.physicsBody?.categoryBitMask == Mask.wall.rawValue
                })
        }
        if self.player.position.y < -self.size.height / 2 || self.player.position.y > self.size.height / 2 {
            self.levelFailed()
        }
    }
    
    func levelFailed() {
        if self.player.parent != nil {
            self.player.removeFromParent()
            self.showLabel(with: "Failed") { [weak self] in
                self?.sceneDelegate?.changeScene(to: Self.self)
            }
        }
    }
}

extension Level: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case Mask.player.rawValue | Mask.portal.rawValue:
            let currentClassString = String(NSStringFromClass(Self.self))
            let levelNumber = self.getLevelNumber(from: currentClassString)
            let nextLevelNumber = levelNumber + 1
            let nextClassString = "Ancient_Hill.Level\(nextLevelNumber)"
            UserDefaults.standard.set(true, forKey: "level-\(nextLevelNumber)")
            self.sceneDelegate?.changeScene(to: NSClassFromString(nextClassString) as! Level.Type)
        default:
            break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {}
}
