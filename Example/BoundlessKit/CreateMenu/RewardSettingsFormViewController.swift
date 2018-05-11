//
//  RewardSettingsFormViewController.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
@testable import BoundlessKit
import SwiftForms

class RewardSettingsFormViewController : FormViewController {
    
    var rewardSettings: RewardSample!
    var selectedRow: UITableViewCell?
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell
    }
    
    var saveSection: FormSectionDescriptor {
        let saveSection = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        saveSection.rows.append(RewardParamKey.RewardID.formRow(rewardSettings.settings))
        let commitRow: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: "button", type: .button, title: "Save")
            row.configuration.button.didSelectClosure = { _ in
                DispatchQueue.main.async {
                    self.rewardSettings.setForm(form: self.form)
                    self.rewardSettings.save()
                }
            }
            return row
        }()
        saveSection.rows.append(commitRow)
        let tryRow: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: "button", type: .button, title: "Try")
            row.configuration.button.didSelectClosure = { _ in
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    self.rewardSettings.setForm(form: self.form)
                    self.rewardSettings.sample(target: UIWindow.topWindow!, sender: self.selectedRow)
                }
            }
            return row
        }()
        saveSection.rows.append(tryRow)
        return saveSection
    }
}
