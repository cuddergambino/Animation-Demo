//
//  SampleViewController.swift
//  BoundlessKit
//
//  Created by Akash Desai on 07/13/2016.
//  Copyright (c) 2016 Akash Desai. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {
    
    static var sampleButtonViewFrame: CGRect?
    @IBOutlet weak var buttonView: UIImageView!
    var backgroundImage: UIImageView!
    
    var mainMenu: MainMenu!
    
    
    override func viewDidLoad() {
        
        mainMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
        mainMenu.mainMenuDelegate = self
        addChildViewController(mainMenu)
        self.view.addSubview(mainMenu.view)
        let mainMenuOrigin = CGPoint.init(x: 0, y: view.bounds.height * 3 / 5)
        mainMenu.view.frame = CGRect.init(origin: mainMenuOrigin, size: CGSize.init(width: view.bounds.width, height: view.bounds.height - mainMenuOrigin.y))
        mainMenu.didMove(toParentViewController: self)
        
        backgroundImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width, height: mainMenuOrigin.y))
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.frame = view.bounds
        view.insertSubview(backgroundImage, at: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        let scaleGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
        tapGesture.delegate = self
        panGesture.delegate = self
        scaleGesture.delegate = self
        rotateGesture.delegate = self
        buttonView.isUserInteractionEnabled = true
        buttonView.addGestureRecognizer(tapGesture)
        buttonView.addGestureRecognizer(panGesture)
        buttonView.addGestureRecognizer(scaleGesture)
        buttonView.addGestureRecognizer(rotateGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let str = RewardSample.current.settings[ImportedImageType.button.key] as? String,
            let buttonImage = UIImage.from(base64String: str) {
            let origin = self.buttonView.frame.origin
            self.buttonView.image = buttonImage
            self.buttonView.frame.origin = origin
        } else {
            buttonView.image = UIImage(named: "clickMe")
        }
        
        if let str = RewardSample.current.settings[ImportedImageType.background.key] as? String {
            self.backgroundImage.image = UIImage.from(base64String: str)
        } else {
            self.backgroundImage.image = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = RewardSample.current.rewardPrimitive.rawValue
        SampleViewController.sampleButtonViewFrame = buttonView.frame
    }
    
    var aViewStartingOrigin = CGPoint.zero
    var identity = CGAffineTransform.identity
}

extension SampleViewController : MainMenuDelegate {
    func didSelectFullscreen() {
        let vc = FullscreenSampleViewController()
        vc.backgroundImage = UIImageView(image: self.backgroundImage.image)
        vc.buttonImage = UIImageView(image: self.buttonView.image)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func didImport(image: UIImage, type: ImportedImageType) {
        DispatchQueue.main.async {
            switch type {
            case .button:
                let origin = self.buttonView.frame.origin
                self.buttonView.image = image
                self.buttonView.frame.origin = origin
                
            case .background:
                self.backgroundImage.image = image
            }
        }
        RewardSample.current.settings[type.key] = image.base64String
        RewardSample.current.save()
    }
}

extension SampleViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @objc func tap(_ gesture: UITapGestureRecognizer) {
        RewardSample.current.sample(target: self, sender: buttonView)
        SampleViewController.sampleButtonViewFrame = buttonView.frame
    }
    @objc func pan(_ gesture:UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            let trans = gesture.translation(in: view)
            gesture.setTranslation(.zero, in: view)
            buttonView.frame = buttonView.frame.applying(CGAffineTransform.init(translationX: trans.x, y: trans.y))
        }
    }
    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            identity = buttonView.transform
        case .changed:
            buttonView.transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
        case .cancelled:
            break
        default:
            break
        }
    }
    @objc func rotate(_ gesture: UIRotationGestureRecognizer) {
        buttonView.transform = buttonView.transform.rotated(by: gesture.rotation)
    }
}


extension UIImage {
    var base64String: String? {
        return UIImagePNGRepresentation(self)?.base64EncodedString()
    }
    
    static func from(base64String: String) -> UIImage? {
        if let data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters),
            let image = UIImage(data: data) {
            return image
        } else {
            return nil
        }
    }
}
