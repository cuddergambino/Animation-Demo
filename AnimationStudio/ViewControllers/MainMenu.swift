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
import MobileCoreServices

protocol MainMenuDelegate: class {
    func didSelectEdit()
    func didSelectSavedSamples(_ viewController: SavedSamplesViewController)
    func didSelectChangeButton()
    func didSelectChangeBackground()
    func didSelectHideMenu()
    func didSelectCreateSample(_ viewController: RewardForm)
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

    override func viewWillAppear(_ animated: Bool) {
        tableView.setContentOffset(.zero, animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                mainMenuDelegate?.didSelectEdit()

            case 2:
                mainMenuDelegate?.didSelectChangeButton()

            case 3:
                mainMenuDelegate?.didSelectChangeBackground()

            case 4:
                mainMenuDelegate?.didSelectHideMenu()

            default:
                break
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, sender) {
        case let ("createSample", sender as RewardForm):
            mainMenuDelegate?.didSelectCreateSample(sender)

        case let ("savedSamples", sender as SavedSamplesViewController):
            mainMenuDelegate?.didSelectSavedSamples(sender)

        default:
            break
        }
    }
}
