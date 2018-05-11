////
////  CreateRewardFormViewController.swift
////  BoundlessKit_Example
////
////  Created by Akash Desai on 5/10/18.
////  Copyright © 2018 CocoaPods. All rights reserved.
////
//
//import Foundation
//import SwiftForms
//@testable import BoundlessKit
//
//class CreateRewardFormViewController : FormViewController {
//    static var shared: FormViewController!
//    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.loadForm()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        
//        if self.isMovingFromParentViewController {
//            saveForm()
//        }
//    }
//    
//    fileprivate func saveForm() {
//        print("Message:\(self.form.formValues().description)")
//        
//        RewardSample.current.setForm(form: self.form)
//    }
//    
//    func loadForm() {
//        
//        let form = FormDescriptor(title: "Reward Params")
//        
//        let commitSection = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
//        let commitRow = FormRowDescriptor(tag: "button", type: .button, title: "Update form")
//        commitRow.configuration.button.didSelectClosure = { row in
//            vc.view.endEditing(true)
//            vc.loadForm()
//            vc.tableView.reloadData()
//        }
//        commitSection.rows.append(commitRow)
//        
//        
//        let section1 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
//        
//        for (key, value) in codelessReinforcement.parameters {
//            guard let key = RewardParamKey(rawValue: key) else { continue }
//            let value = value as AnyObject
//            //            print("Trying to create row for key:\(key) value:\(value as AnyObject)")
//            
//            switch key {
//                
//            case .primitive:
//                let row = FormRowDescriptor(tag: key.rawValue, type: .picker, title: "Type")
//                row.configuration.cell.showsInputToolbar = true
//                row.configuration.selection.options = RewardPrimitive.cases.map({$0.rawValue}) as [AnyObject]
//                row.configuration.selection.optionTitleClosure = { value in
//                    return value as? String ?? "unknown"
//                }
//                row.configuration.selection.allowsMultipleSelection = true
//                row.configuration.selection.didSelectClosure = { primitive in
//                    print("Selected primitive:\(primitive)")
//                    DispatchQueue.main.async() {
//                        
//                        if primitive != RewardSample.current.codelessReinforcement.primitive,
//                            let newCurrent = RewardSample.defaultSample(for: primitive + "Sample") {
//                            RewardSample.current = newCurrent
//                            vc.loadForm()
//                        }
//                    }
//                }
//                row.value = value
//                section1.rows.append(row)
//                
//            case .RewardID:
//                let row = FormRowDescriptor(tag: "Saved name", type: .name, title: key.rawValue)
//                row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
//                row.value = value
//                section1.rows.insert(row, at: 0)
//                
//            case .Count:
//                let row = FormRowDescriptor(tag: key.rawValue, type: .number, title: key.rawValue)
//                row.configuration.cell.appearance = ["textField.placeholder" : value as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
//                section1.rows.append(row)
//                
//            case .Duration:
//                let row = FormRowDescriptor(tag: key.rawValue, type: .numbersAndPunctuation, title: key.rawValue)
//                row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
//                section1.rows.append(row)
//                
//            case .Scale:
//                let row = FormRowDescriptor(tag: key.rawValue, type: .numbersAndPunctuation, title: key.rawValue)
//                row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
//                section1.rows.append(row)
//                
//            case .AccelX:
//                let row = FormRowDescriptor(tag: key.rawValue, type: .numbersAndPunctuation, title: "xAcceleration")
//                row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
//                section1.rows.append(row)
//                
//                
//            case .AccelY:
//                let row = FormRowDescriptor(tag: key.rawValue, type: .number, title: "yAcceleration")
//                row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
//                section1.rows.append(row)
//                
//            case .ViewOption:
//                let row = FormRowDescriptor(tag: key.rawValue, type: .picker, title: "Animate view")
//                row.configuration.cell.showsInputToolbar = true
//                row.configuration.selection.options = RewardParamViewOption.cases.map({$0.rawValue as AnyObject})
//                row.configuration.selection.optionTitleClosure = { tag in
//                    guard let tag = tag as? String,
//                        let viewOption = RewardParamViewOption(rawValue: tag) else {
//                            return "unknown"
//                    }
//                    return viewOption.tag
//                }
//                row.value = value
//                section1.rows.append(row)
//                
//            case .HapticFeedback:
//                break
//            case .SystemSound:
//                break
//            }
//        }
//        
//        form.sections = [commitSection, section1]
//        
//        return form
//    }
//    
//    
//}

