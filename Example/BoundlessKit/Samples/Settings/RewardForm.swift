//
//  RewardForm.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SwiftForms

enum RewardParamKey : String {
    case
    RewardID,
    primitive,
    Duration,
    Delay,
    Count,
    Scale,
    Translation,
    Quantity,
    Velocity,
    Damping,
    AccelX,
    AccelY,
    ViewOption,
    ViewMarginX,
    ViewMarginY,
    HapticFeedback,
    SystemSound,
    Content,
    VibrateDuration,
    VibrateCount,
    VibrateTranslation,
    VibrateSpeed,
    ScaleSpeed,
    ScaleRange,
    ScaleDuration,
    ScaleCount,
    ScaleVelocity,
    ScaleDamping,
    Bursts,
    FadeOut,
    Spin,
    EmissionRange,
    EmissionAngle,
    LifetimeRange,
    Lifetime,
    Color,
    Alpha,
    Color1,
    Alpha1,
    Color2,
    Alpha2,
    Color3,
    Alpha3,
    Amount,
    Size,
    Light
    
    var title: String {
        switch self {
        case .RewardID: return "Reward Name"
        case .primitive: return "Type"
        case .ViewOption: return "Animate View"
        case .HapticFeedback: return "Vibrate"
        case .SystemSound: return "Sound Option (1000-1036)"
        case .Quantity: return "Count"
        case .ViewMarginX: return "Margin X (0.5 = 50%, 5 = 5pts)"
        case .ViewMarginY: return "Margin Y (0.5 = 50%, 5 = 5pts)"
        case .VibrateDuration: return "Duration"
        case .VibrateCount: return "Count"
        case .VibrateTranslation: return "Translation"
        case .VibrateSpeed: return "Speed"
        case .ScaleDuration: return "Duration"
        case .ScaleCount: return "Count"
        case .ScaleVelocity: return "Velocity"
        case .ScaleDamping: return "Damping"
        case .EmissionAngle: return "Shooting Angle°"
        case .EmissionRange: return "Shooting Range°"
        case .Spin: return "Spin°"
        case .Amount: return "Amount (0-12)"
        default: return self.rawValue
        }
    }
}

// should subclass this
class RewardForm : FormViewController {
    
    var rewardSettings: RewardSample!
    var selectedRow: UITableViewCell?
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func generateForm() -> FormDescriptor {
        return FormDescriptor()
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
                    self.navigationController?.popViewController(animated: true)
                }
            }
            return row
        }()
        section.rows.append(commitRow)
        
        let tryRow: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: "button", type: .button, title: "Try Now")
            row.configuration.cell.appearance = ["backgroundColor" : UIColor.lightGray as AnyObject]
            row.configuration.button.didSelectClosure = { _ in
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    self.rewardSettings.setForm(form: self.form)
//                    self.form = self.generateForm()
                    self.rewardSettings.sample(target: self.view, sender: self.selectedRow)
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

struct ColorAndAlphaCell {
    
}

extension RewardParamKey {
    func formRow(_ dict: [String: Any]) -> FormRowDescriptor {
        let value = dict[rawValue] as AnyObject
        switch self {
            
        case .Color, .Color1, .Color2, .Color3:
            let row = FormRowDescriptor(tag: rawValue, type: .unknown, title: title)
            row.configuration.cell.cellClass = FormColorPickerCell.self
            row.configuration.cell.appearance = ["valueLabel.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            row.value = value
            return row
            
        case .Alpha, .Alpha1, .Alpha2, .Alpha3:
            let row = FormRowDescriptor(tag: rawValue, type: .slider, title: title)
            row.configuration.cell.cellClass = FormLabeledSliderCell.self
            row.configuration.stepper.maximumValue = 1
            row.configuration.stepper.minimumValue = 0
            row.configuration.stepper.steps = 0.05
            //            row.configuration.stepper.continuous = true
            var color = UIColor.white
            let counterpart = RewardParamKey.init(rawValue: rawValue.replacingOccurrences(of: "Alpha", with: "Color"))
            if let counterpart = counterpart,
                let colorValue = dict[counterpart.rawValue] as? String,
                let selectedColor = UIColor.from(rgb: colorValue) {
                color = selectedColor
            }
            row.configuration.cell.appearance = ["sliderView.tintColor": color]
            row.value = value
            return row
            
        case .RewardID:
            print("GOt rewardID: \(value)")
            let row = FormRowDescriptor(tag: rawValue, type: .name, title: title)
            row.configuration.cell.appearance = ["textField.placeholder" : value, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            row.value = value
            return row
            
        case .primitive:
            let row = FormRowDescriptor(tag: rawValue, type: .button, title: title)
            row.value = value
            return row
            
        case .Content:
            let row = FormRowDescriptor(tag: rawValue, type: .name, title: title)
            row.configuration.cell.appearance = ["textField.placeholder" : value as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            row.value = value
            return row
            
        case .Duration, .Delay, .FadeOut,
             .Translation, .Velocity, .AccelX, .AccelY, .Damping,
             .VibrateDuration, .VibrateCount, .VibrateTranslation, .VibrateSpeed,
             .Scale, .ScaleSpeed, .ScaleRange, .ScaleDuration, .ScaleCount, .ScaleVelocity, .ScaleDamping,
             .Spin, .EmissionRange, .EmissionAngle, .LifetimeRange, .Lifetime,
             .ViewMarginX, .ViewMarginY:
            let row = FormRowDescriptor(tag: rawValue, type: .numbersAndPunctuation, title: title)
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            row.value = value
            return row
            
        case .Count, .Quantity, .Bursts:
            let row = FormRowDescriptor(tag: rawValue, type: .number, title: title)
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            row.value = value
            return row
            
        case .ViewOption:
            let row = FormRowDescriptor(tag: rawValue, type: .picker, title: title)
            row.configuration.cell.showsInputToolbar = true
            row.configuration.selection.options = RewardParamViewOption.cases.map({$0.rawValue as AnyObject})
            row.configuration.selection.optionTitleClosure = { value in
                guard let option = value as? String,
                    let viewOption = RewardParamViewOption(rawValue: option) else {
                        return ""
                }
                return viewOption.title
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
            row.value = value
            return row
            
        case .Amount, .Size:
            let row = FormRowDescriptor(tag: rawValue, type: .stepper, title: title)
            row.configuration.stepper.maximumValue = 12
            row.configuration.stepper.minimumValue = 1
            row.configuration.stepper.steps = 1
            row.value = value
            return row
        }
    }
}
