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
    var backgroundView: UIImageView!
    
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
        backgroundView = UIImageView.init(frame: view.bounds)
        backgroundView.contentMode = .scaleAspectFit
        backgroundView.backgroundColor = .black
        view.insertSubview(backgroundView, at: 0)
        
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
        if let backgroundImage = RewardSample.current.backgroundImage {
            self.backgroundView.image = backgroundImage
            self.backgroundView.isHidden = false
        } else {
            self.backgroundView.image = nil
            self.backgroundView.isHidden = true
        }
        
        // set button image & frame
        let savedButton = RewardSample.current.buttonView
        buttonView.image = savedButton.image
        buttonView.frame = savedButton.frame
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: {_ in
//            self.backgroundImage.center = self.view.center
            self.backgroundView.frame = self.view.bounds
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
        self.buttonView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        self.buttonView.adjustHeight()
        buttonView.center = view.center
    }
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    func didImport(imageView: UIImageView, type: ImportedImageType) {
        DispatchQueue.main.async {
            switch type {
            case .button:
                let oldCenter = self.buttonView.center
                self.buttonView.image = imageView.image
                self.buttonView.center = oldCenter
                self.buttonView.adjustHeight()
                RewardSample.current.buttonView = self.buttonView
                
            case .background:
                self.backgroundView.image = imageView.image
                self.backgroundView.backgroundColor = .black
                RewardSample.current.backgroundImage = self.backgroundView.image
            }
            
            DispatchQueue.global().async {
                RewardSample.current.save()
            }
        }
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
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: view)
            gesture.setTranslation(.zero, in: view)
            buttonView.frame = buttonView.frame.applying(CGAffineTransform(translationX: translation.x, y: translation.y))
        
        case .ended:
            RewardSample.current.buttonView = buttonView
            DispatchQueue.global().async {
                RewardSample.current.save()
            }
            
        default: break
        }
    }
    
    @objc
    func scale(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .changed:
            if let oldCenter = gesture.view?.center {
                gesture.view?.frame = gesture.view!.frame.applying(CGAffineTransform(scaleX: gesture.scale, y: gesture.scale))
                gesture.view?.center = oldCenter
            }
            gesture.scale = 1
            
        case .ended:
            RewardSample.current.buttonView = self.buttonView
            DispatchQueue.global().async {
                RewardSample.current.save()
            }
            
        default: break
        }
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
