//
//  ChooseLevelViewController.swift
//  Ancient Hill
//
//  Created by Dimitrie-Toma Furdui on 02/05/2020.
//  Copyright © 2020 Green Meerkats of Romania. All rights reserved.
//

import UIKit

class ChooseLevelViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let itemWidth = 50
    let spacing = 15
    let numberOfItems = 5
    
    override func viewDidLoad() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundView?.backgroundColor = .clear
        self.collectionView.backgroundColor = .clear
        self.collectionView.isScrollEnabled = false
    }
}

extension ChooseLevelViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let levelNumber = indexPath.section * 5 + indexPath.row + 1
        if !UserDefaults.standard.bool(forKey: "level-\(levelNumber)") && levelNumber != 1 {
            cell.isUserInteractionEnabled = false
            cell.alpha = 0.5
            cell.contentView.alpha = 0.5
        }
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = "\(levelNumber)"
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems
    }
}

extension ChooseLevelViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "level", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "level" {
            let vc = segue.destination as! GameViewController
            let indexPath = sender as! IndexPath
            let levelNumber = indexPath.section * 5 + indexPath.row + 1
            vc.levelToLoad = levelNumber
        }
    }
}

extension ChooseLevelViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.itemWidth, height: self.itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = self.itemWidth * self.numberOfItems
        let totalSpacingWidth = self.spacing * (self.numberOfItems - 1)
        
        let leftInset = (collectionView.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 25, right: rightInset)
    }
}

