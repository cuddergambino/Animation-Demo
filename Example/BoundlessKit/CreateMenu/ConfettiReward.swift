//
//  ConfettiReward.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms
@testable import BoundlessKit

class ConfettiReward : RewardSettingsFormViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        rewardSettings = RewardSample.load(rewardID: "ConfettiSample") ?? RewardSample.defaultSample(for: "ConfettiSample")!
        
        let form = FormDescriptor(title: "Confetti Settings")
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Duration.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Delay.formRow(rewardSettings.settings))
        saveSection.rows.append(RewardParamKey.Content.formRow(rewardSettings.settings))
        
        let hapticFeedbackRow: FormRowDescriptor = {
            let key = RewardParamKey.HapticFeedback.rawValue
            let value = rewardSettings.settings[key] as AnyObject
            let row = FormRowDescriptor(tag: key, type: .booleanSwitch, title: "Vibrate")
            row.value = value
            return row
        }()
        generalSection.rows.append(hapticFeedbackRow)
        
//        let systemSoundRow: FormRowDescriptor = {
//            let key = RewardParamKey.SystemSound.rawValue
//            let value = params[key] as AnyObject
//            let row = FormRowDescriptor(tag: "Sound Option", type: .number, title: key)
//        row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
//            return row
//        }()
//        generalSection.rows.append(systemSoundRow)
        
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
        
        let viewMarginXRow: FormRowDescriptor = {
            let key = RewardParamKey.ViewMarginX.rawValue
            let value = rewardSettings.settings[key] as AnyObject
            let row = FormRowDescriptor(tag: key, type: .numbersAndPunctuation, title: "Margin X (0.5 = 50%, 5 = 5pts)")
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
        }()
        generalSection.rows.append(viewMarginXRow)
        
        let viewMarginYRow: FormRowDescriptor = {
            let key = RewardParamKey.ViewMarginY.rawValue
            let value = rewardSettings.settings[key] as AnyObject
            let row = FormRowDescriptor(tag: key, type: .numbersAndPunctuation, title: "Margin Y (0.5 = 50%, 5 = 5pts")
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
        }()
        generalSection.rows.append(viewMarginYRow)
        
        
        
        form.sections = [saveSection, generalSection]
        self.form = form
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell
    }
}
