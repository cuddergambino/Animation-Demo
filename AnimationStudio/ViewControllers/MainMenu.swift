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

protocol MainMenuDelegate: class {
    func didImport(imageView: UIImageView, type: ImportedImageType)
    func toggleFullscreen()
    func shouldResetButton()
    func shouldEraseButton()
}

enum ImportedImageType: String {
    case button, background

    var key: String { return "imageFor\(rawValue.capitalized)"}
}

class MainMenu: UITableViewController {

    static func instantiate() -> MainMenu? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenu") as? MainMenu
    }

    weak var mainMenuDelegate: MainMenuDelegate?

    var importedImageType: ImportedImageType = .button

    override func viewWillAppear(_ animated: Bool) {
        tableView.setContentOffset(.zero, animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                guard let reward = RewardForm.instantiate(for: RewardSample.current.rewardPrimitive) else { return }
                reward.reward = RewardSample.current
                reward.form = reward.generateForm()
                self.navigationController?.pushViewController(reward, animated: true)

            case 2:
                self.requestButtonImage()

            case 3:
                self.requestFullscreenImage()

            case 4:
                self.mainMenuDelegate?.toggleFullscreen()

            default:
                break
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        picker.dismiss(animated: true, completion: nil)
        mainMenuDelegate?.didImport(imageView: imageView, type: importedImageType)
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
        confirmPhotosPermission {
        self.importedImageType = .button
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view

            optionMenu.addAction(
                UIAlertAction(title: "Photo Library", style: .default) { (_: UIAlertAction!) in
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
            })
            optionMenu.addAction(
                UIAlertAction(title: "Reset button", style: .default) { (_: UIAlertAction!) in
                    self.mainMenuDelegate?.shouldResetButton()
            })
            optionMenu.addAction(
                UIAlertAction(title: "Erase button", style: .default) { (_: UIAlertAction!) in
                    self.mainMenuDelegate?.shouldEraseButton()
            })
            optionMenu.addAction(
                UIAlertAction(title: "Cancel", style: .cancel) { (_: UIAlertAction!) in
            })

            self.present(optionMenu, animated: true, completion: nil)
        }
    }

    func requestFullscreenImage() {
        confirmPhotosPermission {
            self.importedImageType = .background
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}
