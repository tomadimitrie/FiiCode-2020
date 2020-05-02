//
//  TheEndViewController.swift
//  In Search of the Lost Puzzle
//
//  Created by Dimitrie-Toma Furdui on 03/05/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import UIKit

class TheEndViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performSegue(withIdentifier: "beginning", sender: self)
        }
    }
}
