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
        
        let form = FormDescriptor(title: "Rotate Settings")
        
        let saveSection = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        let rewardIDRow: FormRowDescriptor = {
            let key = RewardParamKey.RewardID.rawValue
            let value = rewardSettings.settings[key] as AnyObject
            let row = FormRowDescriptor(tag: key, type: .picker, title: "Type")
            row.configuration.cell.showsInputToolbar = true
            row.configuration.selection.options = RewardSample.samples.values.filter({$0.rewardPrimitive == rewardSettings.rewardPrimitive}).map({$0.rewardID}) as [AnyObject]
            row.configuration.selection.optionTitleClosure = { value in
                return value as? String ?? "unknown"
            }
            row.configuration.selection.allowsMultipleSelection = true
            row.configuration.selection.didSelectClosure = { primitive in
                print("Selected primitive:\(primitive)")
                DispatchQueue.main.async() {
                    
                    //                        if primitive != RewardSample.current.codelessReinforcement.primitive,
                    //                            let newCurrent = RewardSample.defaultSample(for: primitive + "Sample") {
                    //                            RewardSample.current = newCurrent
                    //                            vc.loadForm()
                    //                        }
                }
            }
            row.value = value
            return row
        }()
        saveSection.rows.append(rewardIDRow)
        
        let commitRow: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: "button", type: .button, title: "Save")
            row.configuration.button.didSelectClosure = { _ in
                DispatchQueue.main.async {
                    self.rewardSettings.setForm(form: self.form)
                    self.rewardSettings.save()
                    self.rewardSettings.sample(target: UIWindow.topWindow!, sender: self.selectedRow)
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
            let row = FormRowDescriptor(tag: "Vibrate", type: .booleanSwitch, title: key)
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
        
        form.sections = [saveSection, generalSection]
        self.form = form
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell
    }
}
