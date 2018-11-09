//
//  SavedSamplesViewController.swift
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms

class SavedSamplesViewController: FormViewController {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.form = generateForm()
    }

    func generateForm() -> FormDescriptor {
        let allSamples = SampleStruct.allSamples
        let form = FormDescriptor(title: "Saved Reward Settings")

        let listSection = FormSectionDescriptor(headerTitle: "Names", footerTitle: nil)
        for sample in allSamples.reversed() {
            let row = FormRowDescriptor(tag: RewardParamKey.RewardID.rawValue, type: .button, title: sample.rewardID)
            row.configuration.button.didSelectClosure = { _ in
                sample.save() // sets it as current sample, last being the current
                self.navigationController?.popViewController(animated: true)
            }
            listSection.rows.append(row)
        }

        let resetSection = FormSectionDescriptor(headerTitle: "Reset", footerTitle: nil)
        let row: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: "Reset", type: .button, title: "Erase All Samples")
            row.configuration.button.didSelectClosure = { _ in

                let resetMenu: UIAlertController = {
                    let options = UIAlertController(title: "Erase samples?",
                                                    message: "All of your samples will be removed",
                                                    preferredStyle: .actionSheet)
                    options.popoverPresentationController?.sourceView = self.view

                    let erase = UIAlertAction(title: "Erase", style: .destructive) { _ in
                        for sample in allSamples {
                            SampleStruct.delete(rewardID: sample.rewardID)
                        }
                        self.form = self.generateForm()
                        self.tableView.reloadData()
                    }
                    options.addAction(erase)

                    let cancel = UIAlertAction(title: "Cancel", style: .cancel) {_ in}
                    options.addAction(cancel)

                    return options
                }()

                self.present(resetMenu, animated: true, completion: nil)
            }
            return row
        }()
        resetSection.rows.append(row)
        form.sections = [listSection, resetSection]
        return form
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = self.form.sections[indexPath.section].rows.remove(at: indexPath.row)
            let name = row.title!
            SampleStruct.delete(rewardID: name)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}
