//
//  HUDScene.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 25/02/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit

class HUDScene: SKScene {
    
    weak var hudDelegate: HUDDelegate?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        self.view?.backgroundColor = .clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let position = touch?.location(in: self) {
            if let tappedNode = self.nodes(at: position).first, let nodeName = tappedNode.name, let direction = Direction(rawValue: nodeName) {
                self.hudDelegate?.hudTapped(for: direction)
            }
        }
    }
    
    func cancelAllDirections() {
        let directions: [Direction] = [.top, .right, .bottom, .left]
        directions.forEach {
            self.hudDelegate?.hudReleased(for: $0)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let positionInView = touch?.location(in: self.view) {
            if positionInView.x < 0 || positionInView.y < 0 {
                self.cancelAllDirections()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cancelAllDirections()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cancelAllDirections()
    }
}
