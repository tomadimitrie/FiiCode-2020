//
//  Level2.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 16/04/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import SpriteKit
import CoreMotion

class Level2: Level {
    override var helpText: String? {
        "You can't jump that distance, but you can try controlling the gravity ;) (or the phone orientation)"
    }
    
    let motionManager = CMMotionManager()
    var lastOrientation = UIInterfaceOrientation.landscapeLeft
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        if self.motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 0.1
            self.motionManager.accelerometerUpdateInterval = 0.2
            self.motionManager.gyroUpdateInterval = 0.2
            self.motionManager.startAccelerometerUpdates(
                to: OperationQueue()
            ) { [weak self] (accelerometerData, error) -> Void in
                if error == nil, let acceleration = accelerometerData?.acceleration {
                    self?.handleRotationChange(for: acceleration)
                }
            }
        }
    }
    
    private func handleRotationChange(for acceleration: CMAcceleration) {
        var newOrientation: UIInterfaceOrientation?
        if acceleration.x >= 0.75 {
            newOrientation = .landscapeLeft
        } else if acceleration.x <= -0.75 {
            newOrientation = .landscapeRight
        }
        if let newOrientation = newOrientation, newOrientation != self.lastOrientation {
            self.lastOrientation = newOrientation
            self.rotationDidChange()
        }
    }
    
    func rotationDidChange() {
        switch self.lastOrientation {
        case .landscapeRight:
            self.physicsWorld.gravity = CGVector(dx: 0, dy: 9.8)
            self.isGravityInversed = true
        case .landscapeLeft:
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
            self.isGravityInversed = false
        default:
            break
        }
        self.player.run(.rotate(byAngle: .pi, duration: 0.25))
    }
}
