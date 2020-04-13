//
//  ActionButton.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 13/04/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit

class ActionButtonScene: SKScene {

    weak var actionButtonDelegate: ActionButtonDelegate?

    override func didMove(to view: SKView) {
        self.setupView()
    }

    private func setupView() {
        self.backgroundColor = .clear
        self.view?.backgroundColor = .clear
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.actionButtonDelegate?.actionTapped()
    }
}
