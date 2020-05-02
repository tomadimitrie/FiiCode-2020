//
//  FadeSegue.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 02/05/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import UIKit
import QuartzCore

class FadeSegue: UIStoryboardSegue {

   override func perform() {
        guard let destinationView = self.destination.view else {
            self.source.present(self.destination, animated: false, completion: nil)
            return
        }
        destinationView.alpha = 0
        self.source.view?.addSubview(destinationView)
        UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
            destinationView.alpha = 1
        }, completion: { _ in
            self.source.present(self.destination, animated: false, completion: nil)
        })
    }
}
