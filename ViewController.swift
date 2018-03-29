//
//  ViewController.swift
//  AgenceCalendar
//
//  Created by Gerardo Lupa on 24-03-18.
//  Copyright © 2018 Gerardo Lupa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var mi_coleccion: UICollectionView!
    //fileprivate var numbers: [Int] = []
    //var numbers: [Int] = []
    let bgColors = [UIColor.brown, UIColor.gray, UIColor.green, UIColor.orange, UIColor.cyan]
    var tematica = ["Integrating swift with objective-c", "What's the new in LLVM", "View Controllers advanced in iOS 8", "Working With Metal: Overview", "Cross Platform Nearby Networking", "TextKit and Core text Lab", "Foundtaion Lab", "iCloud Document Labs", "Core Data Lab", "The New Itunes", "Debudding Xcode 6", "Build Adaptive Apps with UIkit", "Working With Metal: Fundamental", ""]
   
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        for _ in 0...100 {
            let height = Int(arc4random_uniform((UInt32(100)))) + 40
            numbers.append(height)
        }
        */
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongGesture(_:)))
        self.mi_coleccion.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.mi_coleccion.indexPathForItem(at: gesture.location(in: self.mi_coleccion)) else {
                break
            }
            mi_coleccion.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            mi_coleccion.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            mi_coleccion.endInteractiveMovement()
        default:
            mi_coleccion.cancelInteractiveMovement()
        }
    }
    
}

extension ViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        /*
        var ancho = [Int((view.bounds.width - 40)/3),200]
        let number = ancho[Int(arc4random_uniform(UInt32(ancho.count)))]
        
        return CGSize(width: number, height: 100)
        */
         return CGSize(width: Int((view.bounds.width - 40)/3), height: 150)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tematica.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = mi_coleccion.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TextoColeccion
        cell.textLabel.text = "\(tematica[indexPath.item])"
//        var numberScreen = arc4random_uniform(bgColors.count)
        let diceRoll = Int(arc4random_uniform(UInt32(bgColors.count)))
        let bgColor = self.bgColors[diceRoll]
        cell.backgroundColor = bgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let temp = tematica.remove(at: sourceIndexPath.item)
        tematica.insert(temp, at: destinationIndexPath.item)
    }
    
}

//MARK: one little trick
extension CHTCollectionViewWaterfallLayout {
    
    internal override func invalidationContext(forInteractivelyMovingItems targetIndexPaths: [IndexPath], withTargetPosition targetPosition: CGPoint, previousIndexPaths: [IndexPath], previousPosition: CGPoint) -> UICollectionViewLayoutInvalidationContext {
        
        let context = super.invalidationContext(forInteractivelyMovingItems: targetIndexPaths, withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths, previousPosition: previousPosition)
        
        self.delegate?.collectionView!(self.collectionView!, moveItemAt: previousIndexPaths[0], to: targetIndexPaths[0])
        
        return context
    }

}

