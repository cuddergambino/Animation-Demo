//
//  RewardForm.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SwiftForms

// should subclass this
class RewardForm : FormViewController {
    
    var reward: RewardSample!
    var selectedRow: UITableViewCell?
    var fab: UIImageView!
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func generateForm() -> FormDescriptor {
        return FormDescriptor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonImage: UIImage?
        if let str = reward.settings[ImportedImageType.button.key] as? String,
            let image = UIImage.from(base64String: str) {
            buttonImage = image
        } else {
            if let str = RewardSample.current.settings[ImportedImageType.button.key] as? String,
                let image = UIImage.from(base64String: str) {
                buttonImage = image
            } else {
                buttonImage = UIImage(named: "clickMe")
            }
            reward.settings[ImportedImageType.button.key] = buttonImage?.base64String
        }
        fab = UIImageView(image: buttonImage)
        fab.contentMode = .scaleAspectFit
        
        if let str = reward.settings["buttonViewFrame"] as? String {
            fab.frame = CGRectFromString(str)
        } else {
            if let str = RewardSample.current.settings["buttonViewFrame"] as? String {
                fab.frame = CGRectFromString(str)
            } else {
                fab.frame = CGRect(x: UIScreen.main.bounds.midX - 32, y: 200, width: 100, height: 100)
            }
            reward.settings["buttonViewFrame"] = NSStringFromCGRect(fab.frame)
        }
        
        if let str = reward.settings["buttonViewTransform"] as? String {
            fab.transform = CGAffineTransformFromString(str)
        } else {
            if let str = RewardSample.current.settings["buttonViewTransform"] as? String {
                fab.transform = CGAffineTransformFromString(str)
            }
            reward.settings["buttonViewTransform"] = NSStringFromCGAffineTransform(fab.transform)
        }
        
        if reward.settings[ImportedImageType.background.key] == nil {
            reward.settings[ImportedImageType.background.key] = RewardSample.current.settings[ImportedImageType.background.key]
        }
        view.addSubview(fab)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        tapGesture.delegate = self
        panGesture.delegate = self
        fab.isUserInteractionEnabled = true
        fab.addGestureRecognizer(tapGesture)
        fab.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.bringSubview(toFront: fab)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reward.save()
        RewardSample.current = reward
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        fab.transform = CGAffineTransform.init(translationX: 0, y: scrollView.contentOffset.y)
        tableView.bringSubview(toFront: fab)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell
    }
}

extension RewardForm : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func tap(_ gesture: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.commitRewardSample()
            self.reward.sample(target: self.view, sender: self.fab)
        }
    }
    
    @objc func pan(_ gesture:UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: view)
            gesture.setTranslation(.zero, in: view)
            gesture.view?.transform = gesture.view!.transform.translatedBy(x: translation.x, y: translation.y)
        }
    }
}

extension RewardForm {
    
    func commitRewardSample() {
        reward.setForm(form: form)
    }
    
    var saveSection: FormSectionDescriptor {
        let section = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        section.rows.append(RewardParamKey.RewardID.formRow(reward.settings))
        
        let saveRow: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: "button", type: .button, title: "Save")
            row.configuration.cell.appearance = ["backgroundColor" : UIColor.from(rgb: "#007AFF") as AnyObject,
                                                 "titleLabel.textColor": UIColor.white as AnyObject
            ]
            row.configuration.button.didSelectClosure = { _ in
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    self.commitRewardSample()
                    RewardSample.samples[self.reward.rewardID] = self.reward
                    RewardSample.current = self.reward
                    self.navigationController?.popViewController(animated: true)
                }
            }
            return row
        }()
        section.rows.append(saveRow)
        
        return section
    }
    
    var soundSection: FormSectionDescriptor {
        let section = FormSectionDescriptor(headerTitle: "Sound", footerTitle: "For all sound options google 'SystemSoundID tuner88'")
        section.rows.append(RewardParamKey.HapticFeedback.formRow(reward.settings))
        section.rows.append(RewardParamKey.SystemSound.formRow(reward.settings))
        return section
    }
    
    var basicViewSection: FormSectionDescriptor {
        let section = FormSectionDescriptor(headerTitle: "Animation Location", footerTitle: nil)
        section.rows.append(RewardParamKey.ViewOption.formRow(reward.settings))
        return section
    }
    
    var preciseViewSection: FormSectionDescriptor {
        let section = FormSectionDescriptor(headerTitle: "Animation Location", footerTitle: nil)
        section.rows.append(RewardParamKey.ViewOption.formRow(reward.settings))
        section.rows.append(RewardParamKey.ViewMarginX.formRow(reward.settings))
        section.rows.append(RewardParamKey.ViewMarginY.formRow(reward.settings))
        return saveSection
    }
}

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
