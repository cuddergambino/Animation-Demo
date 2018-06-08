//
//  RewardParam.swift
//  AnimationStudio
//
//  Created by Akash Desai on 6/8/18.
//  Copyright © 2018 Boundless Mind. All rights reserved.
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
    Dark,
    FontSize
    
    var title: String {
        switch self {
        case .RewardID: return "Reward Name"
        case .primitive: return "Type"
        case .ViewOption: return "Animated View"
        case .HapticFeedback: return "Vibrate"
        case .SystemSound: return "Sound Option (1000-1036)"
        case .Bursts: return "Duration"
        case .Quantity: return "Count/second"
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
        case .Spin: return "Spin(°/s)"
        case .Amount: return "Amount (0-12)"
        case .FontSize: return "Font Size"
        default: return self.rawValue
        }
    }
    
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
            row.configuration.stepper.continuous = true
            row.value = value
            if let colorValue = dict[rawValue.replacingOccurrences(of: "Alpha", with: "Color")] as? String,
                let color = UIColor.from(rgb: colorValue, alpha: CGFloat(row.value as? Float ?? 1)) {
                row.configuration.cell.appearance = ["sliderView.tintColor": color]
            }
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
            
        case .HapticFeedback, .Dark:
            let row = FormRowDescriptor(tag: rawValue, type: .booleanSwitch, title: title)
            row.value = value
            return row
            
        case .SystemSound:
            let row = FormRowDescriptor(tag: rawValue, type: .number, title: title)
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            row.value = value
            return row
            
        case .Amount:
            let row = FormRowDescriptor(tag: rawValue, type: .stepper, title: title)
            row.configuration.stepper.maximumValue = 12
            row.configuration.stepper.minimumValue = 1
            row.configuration.stepper.steps = 1
            row.value = value
            return row
            
        case .Size:
            let row = FormRowDescriptor(tag: rawValue, type: .stepper, title: title)
            row.configuration.stepper.maximumValue = 24
            row.configuration.stepper.minimumValue = 1
            row.configuration.stepper.steps = 1
            row.value = value
            return row
            
        case .FontSize:
            let row = FormRowDescriptor(tag: rawValue, type: .slider, title: title)
            row.configuration.cell.cellClass = FormLabeledSliderCell.self
            row.configuration.stepper.maximumValue = 96
            row.configuration.stepper.minimumValue = 1
            row.configuration.stepper.steps = 1
            row.configuration.stepper.continuous = true
            row.value = value
            return row
        }
    }
}
