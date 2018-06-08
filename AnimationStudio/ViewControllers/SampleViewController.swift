//
//  SampleViewController.swift
//  BoundlessKit
//
//  Created by Akash Desai on 07/13/2016.
//  Copyright (c) 2016 Akash Desai. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {
    
    @IBOutlet weak var buttonView: UIImageView!
    var backgroundImage: UIImageView!
    
    var mainMenu: MainMenu!
    
    override func viewDidLoad() {
        
        // create main menu
        mainMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
        mainMenu.mainMenuDelegate = self
        addChildViewController(mainMenu)
        self.view.addSubview(mainMenu.view)
        let mainMenuOrigin = CGPoint.init(x: 0, y: view.bounds.height * 3 / 5)
        mainMenu.view.frame = CGRect.init(origin: mainMenuOrigin, size: CGSize.init(width: view.bounds.width, height: view.bounds.height - mainMenuOrigin.y))
        mainMenu.didMove(toParentViewController: self)
        
        // create background imageview
        backgroundImage = UIImageView.init(frame: view.bounds)
        backgroundImage.contentMode = .scaleAspectFit
        view.insertSubview(backgroundImage, at: 0)
        
        // create button imageview
        buttonView.isUserInteractionEnabled = true
        buttonView.isMultipleTouchEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        let scaleGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
        tapGesture.delegate = self
        panGesture.delegate = self
        scaleGesture.delegate = self
        buttonView.addGestureRecognizer(tapGesture)
        buttonView.addGestureRecognizer(panGesture)
        buttonView.addGestureRecognizer(scaleGesture)
        
        // tap gesture to hide navigation
        let tapToHide = UITapGestureRecognizer(target: self, action: #selector(toggleFullscreen))
        tapToHide.delegate = self
        tapToHide.numberOfTapsRequired = 2
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapToHide)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set background image
        if let str = RewardSample.current.settings[ImportedImageType.background.key] as? String {
            self.backgroundImage.image = UIImage.from(base64String: str)
            self.view.backgroundColor = .black
        } else {
            self.backgroundImage.image = nil
        }
        
        // set button image, frame, & transform
        if let str = RewardSample.current.settings[ImportedImageType.button.key] as? String,
            let buttonImage = UIImage.from(base64String: str) {
            self.buttonView.image = buttonImage
            if let str = RewardSample.current.settings["buttonViewFrame"] as? String {
                buttonView.frame = CGRectFromString(str)
            }
            if let str = RewardSample.current.settings["buttonViewTransform"] as? String {
                buttonView.transform = CGAffineTransformFromString(str)
            }
        } else {
            buttonView.image = UIImage(named: "clickMe")
        }
        buttonView.sizeToFit()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: {_ in
//            self.backgroundImage.center = self.view.center
            self.backgroundImage.frame = self.view.bounds
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = RewardSample.current.rewardID
    }
    
    @objc @IBAction
    func toggleFullscreen() {
        let showFullscreen = !mainMenu.view.isHidden
        mainMenu.view.isHidden = showFullscreen
        navigationController?.setNavigationBarHidden(showFullscreen, animated: true)
    }
    
    @IBAction
    func editReward() {
        let rewardForm = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: RewardSample.current.rewardPrimitive.rawValue + "Form") as! RewardForm
        rewardForm.reward = RewardSample.current
        rewardForm.form = rewardForm.generateForm()
        self.navigationController?.pushViewController(rewardForm, animated: true)
    }
    
}

extension SampleViewController : MainMenuDelegate {
    func shouldResetButton() {
        self.buttonView.transform = .identity
        let ratio = buttonView.frame.height / buttonView.frame.width
        self.buttonView.frame = CGRect.init(x: 0, y: 0, width: 120, height: ratio * 120)
        buttonView.center = view.center
    }
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    func didImport(image: UIImage, type: ImportedImageType) {
        DispatchQueue.main.async {
            switch type {
            case .button:
                self.buttonView.image = image
                self.shouldResetButton()
                
            case .background:
                self.backgroundImage.image = image
            }
        }
        RewardSample.current.settings[type.key] = image.base64String
        RewardSample.current.save()
    }
}

extension SampleViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    @objc
    func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc
    func tap(_ gesture: UITapGestureRecognizer) {
        RewardSample.current.sample(target: self, sender: buttonView)
        
        RewardSample.current.settings["buttonViewFrame"] = NSStringFromCGRect(buttonView.frame)
        RewardSample.current.settings["buttonViewTransform"] = NSStringFromCGAffineTransform(buttonView.transform)
//        RewardSample.current.save()
    }
    
    @objc
    func pan(_ gesture:UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: view)
            gesture.setTranslation(.zero, in: view)
            buttonView.frame = buttonView.frame.applying(CGAffineTransform.init(translationX: translation.x, y: translation.y))
        } else if gesture.state == .ended {
            RewardSample.current.settings["buttonViewFrame"] = NSStringFromCGRect(buttonView.frame)
            RewardSample.current.save()
        }
    }
    
    @objc
    func scale(_ gesture: UIPinchGestureRecognizer) {
        gesture.view?.transform = gesture.view!.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
        if gesture.state == .ended {
            RewardSample.current.settings["buttonViewTransform"] = NSStringFromCGAffineTransform(buttonView.transform)
            RewardSample.current.save()
        }
    }
    
    @objc
    func rotate(_ gesture: UIRotationGestureRecognizer) {
        gesture.view?.transform = gesture.view!.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
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
