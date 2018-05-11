//
//  FullscreenSample.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class FullscreenSample : UIViewController {
    
    var backgroundImage: UIImageView!
    var buttonImage: UIImageView!
    
    override func viewDidLoad() {
        buttonImage.contentMode = .scaleAspectFit
        buttonImage.frame.origin = view.frame.origin
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.frame = view.bounds
        
        view.addSubview(backgroundImage)
        view.addSubview(buttonImage)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        let scaleGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
        tapGesture.delegate = self
        panGesture.delegate = self
        scaleGesture.delegate = self
        rotateGesture.delegate = self
        buttonImage.isUserInteractionEnabled = true
        buttonImage.addGestureRecognizer(tapGesture)
        buttonImage.addGestureRecognizer(panGesture)
        buttonImage.addGestureRecognizer(scaleGesture)
        buttonImage.addGestureRecognizer(rotateGesture)
    }
    var aViewStartingOrigin = CGPoint.zero
    var identity = CGAffineTransform.identity
}

extension FullscreenSample : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @objc func tap(_ gesture: UITapGestureRecognizer) {
        if Int(arc4random_uniform(UInt32(2))) > 0 {
            RewardSample.current.sample(target: self, sender: buttonImage)
        }
    }
    @objc func pan(_ gesture:UIPanGestureRecognizer) {
//        if gesture.state == .began || gesture.state == .changed {
        if gesture.state == .changed {
            let trans = gesture.translation(in: view)
            gesture.setTranslation(.zero, in: view)
            buttonImage.center = buttonImage.center.applying(CGAffineTransform.init(translationX: trans.x, y: trans.y))
        }
    }
    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            identity = buttonImage.transform
        case .changed:
            buttonImage.transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
        case .cancelled:
            break
        default:
            break
        }
    }
    @objc func rotate(_ gesture: UIRotationGestureRecognizer) {
        buttonImage.transform = buttonImage.transform.rotated(by: gesture.rotation)
    }
}

