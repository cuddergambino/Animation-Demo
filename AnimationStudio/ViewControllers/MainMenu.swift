//
//  MainMenu.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

protocol MainMenuDelegate {
    func didImport(image: UIImage, isButton: Bool)
    func didSelectFullscreen()
}

class MainMenu : UITableViewController {
    
    var mainMenuDelegate: MainMenuDelegate?
    var uploadingButtonImage = true
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let reward = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: RewardSample.current.rewardPrimitive.rawValue + "Reward") as! RewardForm
                reward.reward = RewardSample.current
                reward.form = reward.generateForm()
                self.navigationController?.pushViewController(reward, animated: true)
                
            case 2:
                self.requestButtonImage()
                
            case 3:
                self.requestFullscreenImage()
                
            case 4:
                self.mainMenuDelegate?.didSelectFullscreen()
                
            default:
                break
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainMenu: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func requestButtonImage() {
        uploadingButtonImage = true
        let camera = CameraHandler(delegate_: self)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            camera.getCameraOn(self, canEdit: true)
        }
        let sharePhoto = UIAlertAction(title: "Photo Library (crop after selecting)", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func requestFullscreenImage() {
        uploadingButtonImage = false
        let camera = CameraHandler(delegate_: self)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            camera.getCameraOn(self, canEdit: false)
        }
        let sharePhoto = UIAlertAction(title: "Photo Library (screenshot preferred)", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: false)
        }
        let viewFullscreen = UIAlertAction(title: "View fullscreen", style: .default) { (alert : UIAlertAction!) in
            self.mainMenuDelegate?.didSelectFullscreen()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(viewFullscreen)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        mainMenuDelegate?.didImport(image: image, isButton: uploadingButtonImage)
    }
}

