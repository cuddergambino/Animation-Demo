//
//  ViewController.swift
//  BoundlessKit
//
//  Created by Akash Desai on 07/13/2016.
//  Copyright (c) 2016 Akash Desai. All rights reserved.
//

import UIKit
import BoundlessKit

class SampleViewController: UIViewController {
    
    @IBOutlet weak var aView: UIImageView!
    
    var mainMenu: MainMenu!
    
    
    override func viewDidLoad() {
        mainMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
        mainMenu.mainMenuDelegate = self
        addChildViewController(mainMenu)
        self.view.addSubview(mainMenu.view)
        mainMenu.view.frame = CGRect.init(x: 0, y: aView.frame.maxY + 30, width: view.bounds.width, height: view.bounds.maxY - aView.frame.maxY)
        mainMenu.didMove(toParentViewController: self)
        
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
    
    var aViewStartingOrigin = CGPoint.zero
    var identity = CGAffineTransform.identity
}

extension SampleViewController : MainMenuDelegate {
    func didImport(image: UIImage, isButton: Bool) {
        DispatchQueue.main.async {
            if isButton {
                let origin = self.aView.frame.origin
                self.aView.image = image
                self.aView.frame.origin = origin
            } else {
                let vc = FullscreenSample()
                vc.backgroundImage = UIImageView(image: image)
                vc.buttonImage = UIImageView(image: self.aView.image)
                self.navigationController?.pushViewController(vc, animated: false)
            }
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
        case .changed:
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
