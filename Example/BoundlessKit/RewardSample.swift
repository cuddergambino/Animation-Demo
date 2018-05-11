//
//  RewardSample.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
@testable import BoundlessKit
import SwiftForms


extension RewardSample {
    static func defaultSample(for rewardID: String) -> RewardSample? {
        switch rewardID {
        case "ConfettiSample":
            return RewardSample(str: "{"
                + "\"RewardID\": \"ConfettiSample\","
                + "\"primitive\": \"Confetti\","
                + "\"Duration\": 3,"
                + "\"ViewOption\": \"fixed\","
                + "\"ViewMarginX\": 0,"
                + "\"ViewMarginY\": 0,"
                + "\"ViewCustom\": \"\","
                + "\"Delay\": 0,"
                + "\"HapticFeedback\": false,"
                + "\"SystemSound\": 0"
                + "}")
            
        case "RotateSample":
            return RewardSample(str: "{"
                + "\"RewardID\": \"RotateSample\","
                + "\"primitive\": \"Rotate\","
                + "\"Duration\": 3,"
                + "\"ViewOption\": \"fixed\","
                + "\"ViewMarginX\": 0,"
                + "\"ViewMarginY\": 0,"
                + "\"ViewCustom\": \"\","
                + "\"Count\": 2,"
                + "\"Delay\": 0,"
                + "\"HapticFeedback\": false,"
                + "\"SystemSound\": 0"
                + "}")
            
        case "EmojisplosionSample":
            return RewardSample(str: "{"
                + "\"RewardID\": \"EmojisplosionSample\","
                + "\"primitive\": \"Emojisplosion\","
                + "\"SystemSound\": 1109,"
                + "\"HapticFeedback\": true,"
                + "\"Delay\": 0,"
                + "\"ViewCustom\": \"\","
                + "\"ViewMarginY\": 0.5,"
                + "\"ViewMarginX\": 0.5,"
                + "\"ViewOption\": \"sender\","
                + "\"AccelY\": -200,"
                + "\"AccelX\": 0,"
                + "\"ScaleSpeed\": 0.5,"
                + "\"ScaleRange\": 0.2,"
                + "\"Scale\": 1,"
                + "\"Bursts\": 1,"
                + "\"FadeOut\": 1,"
                + "\"Spin\": 20,"
                + "\"EmissionRange\": 45,"
                + "\"EmissionAngle\": 90,"
                + "\"LifetimeRange\": 0.5,"
                + "\"Lifetime\": 2,"
                + "\"Quantity\": 1,"
                + "\"Velocity\": 20,"
                + "\"Content\": \"👍\""
                + "}")
            
        case "GlowSample":
            return RewardSample(str: "{"
                + "\"RewardID\": \"GlowSample\","
                + "\"primitive\": \"Glow\","
                + "\"Color\": \"444444\","
                + "\"Duration\": 2,"
                + "\"Alpha\": 0.7,"
                + "\"Count\": 2,"
                + "\"Radius\": 0,"
                + "\"ViewOption\": \"sender\","
                + "\"ViewMarginX\": 0,"
                + "\"ViewMarginY\": 0,"
                + "\"ViewCustom\": \"\","
                + "\"Delay\": 0,"
                + "\"HapticFeedback\": false,"
                + "\"SystemSound\": 0"
                + "}")
            
        case "SheenSample":
            return RewardSample(str: "{"
                + "\"RewardID\": \"SheenSample\","
                + "\"primitive\": \"Sheen\","
                + "\"Duration\": 2,"
                + "\"ViewOption\": \"sender\","
                + "\"ViewMarginX\": 0,"
                + "\"ViewMarginY\": 0,"
                + "\"ViewCustom\": \"\","
                + "\"Delay\": 0,"
                + "\"HapticFeedback\": true,"
                + "\"SystemSound\": 0"
                + "}")
            
        case "PulseSample":
            return RewardSample(str: "{"
                + "\"RewardID\": \"PulseSample\","
                + "\"primitive\": \"Pulse\","
                + "\"Duration\": 2,"
                + "\"Count\": 2,"
                + "\"Scale\": 2,"
                + "\"Velocity\": 2,"
                + "\"Damping\": 2,"
                + "\"ViewOption\": \"sender\","
                + "\"ViewMarginX\": 0,"
                + "\"ViewMarginY\": 0,"
                + "\"ViewCustom\": \"\","
                + "\"Delay\": 0,"
                + "\"HapticFeedback\": false,"
                + "\"SystemSound\": 0"
                + "}")
            
        case "ShimmySample":
            return RewardSample(str: "{"
                + "\"RewardID\": \"ShimmySample\","
                + "\"primitive\": \"Shimmy\","
                + "\"Duration\": 3,"
                + "\"Count\": 3,"
                + "\"Translation\": 20,"
                + "\"ViewOption\": \"sender\","
                + "\"ViewMarginX\": 0,"
                + "\"ViewMarginY\": 0,"
                + "\"ViewCustom\": \"\","
                + "\"Delay\": 0,"
                + "\"HapticFeedback\": true,"
                + "\"SystemSound\": 0"
                + "}")
            
        case "VibrateSample":
            return RewardSample(str: "{"
                + "\"RewardID\": \"VibrateSample\","
                + "\"primitive\": \"Vibrate\","
                + "\"VibrateDuration\": 0.8,"
                + "\"VibrateCount\": 2,"
                + "\"VibrateTranslation\": 20,"
                + "\"VibrateSpeed\": 2,"
                + "\"Scale\": 0.96,"
                + "\"ScaleDuration\": 2,"
                + "\"ScaleCount\": 2,"
                + "\"ScaleVelocity\": 20,"
                + "\"ScaleDamping\": 10,"
                + "\"ViewOption\": \"sender\","
                + "\"ViewMarginX\": 0,"
                + "\"ViewMarginY\": 0,"
                + "\"ViewCustom\": \"\","
                + "\"Delay\": 0,"
                + "\"HapticFeedback\": false,"
                + "\"SystemSound\": 0"
                + "}")
        default:
            return nil
        }
        
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
    AccelX,
    AccelY,
    ViewOption,
    ViewMarginX,
    ViewMarginY,
    HapticFeedback,
    SystemSound,
    Content,
    ScaleSpeed,
    ScaleRange,
    Bursts,
    FadeOut,
    Spin,
    EmissionRange,
    EmissionAngle,
    LifetimeRange,
    Lifetime,
    Alpha
    
    var title: String {
        switch self {
        case .RewardID: return "Reward Name"
        case .ViewOption: return "Animate View"
        case .HapticFeedback: return "Vibrate"
        case .SystemSound: return "Sound Option (1000-1036)"
        case .Quantity: return "Count"
        case .ViewMarginX: return "Margin X (0.5 = 50%, 5 = 5pts)"
        case .ViewMarginY: return "Margin Y (0.5 = 50%, 5 = 5pts)"
        default: return self.rawValue
        }
    }
    
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
            
        case .Duration, .Delay, .Scale, .Velocity, .AccelX, .AccelY, .ViewMarginX, .ViewMarginY, .ScaleSpeed, .Alpha,
             .ScaleRange, .FadeOut, .Spin, .EmissionRange, .EmissionAngle, .LifetimeRange, .Lifetime, .Translation:
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
            
        case .HapticFeedback:
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

struct RewardSample {
    
    static var current: RewardSample = samples.first!.value
    
    static var samples: [String: RewardSample] = {
        let sampleIDs = UserDefaults.standard.object(forKey: "sampleIDs") as? [String] ?? RewardPrimitive.cases.map({$0.rawValue + "Sample"})
        var samples: [String: RewardSample] = [:]
        for rewardID in sampleIDs {
            samples[rewardID] = load(rewardID: rewardID)
                ?? defaultSample(for: rewardID)
        }
        return samples
    }()
    
    static func load(rewardID: String) -> RewardSample? {
        if let str = UserDefaults.standard.string(forKey: rewardID) {
            print("loaded:\(str)")
            return RewardSample(str: str)
        } else {
            return nil
        }
    }
    
    func save() {
        print("Saving:\(settings.toJSONData.toJSONString as AnyObject)")
        UserDefaults.standard.set(settings.toJSONData.toJSONString, forKey: rewardID)
        RewardSample.samples[rewardID] = self
        UserDefaults.standard.set(Array(RewardSample.samples.keys) as [String], forKey: "sampleIDs")
    }
    
    var rewardID: String
    let rewardPrimitive: RewardPrimitive
    var settings: [String: Any]
    
    init(str: String) {
        let dict = str.toJSONDict
        self.rewardID = dict["RewardID"] as! String
        self.rewardPrimitive = RewardPrimitive.cases.filter({$0.rawValue == dict["primitive"] as! String}).first!
        self.settings = dict
    }
    
    func sample(target: NSObject, sender: AnyObject?) {
        rewardPrimitive.show(settings: settings, targetInstance: target, senderInstance: sender)
    }
    
    func getForm(_ vc: RewardFormViewController) -> FormDescriptor {
        let form = FormDescriptor(title: "Reward Params")
        
        let commitSection = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        let commitRow = FormRowDescriptor(tag: "button", type: .button, title: "Update form")
        commitRow.configuration.button.didSelectClosure = { row in
            vc.view.endEditing(true)
            vc.loadForm()
//            vc.tableView.reloadData()
        }
        commitSection.rows.append(commitRow)
        
        
        let section1 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        for (key, value) in settings {
            guard let key = RewardParamKey(rawValue: key) else { continue }
            let value = value as AnyObject
            //            print("Trying to create row for key:\(key) value:\(value as AnyObject)")
            
            switch key {
                
            case .primitive:
                let row = FormRowDescriptor(tag: key.rawValue, type: .picker, title: "Type")
                row.configuration.cell.showsInputToolbar = true
                row.configuration.selection.options = RewardPrimitive.cases.map({$0.rawValue}) as [AnyObject]
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
                section1.rows.append(row)
                
            case .RewardID:
                let row = FormRowDescriptor(tag: "Saved name", type: .name, title: key.rawValue)
                row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
                row.value = value
                section1.rows.insert(row, at: 0)
                
            case .Count:
                let row = FormRowDescriptor(tag: key.rawValue, type: .number, title: key.rawValue)
                row.configuration.cell.appearance = ["textField.placeholder" : value as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
                section1.rows.append(row)
                
            case .Duration:
                let row = FormRowDescriptor(tag: key.rawValue, type: .numbersAndPunctuation, title: key.rawValue)
                row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
                section1.rows.append(row)
                
            case .Scale:
                let row = FormRowDescriptor(tag: key.rawValue, type: .numbersAndPunctuation, title: key.rawValue)
                row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
                section1.rows.append(row)
                
            case .AccelX:
                let row = FormRowDescriptor(tag: key.rawValue, type: .numbersAndPunctuation, title: "xAcceleration")
                row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
                section1.rows.append(row)
                
                
            case .AccelY:
                let row = FormRowDescriptor(tag: key.rawValue, type: .number, title: "yAcceleration")
                row.configuration.cell.appearance = ["textField.placeholder" : value.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
                section1.rows.append(row)
                
            case .ViewOption:
                let row = FormRowDescriptor(tag: key.rawValue, type: .picker, title: "Animate view")
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
                section1.rows.append(row)
                
            case .HapticFeedback:
                break
            case .SystemSound:
                break
            default:
                break
            }
        }
        
        form.sections = [commitSection, section1]
        
        return form
    }
    
    mutating func setForm(form: FormDescriptor) {
        let formValues = form.formValues()
        
        for (key, value) in formValues {
            print("Got form key:\(key) value:\(value) as \(NSStringFromClass(type(of: value)))")
            guard let key = RewardParamKey(rawValue: key) else { continue }
            
            switch key {
            case .ViewMarginX, .ViewMarginY,
                 .Scale, .ScaleSpeed, .ScaleRange,
                 .Velocity, .AccelY, .AccelX,
                 .Spin, .EmissionRange, .EmissionAngle,
                 .Alpha:
                update(parameter: key.rawValue, cgFloat: value)
                
            case .Duration, .Delay, .LifetimeRange, .Lifetime, .FadeOut:
                update(parameter: key.rawValue, double: value)
                
            case .RewardID, .primitive, .ViewOption, .Content:
                update(parameter: key.rawValue, string: value)
                
            case .Count, .Quantity, .Bursts, .Translation:
                update(parameter: key.rawValue, int: value)
                
            case .SystemSound:
                update(parameter: key.rawValue, uint32: value)
                
            case .HapticFeedback:
                update(parameter: key.rawValue, bool: value)
            }
        }
        save()
    }
}

enum RewardParamViewOption: String {
    case sender, fixed
    static let cases: [RewardParamViewOption] = [.sender, .fixed]
    
    var tag: String {
        switch self {
        case .sender:
            return "Item"
            
        case .fixed:
            return "Screen"
        }
    }
}

extension RewardSample {
    mutating func update(parameter key: String, string value: AnyObject) {
        if let value = value as? String {
            self.settings[key] = value
        }
    }
    mutating func update(parameter key: String, bool value: AnyObject) {
        if let value = value as? Bool {
            self.settings[key] = value
        }
    }
    mutating func update(parameter key: String, uint32 value: AnyObject) {
        if let value = value as? NSString {
            self.settings[key] = UInt32(value.intValue)
        }
    }
    mutating func update(parameter key: String, int value: AnyObject) {
        if let value = value as? NSString {
            self.settings[key] = value.integerValue
        }
    }
    mutating func update(parameter key: String, double value: AnyObject) {
        if let value = value as? NSString {
            self.settings[key] = value.doubleValue
        }
    }
    mutating func update(parameter key: String, cgFloat value: AnyObject) {
        if let value = value as? NSString {
            self.settings[key] = CGFloat(value.doubleValue)
        }
    }
}

extension String {
    var toJSONDict: [String: Any] {
        return (try! JSONSerialization.jsonObject(with: data(using: .utf8)!) as? [String: Any])!
    }
}

extension Dictionary {
    var toJSONData: Data {
        return try! JSONSerialization.data(withJSONObject: self)
    }
}

extension Data {
    var toJSONString: String? {
        return String(data: self, encoding: .utf8)
    }
}
