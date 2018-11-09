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

    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }

    var sampleStruct: SampleStruct?

    @IBOutlet weak var buttonView: UIImageView!
    var backgroundView: UIImageView!
    var movieLayer: AVPlayerLayer = AVPlayerLayer(player: AVPlayer())

    var mainMenu: MainMenu!
    var importedImageType: ImportedImageType = .button

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
        backgroundView = UIImageView(frame: view.bounds)
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
            sampleStruct?.sample(target: self, sender: view)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sampleStruct = SampleStruct.allSamples.last

        // set background image or movie
        backgroundView.image = sampleStruct?.backgroundImage
        backgroundView.isHidden = backgroundView.image == nil

        movieLayer.player?.replaceCurrentItem(with: nil)
        movieLayer.isHidden = movieLayer.player?.currentItem == nil

        // set button image & frame
        buttonView.image = sampleStruct?.buttonView?.image
        buttonView.frame = sampleStruct?.buttonView?.frame ?? buttonView.frame
        buttonView.isHidden = buttonView.image == nil
        print("Background image:\(backgroundView.image)")
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

        navigationController?.navigationBar.topItem?.title = sampleStruct?.rewardID
    }

    func didSelectHideMenu() {
        toggleFullscreen()
    }

    @objc @IBAction
    func toggleFullscreen() {
        let showFullscreen = !mainMenu.view.isHidden
        mainMenu.view.isHidden = showFullscreen
        navigationController?.setNavigationBarHidden(showFullscreen, animated: true)
    }

    @IBAction
    func editReward() {
        if let sampleStruct = sampleStruct {
            guard let rewardForm = RewardForm.instantiate(for: sampleStruct.rewardPrimitive) else { return }
            rewardForm.reward = sampleStruct
            rewardForm.form = rewardForm.generateForm()
            self.navigationController?.pushViewController(rewardForm, animated: true)
        }
    }

//    func setMovie(_ url: URL) {
//        movieLayer.player?.replaceCurrentItem(with: AVPlayerItem(url: url))
//    }
//
//    func playMovie() {
//        movieLayer.player?.seek(to: CMTime.zero)
//        movieLayer.player?.play()
//    }

}

extension SampleViewController: MainMenuDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func didSelectEdit() {
        editReward()
    }

    func didSelectSavedSamples(_ viewController: SavedSamplesViewController) {

    }

    func didSelectChangeButton() {
        importedImageType = .button
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view

        optionMenu.addAction(
            UIAlertAction(title: "Photo Library", style: .default) { (_: UIAlertAction!) in
                self.confirmPhotosPermission {
                    DispatchQueue.main.async {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        imagePicker.sourceType = .savedPhotosAlbum
                        imagePicker.allowsEditing = false
                        self.present(imagePicker, animated: true, completion: nil)
                    }
                }
        })
        optionMenu.addAction(
            UIAlertAction(title: "Reset button", style: .default) { (_: UIAlertAction!) in
                self.shouldResetButton()
        })
        optionMenu.addAction(
            UIAlertAction(title: "Erase button", style: .default) { (_: UIAlertAction!) in
                self.shouldEraseButton()
        })
        optionMenu.addAction(
            UIAlertAction(title: "Cancel", style: .cancel) { (_: UIAlertAction!) in
        })

        self.present(optionMenu, animated: true, completion: nil)
    }

    func shouldEraseButton() {
        setButton(image: nil)
    }

    func shouldResetButton() {
        self.buttonView.image = sampleStruct?.buttonView?.image
        print("Is hidden:\(buttonView.isHidden)")
        self.buttonView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        buttonView.center = view.center
        sampleStruct?.buttonView = self.buttonView
        sampleStruct?.save()
    }

    func setButton(image: UIImage?) {
        self.buttonView.image = image
        self.buttonView.center = backgroundView.center
        self.buttonView.adjustHeight()
        sampleStruct?.buttonView = self.buttonView
        sampleStruct?.save()
    }

    func didSelectChangeBackground() {
        confirmPhotosPermission {
            DispatchQueue.main.async {
                self.importedImageType = .background
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.mediaTypes = [kUTTypeMovie, kUTTypeImage] as [String]
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }

    func setBackground(url: URL?) {
        print("Current url:\(url.debugDescription)")
        sampleStruct?.backgroundURL = url

        self.backgroundView.image = sampleStruct?.backgroundImage
        backgroundView.isHidden = backgroundView.image == nil
        self.movieLayer.player?.replaceCurrentItem(with: sampleStruct?.backgroundMovie)
        movieLayer.isHidden = movieLayer.player?.currentItem == nil
        self.backgroundView.backgroundColor = .black
        self.sampleStruct?.save()
        print("Struct Background image:\(sampleStruct?.backgroundImage)")
    }

    @objc
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true) {
            switch self.importedImageType {
            case .button:
                guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
                    print("Error: No image found")
                    return
                }
                self.setButton(image: image)

            case .background:
                guard let url = info["UIImagePickerControllerReferenceURL"] as? URL else {
                    print("Error: No image or movie found")
                    return
                }
                self.setBackground(url: url)
            }
        }
    }

    func didSelectCreateSample(_ viewController: RewardForm) {
        if let url = sampleStruct?.backgroundURL {
            viewController.reward.backgroundURL = url
        }
        if let view = sampleStruct?.buttonView {
            viewController.reward.buttonView = view
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
        sampleStruct?.sample(target: self, sender: buttonView)

        sampleStruct?.settings["buttonViewFrame"] = NSStringFromCGRect(buttonView.frame)
        sampleStruct?.settings["buttonViewTransform"] = NSStringFromCGAffineTransform(buttonView.transform)
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
            sampleStruct?.buttonView = buttonView
            DispatchQueue.global().async {
                self.sampleStruct?.save()
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
            sampleStruct?.buttonView = self.buttonView
            DispatchQueue.global().async {
                self.sampleStruct?.save()
            }

        default: break
        }
    }

}
