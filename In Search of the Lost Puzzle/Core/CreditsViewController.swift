//
//  CreditsViewController.swift
//  In Search of the Lost Puzzle
//
//  Created by Dimitrie-Toma Furdui on 02/05/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
        let bottomOffset = self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInset.bottom
        self.scrollView.setContentOffset(CGPoint(x: 0, y: bottomOffset), animated: false)
    }
}
