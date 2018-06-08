//
//  MainMenu.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Photos

protocol MainMenuDelegate {
    func didImport(image: UIImage, type: ImportedImageType)
    func didSelectFullscreen()
    func shouldResetButton()
}

enum ImportedImageType : String {
    case button, background
    
    var key: String { return "imageFor\(rawValue.capitalized)"}
}

class MainMenu : UITableViewController {
    
    var mainMenuDelegate: MainMenuDelegate?
    
    var importedImageType: ImportedImageType = .button
    
    
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
    
    func confirmPhotosPermission(completion: @escaping () -> Void) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                guard status == .authorized else {
                    return
                }
                completion()
            })
        } else {
            completion()
        }
    }
    
    func requestButtonImage() {
        confirmPhotosPermission() {
        self.importedImageType = .button
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
            optionMenu.addAction(
                UIAlertAction(title: "Photo Library (crop after selecting)", style: .default) { (alert : UIAlertAction!) in
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
            })
            optionMenu.addAction(
                UIAlertAction(title: "Reset button", style: .default) { (alert : UIAlertAction!) in
                    self.mainMenuDelegate?.shouldResetButton()
            })
            optionMenu.addAction(
                UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
            })
            
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
    
    func requestFullscreenImage() {
        confirmPhotosPermission() {
            self.importedImageType = .background
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        mainMenuDelegate?.didImport(image: image, type: importedImageType)
    }
}

