//
//  SampleViewController.swift
//  BoundlessKit
//
//  Created by Akash Desai on 07/13/2016.
//  Copyright (c) 2016 Akash Desai. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class SampleViewController: UIViewController {

    @IBOutlet weak var buttonView: UIImageView!
    var backgroundView: UIImageView!
    var movieLayer: AVPlayerLayer = AVPlayerLayer(player: AVPlayer())

    var mainMenu: MainMenu!

    override func viewDidLoad() {

        // add movie sublayer
        movieLayer.frame = view.bounds
        view.layer.addSublayer(movieLayer)

        // setup main menu
        mainMenu = .instantiate()
        mainMenu.mainMenuDelegate = self
        addChildViewController(mainMenu)
        view.addSubview(mainMenu.view)
        let mainMenuOrigin = CGPoint.init(x: 0, y: view.bounds.height * 3 / 5)
        mainMenu.view.frame = CGRect(origin: mainMenuOrigin,
                                     size: CGSize(width: view.bounds.width, height: view.bounds.height - mainMenuOrigin.y))
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
        view.isUserInteractionEnabled = true

        let tapToHide = UITapGestureRecognizer(target: self, action: #selector(toggleFullscreen))
        tapToHide.delegate = self
        tapToHide.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapToHide)

        // tap gesture on background to show reward if no button
        let tapWithoutButton = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        tapWithoutButton.delegate = self
        tapWithoutButton.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapWithoutButton)

        tapWithoutButton.require(toFail: tapToHide)
    }

    @objc
    func backgroundTap(_ sender: Any) {
        if buttonView.image == nil {
            RewardSample.current.sample(target: self, sender: view)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // set background image
        self.backgroundView.isHidden = true
        self.backgroundView.image = nil
        self.movieLayer.isHidden = true
        self.movieLayer.player?.replaceCurrentItem(with: nil)
        if let backgroundImage = RewardSample.current.backgroundImage {
            self.backgroundView.image = backgroundImage
            self.backgroundView.isHidden = false
        }
        if let backgroundMovie = RewardSample.current.backgroundMovie {
            self.movieLayer.player?.replaceCurrentItem(with: backgroundMovie)
            self.movieLayer.isHidden = false
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
        guard let rewardForm = RewardForm.instantiate(for: RewardSample.current.rewardPrimitive) else { return }
        rewardForm.reward = RewardSample.current
        rewardForm.form = rewardForm.generateForm()
        self.navigationController?.pushViewController(rewardForm, animated: true)
    }

//    func setMovie(_ url: URL) {
//        movieLayer.player?.replaceCurrentItem(with: AVPlayerItem(url: url))
//        UserDefaults.standard.movieURL = url
//    }
//
//    func playMovie() {
//        movieLayer.player?.seek(to: CMTime.zero)
//        movieLayer.player?.play()
//    }

}

extension SampleViewController: MainMenuDelegate {

    func shouldEraseButton() {
        setButton(image: nil)
    }

    func shouldResetButton() {
        self.buttonView.image = RewardSample.current.buttonView.image
        self.buttonView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        self.buttonView.adjustHeight()
        buttonView.center = view.center
        RewardSample.current.buttonView = self.buttonView
        DispatchQueue.global().async {
            RewardSample.current.save()
        }
    }

    func setButton(image: UIImage?) {
        let oldCenter = self.buttonView.center
        self.buttonView.image = image
        self.buttonView.center = oldCenter
        self.buttonView.adjustHeight()
        RewardSample.current.buttonView = self.buttonView
        DispatchQueue.global().async {
            RewardSample.current.save()
        }
    }

    func setBackground(url: URL?) {
        print("Current url:\(url.debugDescription)")
        RewardSample.current.backgroundURL = url
        print("Mangled url:\(RewardSample.current.backgroundURL.debugDescription)")

        self.backgroundView.image = RewardSample.current.backgroundImage
        backgroundView.isHidden = backgroundView.image != nil
        self.movieLayer.player?.replaceCurrentItem(with: RewardSample.current.backgroundMovie)
        self.backgroundView.backgroundColor = .black
        DispatchQueue.global().async {
            RewardSample.current.save()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }

    func didImport(mediaInfo: [String: Any], type: ImportedImageType) {
        DispatchQueue.main.async {
            switch type {
            case .button:
                guard let image = mediaInfo[UIImagePickerControllerOriginalImage] as? UIImage else {
                    print("Error: No image found")
                    return
                }
                self.setButton(image: image)

            case .background:
                guard let url = mediaInfo["UIImagePickerControllerImageURL"] as? URL else {
                    print("Error: No image or movie found")
                    return
                }
                self.setBackground(url: url)
            }

        }
    }
}

extension SampleViewController: UIGestureRecognizerDelegate {

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
    func pan(_ gesture: UIPanGestureRecognizer) {
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
