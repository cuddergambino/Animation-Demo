//
//  ViewController.swift
//  BoundlessKit
//
//  Created by Akash Desai on 07/13/2016.
//  Copyright (c) 2016 Akash Desai. All rights reserved.
//

import UIKit
import BoundlessKit
import CoreLocation

class SampleViewController: UIViewController {
    
    var identity = CGAffineTransform.identity
    @IBOutlet weak var aView: UIImageView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let mainMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
        mainMenuController.mainMenuDelegate = self
        
        addChildViewController(mainMenuController)
        self.view.addSubview(mainMenuController.view)
        mainMenuController.view.frame = CGRect.init(x: 0, y: aView.frame.maxY + 30, width: view.bounds.width, height: view.bounds.maxY - aView.frame.maxY)
        mainMenuController.didMove(toParentViewController: self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        let scaleGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
        tapGesture.delegate = self
        panGesture.delegate = self
        scaleGesture.delegate = self
        rotateGesture.delegate = self
        
        
        aView.isUserInteractionEnabled = true
        aView.addGestureRecognizer(tapGesture)
        aView.addGestureRecognizer(panGesture)
        aView.addGestureRecognizer(scaleGesture)
        aView.addGestureRecognizer(rotateGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = RewardSample.current.settings["primitive"] as? String ?? navigationController?.navigationBar.topItem?.title
    }
}

extension SampleViewController : MainMenuDelegate {
    func didImport(image: UIImage) {
        DispatchQueue.main.async {
            self.aView.image = image
        }
    }
}

extension SampleViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @objc func tap(_ gesture: UITapGestureRecognizer) {
        RewardSample.current.sample(target: self, sender: aView)
    }
    @objc func pan(_ gesture:UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            let trans = gesture.translation(in: view)
            gesture.setTranslation(.zero, in: view)
            aView.center = aView.center.applying(CGAffineTransform.init(translationX: trans.x, y: trans.y))
        }
    }
    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            identity = aView.transform
        case .changed,.ended:
            aView.transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
        case .cancelled:
            break
        default:
            break
        }
    }
    @objc func rotate(_ gesture: UIRotationGestureRecognizer) {
        aView.transform = aView.transform.rotated(by: gesture.rotation)
    }
}

class DraggableImageView: UIImageView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = .blue
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = .green
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position = touches.first?.location(in: superview){
            center = position
        }
    }
}
