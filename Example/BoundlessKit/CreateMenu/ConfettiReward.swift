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

class ConfettiReward : FormViewController {
    
    var selectedRow: UITableViewCell?
    
    var sampleView = UIView()
    var rewardSettings = RewardSample.defaultSample(for: "ConfettiSample")!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        sampleView.backgroundColor = .blue
//        sampleView.frame = CGRect.init(x: tableView.frame.minX, y: tableView.frame.minY, width: tableView.frame.width, height: tableView.frame.height / 2)
//
//        view.addSubview(sampleView)
//
//        tableView.frame = CGRect.init(x: tableView.frame.minX, y: tableView.frame.minY + tableView.frame.height / 2, width: tableView.frame.width, height: tableView.frame.height / 2)
        
        tableView.headerView(forSection: 100)
        tableView.tableHeaderView?.backgroundColor = .blue
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let form = FormDescriptor(title: "Confetti Settings")
        
        let saveSection = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
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
