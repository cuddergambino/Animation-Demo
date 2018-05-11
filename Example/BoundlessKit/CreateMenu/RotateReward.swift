//
//  RotateReward.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import SwiftForms
@testable import BoundlessKit

class RotateReward : FormViewController {
    
    
    
    var selectedRow: UITableViewCell?
    
    var rewardSettings = RewardSample.defaultSample(for: "RotateSample")!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        rewardSettings = RewardSample.load(rewardID: "RotateSample") ?? rewardSettings
        
        let form = FormDescriptor(title: "Rotate Settings")
        
        
        
        let saveSection = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        let rewardIDRow: FormRowDescriptor = {
            let key = RewardParamKey.RewardID.rawValue
            let value = rewardSettings.settings[key] as AnyObject
            let row = FormRowDescriptor(tag: "name", type: .name, title: "Reward Name")
            row.configuration.cell.appearance = ["textField.placeholder" : value as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
        }()
        saveSection.rows.append(rewardIDRow)
        
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
                    self.rewardSettings.setForm(form: self.form)
                    self.rewardSettings.sample(target: UIWindow.topWindow!, sender: self.selectedRow)
                }
            }
            return row
        }()
        saveSection.rows.append(tryRow)
        
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        
        let durationRow: FormRowDescriptor = {
            let key = RewardParamKey.Duration.rawValue
            let value = rewardSettings.settings[key] as AnyObject
            let row = FormRowDescriptor(tag: key, type: .numbersAndPunctuation, title: key)
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
        }()
        generalSection.rows.append(durationRow)
        
        let delayRow: FormRowDescriptor = {
            let key = RewardParamKey.Delay.rawValue
            let value = rewardSettings.settings[key] as AnyObject
            let row = FormRowDescriptor(tag: key, type: .numbersAndPunctuation, title: key)
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
        }()
        generalSection.rows.append(delayRow)
        
        let countRow: FormRowDescriptor = {
            let key = RewardParamKey.Count.rawValue
            let value = rewardSettings.settings[key] as AnyObject
            let row = FormRowDescriptor(tag: key, type: .number, title: key)
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
        }()
        generalSection.rows.append(countRow)
        
        let hapticFeedbackRow: FormRowDescriptor = {
            let key = RewardParamKey.HapticFeedback.rawValue
            let value = rewardSettings.settings[key] as AnyObject
            let row = FormRowDescriptor(tag: key, type: .booleanSwitch, title: "Vibrate")
            row.value = value
            return row
        }()
        generalSection.rows.append(hapticFeedbackRow)
        
        let viewoptionRow: FormRowDescriptor = {
            let key = RewardParamKey.ViewOption.rawValue
            let value = rewardSettings.settings[key] as AnyObject
            let row = FormRowDescriptor(tag: key, type: .picker, title: "Animate view")
            row.configuration.cell.showsInputToolbar = true
            row.configuration.selection.options = RewardParamViewOption.cases.map({$0.rawValue as AnyObject})
            row.configuration.selection.optionTitleClosure = { tag in
                guard let tag = tag as? String,
                    let viewOption = RewardParamViewOption(rawValue: tag) else {
                        return "unknown"
                }
                return viewOption.tag
            }
            row.value = value
            return row
        }()
        generalSection.rows.append(viewoptionRow)
        
        form.sections = [saveSection, generalSection]
        self.form = form
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell
    }
}
