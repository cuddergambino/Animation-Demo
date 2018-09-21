//
//  PresetSamplesViewController.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms

class PresetSamplesViewController: FormViewController {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.form = generateForm()
    }

    func generateForm() -> FormDescriptor {
        let form = FormDescriptor(title: "Saved Reward Settings")

        let listSection = FormSectionDescriptor(headerTitle: "Names", footerTitle: nil)
        for name in Array(RewardSample.samples.keys).sorted(by: <) {
            let row = FormRowDescriptor(tag: RewardParamKey.RewardID.rawValue, type: .button, title: name)
            row.configuration.button.didSelectClosure = { _ in
                RewardSample.current = RewardSample.samples[name] ?? RewardSample.current
                self.navigationController?.popViewController(animated: true)
            }
            listSection.rows.append(row)
        }

        let resetSection = FormSectionDescriptor(headerTitle: "Reset", footerTitle: nil)
        let row: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: "Reset", type: .button, title: "Erase & Reset Rewards")
            row.configuration.button.didSelectClosure = { _ in

                let resetMenu: UIAlertController = {
                    let options = UIAlertController(title: "Erase Rewards?",
                                                    message: "Resets to factory default rewards",
                                                    preferredStyle: .actionSheet)
                    options.popoverPresentationController?.sourceView = self.view

                    let erase = UIAlertAction(title: "Erase & Reset", style: .destructive) { _ in
                        for sample in RewardSample.samples.values {
                            RewardSample.delete(rewardID: sample.rewardID)
                        }
                        for preset in RewardSample.presets.reversed() {
                            preset.save()
                            RewardSample.samples[preset.rewardID] = preset
                            RewardSample.current = preset
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
            RewardSample.delete(rewardID: name)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}
