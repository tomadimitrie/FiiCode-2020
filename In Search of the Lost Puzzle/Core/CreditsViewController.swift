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
    @IBOutlet weak var imageView: UIImageView!
    
    var confettiView: SwiftConfettiView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.puzzleTapped)))
        self.confettiView = SwiftConfettiView(frame: self.view.bounds)
        self.confettiView.isUserInteractionEnabled = false
        self.view.addSubview(self.confettiView)
    }
    
    @objc private func puzzleTapped() {
        self.confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performSegue(withIdentifier: "end", sender: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
        let bottomOffset = self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInset.bottom
        self.scrollView.setContentOffset(CGPoint(x: 0, y: bottomOffset), animated: false)
    }
}

public class SwiftConfettiView: UIView {
    var emitter: CAEmitterLayer!
    public var colors: [UIColor]!
    public var intensity: Float!
    private var active: Bool!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        self.colors = [
            UIColor(red: 0.95, green: 0.40, blue: 0.27, alpha: 1.0),
            UIColor(red: 1.00, green: 0.78, blue: 0.36, alpha: 1.0),
            UIColor(red: 0.48, green: 0.78, blue: 0.64, alpha: 1.0),
            UIColor(red: 0.30, green: 0.76, blue: 0.85, alpha: 1.0),
            UIColor(red: 0.58, green: 0.39, blue: 0.55, alpha: 1.0)
        ]
        self.intensity = 0.5
        self.active = false
    }
    
    public func startConfetti() {
        self.emitter = CAEmitterLayer()
        
        self.emitter.emitterPosition = CGPoint(x: self.frame.size.width / 2.0, y: 0)
        self.emitter.emitterShape = CAEmitterLayerEmitterShape.line
        self.emitter.emitterSize = CGSize(width: self.frame.size.width, height: 1)
        
        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(self.confetti(color: color))
        }
        
        self.emitter.emitterCells = cells
        self.layer.addSublayer(emitter)
        self.active = true
    }
    
    public func stopConfetti() {
        self.emitter?.birthRate = 0
        self.active = false
    }
    
    func confetti(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 6.0 * self.intensity
        confetti.lifetime = 14.0 * self.intensity
        confetti.lifetimeRange = 0
        confetti.color = color.cgColor
        confetti.velocity = CGFloat(350.0 * self.intensity)
        confetti.velocityRange = CGFloat(80.0 * self.intensity)
        confetti.emissionLongitude = CGFloat(Double.pi)
        confetti.emissionRange = CGFloat(Double.pi)
        confetti.spin = CGFloat(3.5 * self.intensity)
        confetti.spinRange = CGFloat(4.0 * self.intensity)
        confetti.scaleRange = CGFloat(self.intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * self.intensity)
        confetti.contents = UIImage(named: "star")!.cgImage
        return confetti
    }
    
    public func isActive() -> Bool {
        return self.active
    }
}

