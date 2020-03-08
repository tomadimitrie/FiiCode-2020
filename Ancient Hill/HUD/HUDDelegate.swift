//
//  HUDDelegate.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 25/02/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import Foundation

enum Direction: String {
    case top = "top"
    case right = "right"
    case bottom = "bottom"
    case left = "left"
    case action = "action"
}

protocol HUDDelegate: class {
    func hudTapped(for direction: Direction)
    func hudReleased(for direction: Direction)
}

protocol ActionButtonVisibilityDelegate: class {
    func toggleActionButton(to flag: Bool)
}
