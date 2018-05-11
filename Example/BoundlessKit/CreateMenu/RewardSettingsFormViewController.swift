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
        let section = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        section.rows.append(RewardParamKey.RewardID.formRow(rewardSettings.settings))
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
        section.rows.append(commitRow)
        let tryRow: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: "button", type: .button, title: "Try")
            row.configuration.cell.appearance = ["backgroundColor" : UIColor.lightGray as AnyObject]
            row.configuration.button.didSelectClosure = { _ in
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    self.rewardSettings.setForm(form: self.form)
                    self.rewardSettings.sample(target: UIWindow.topWindow!, sender: self.selectedRow)
                }
            }
            return row
        }()
        section.rows.append(tryRow)
        return section
    }
    
    var soundSection: FormSectionDescriptor {
        let section = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        section.rows.append(RewardParamKey.HapticFeedback.formRow(rewardSettings.settings))
        section.rows.append(RewardParamKey.SystemSound.formRow(rewardSettings.settings))
        return section
    }
    
    var basicViewSection: FormSectionDescriptor {
        let section = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        section.rows.append(RewardParamKey.ViewOption.formRow(rewardSettings.settings))
        return section
    }
    
    var preciseViewSection: FormSectionDescriptor {
        let section = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        section.rows.append(RewardParamKey.ViewOption.formRow(rewardSettings.settings))
        section.rows.append(RewardParamKey.ViewMarginX.formRow(rewardSettings.settings))
        section.rows.append(RewardParamKey.ViewMarginY.formRow(rewardSettings.settings))
        return saveSection
    }
}
