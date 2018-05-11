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

// not instantiated
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
                    self.view.endEditing(true)
                    self.rewardSettings.setForm(form: self.form)
                    self.rewardSettings.save()
                    RewardSample.samples[self.rewardSettings.rewardID] = self.rewardSettings
                    RewardSample.current = self.rewardSettings
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
        let section = FormSectionDescriptor(headerTitle: "Sound", footerTitle: nil)
        section.rows.append(RewardParamKey.HapticFeedback.formRow(rewardSettings.settings))
        section.rows.append(RewardParamKey.SystemSound.formRow(rewardSettings.settings))
        return section
    }
    
    var basicViewSection: FormSectionDescriptor {
        let section = FormSectionDescriptor(headerTitle: "Animated View", footerTitle: nil)
        section.rows.append(RewardParamKey.ViewOption.formRow(rewardSettings.settings))
        return section
    }
    
    var preciseViewSection: FormSectionDescriptor {
        let section = FormSectionDescriptor(headerTitle: "Animated View", footerTitle: nil)
        section.rows.append(RewardParamKey.ViewOption.formRow(rewardSettings.settings))
        section.rows.append(RewardParamKey.ViewMarginX.formRow(rewardSettings.settings))
        section.rows.append(RewardParamKey.ViewMarginY.formRow(rewardSettings.settings))
        return saveSection
    }
}

extension RewardParamKey {
    func formRow(_ dict: [String: Any]) -> FormRowDescriptor {
        let value = dict[rawValue] as AnyObject
        switch self {
            
        case .RewardID:
            let row = FormRowDescriptor(tag: rawValue, type: .name, title: title)
            row.configuration.cell.appearance = ["textField.placeholder" : value, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
            
        case .primitive:
            let row = FormRowDescriptor(tag: rawValue, type: .label, title: title)
            row.configuration.cell.appearance = ["textField.placeholder" : value, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
            
        case .Content:
            let row = FormRowDescriptor(tag: rawValue, type: .name, title: title)
            row.configuration.cell.appearance = ["textField.placeholder" : value as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
            
        case .Duration, .Delay, .FadeOut,
             .Translation, .Velocity, .AccelX, .AccelY, .Damping,
             .VibrateDuration, .VibrateCount, .VibrateTranslation, .VibrateSpeed,
             .Scale, .ScaleSpeed, .ScaleRange, .ScaleDuration, .ScaleCount, .ScaleVelocity, .ScaleDamping,
             .Spin, .EmissionRange, .EmissionAngle, .LifetimeRange, .Lifetime,
             .ViewMarginX, .ViewMarginY,
             .Alpha:
            let row = FormRowDescriptor(tag: rawValue, type: .numbersAndPunctuation, title: title)
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
            
        case .Count, .Quantity, .Bursts:
            let row = FormRowDescriptor(tag: rawValue, type: .number, title: title)
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
            
        case .ViewOption:
            let row = FormRowDescriptor(tag: rawValue, type: .picker, title: title)
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
            
        case .HapticFeedback, .Light:
            let row = FormRowDescriptor(tag: rawValue, type: .booleanSwitch, title: title)
            row.value = value
            return row
            
        case .SystemSound:
            let row = FormRowDescriptor(tag: rawValue, type: .number, title: title)
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
        }
    }
}
