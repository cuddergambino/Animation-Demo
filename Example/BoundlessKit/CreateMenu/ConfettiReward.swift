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
    
    var sampleView = UIView()
    var rewardSettings = RewardSample.defaultSample(for: "ConfettiSample")!
    var params: [String: Any] {
        return rewardSettings.codelessReinforcement.parameters
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        sampleView.backgroundColor = .blue
//        sampleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 100)
//
//        view.addSubview(sampleView)
//
//        tableView.frame = tableView.frame.applying(CGAffineTransform.init(translationX: 0, y: sampleView.frame.height))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let form = FormDescriptor(title: "Confetti Settings")
        
        let saveButton = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        let commitRow = FormRowDescriptor(tag: "button", type: .button, title: "Save")
        commitRow.configuration.button.didSelectClosure = { row in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        saveButton.rows.append(commitRow)
        
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        
        let durationRow: FormRowDescriptor = {
            let key = RewardParamKey.Duration.rawValue
            let value = params[key] as AnyObject
            let row = FormRowDescriptor(tag: key, type: .numbersAndPunctuation, title: key)
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
        }()
        generalSection.rows.append(durationRow)
        
        let delayRow: FormRowDescriptor = {
            let key = RewardParamKey.Delay.rawValue
            let value = params[key] as AnyObject
            let row = FormRowDescriptor(tag: key, type: .numbersAndPunctuation, title: key)
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
        }()
        generalSection.rows.append(delayRow)
        
        let hapticFeedbackRow: FormRowDescriptor = {
            let key = RewardParamKey.HapticFeedback.rawValue
            let value = params[key] as AnyObject
            let row = FormRowDescriptor(tag: "Vibrate", type: .booleanSwitch, title: key)
//            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
        }()
        generalSection.rows.append(hapticFeedbackRow)
        
        let systemSoundRow: FormRowDescriptor = {
            let key = RewardParamKey.SystemSound.rawValue
            let value = params[key] as AnyObject
            let row = FormRowDescriptor(tag: "Sound Option", type: .number, title: key)
            return row
        }()
        generalSection.rows.append(systemSoundRow)
        
        let viewoptionRow: FormRowDescriptor = {
            let key = RewardParamKey.ViewOption.rawValue
            let value = params[key] as AnyObject
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
            let value = params[key] as AnyObject
            let row = FormRowDescriptor(tag: key, type: .numbersAndPunctuation, title: "Margin X (0.5 = 50%, 5 = 5pts)")
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
        }()
        generalSection.rows.append(viewMarginXRow)
        
        let viewMarginYRow: FormRowDescriptor = {
            let key = RewardParamKey.ViewMarginY.rawValue
            let value = params[key] as AnyObject
            let row = FormRowDescriptor(tag: key, type: .numbersAndPunctuation, title: "Margin Y (0.5 = 50%, 5 = 5pts")
            row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
        }()
        generalSection.rows.append(viewMarginYRow)
        
        
        
        form.sections = [saveButton, generalSection]
        self.form = form
    }
    
    
}
