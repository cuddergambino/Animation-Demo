//
//  Reward.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 3/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
@testable import BoundlessKit
import SwiftForms

enum RewardPrimitive : String {
    case shimmy, pulse, vibrate, rotate, glow, sheen, Emojisplosion, confetti, popover
    static let cases:[RewardPrimitive] = [.shimmy, .pulse, .vibrate, .rotate, .glow, .sheen, .Emojisplosion, .confetti, .popover]
    
    func test(viewController: UIViewController, view: UIView) {
        let completion = {
            print("Completed showing reward type:\(self.rawValue)")
        }
        
        switch self {
        case .shimmy:
            view.showShimmy(completion: completion)
        case .pulse:
            view.showPulse(completion: completion)
        case .vibrate:
            view.showVibrate(hapticFeedback: true, systemSound: 1009, completion: completion)
        case .rotate:
            view.rotate360Degrees(completion: completion)
        case .glow:
            view.showGlow(completion: completion)
        case .sheen:
            view.clipsToBounds = true
            view.showSheen(completion: completion)
        case .Emojisplosion:
            view.superview!.showEmojiSplosion(at: view.center, completion: completion)
        case .confetti:
            //            viewController.view.showConfetti(completion: completion)
            viewController.view.showConfetti(duration: 3, colors: [UIColor.blue], completion: completion)
        case .popover:
            viewController.view.showPopover(completion: completion)
        }
    }
    
    static func colorForIndex(_ index: Int) -> UIColor{
        let val = (CGFloat (index) / CGFloat(cases.count)) * (204/255.0)
        return UIColor.init(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
}




class RewardFormInput : NSObject {
    
    struct RewardParamKey {
        static let RewardID = "RewardID"
        static let primitive = "primitive"
        static let duration = "Duration"
        static let xAcceleration = "AccelX"
        static let nameTag = "name"
        static let passwordTag = "password"
        static let lastNameTag = "lastName"
        static let jobTag = "job"
        static let emailTag = "email"
        static let URLTag = "url"
        static let phoneTag = "phone"
        static let enabled = "enabled"
        static let check = "check"
        static let segmented = "segmented"
        static let picker = "picker"
        static let birthday = "birthday"
        static let categories = "categories"
        static let button = "button"
        static let stepper = "stepper"
        static let slider = "slider"
        static let textView = "textview"
    }
    
    static func row(for key:String, defaultValue value: AnyObject?) -> FormRowDescriptor? {
//        print("Trying to create row for key:\(key) value:\(value as AnyObject)")
        switch key {
        case RewardParamKey.RewardID:
            let row = FormRowDescriptor(tag: key, type: .name, title: key)
            row.configuration.cell.appearance = ["textField.placeholder" : value?.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            row.value = value as AnyObject
            return row
            
        case RewardParamKey.duration:
            let row = FormRowDescriptor(tag: key, type: .number, title: key)
            //            row.configuration.cell.showsInputToolbar = true
            row.value = value as AnyObject
            return row
            
        
        case RewardParamKey.xAcceleration:
            let row = FormRowDescriptor(tag: key, type: .number, title: "xAcceleration")
            row.configuration.cell.appearance = ["textField.placeholder" : value?.description as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            return row
            
        case "primitive":
            let row = FormRowDescriptor(tag: key, type: .picker, title: key)
            row.configuration.cell.showsInputToolbar = true
            row.configuration.selection.options = RewardPrimitive.cases.map({$0.rawValue}) as [AnyObject]
            row.configuration.selection.optionTitleClosure = {$0 as? String ?? "unknown"}
            row.value = value as AnyObject
           return row
            
        default:
            return nil
        }
    }
}

struct RewardSample {
    
    static var current: RewardSample = emojisplosionSample
    
    static var sampleIDs: Set<String> = Set(UserDefaults.standard.object(forKey: "samples") as? [String] ?? ["emojisplosionSample"])
    
    static var emojisplosionSample: RewardSample = load(rewardID: "emojisplosionSample") ?? RewardSample(str: "{"
        + "\"RewardID\": \"emojisplosionSample\","
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
        + "\"Content\": \"👍\"" +
        "}")
    
    private static func load(rewardID: String) -> RewardSample? {
        if let str = UserDefaults.standard.string(forKey: rewardID) {
            print("loaded:\(str)")
            return RewardSample(str: str)
        } else {
            return nil
        }
    }
    
    private func save() {
        print("Saving:\(codelessReinforcement.parameters.toJSONData.toJSONString as AnyObject)")
        UserDefaults.standard.set(codelessReinforcement.parameters.toJSONData.toJSONString, forKey: rewardID)
        RewardSample.sampleIDs.insert(rewardID)
        UserDefaults.standard.set(Array(RewardSample.sampleIDs), forKey: "samples")
    }
    
    var rewardID: String
    var codelessReinforcement: CodelessReinforcement
    
    init(str: String) {
        let dict = str.toJSONDict
        self.rewardID = dict["RewardID"] as! String
        self.codelessReinforcement = CodelessReinforcement(from: dict)!
    }
    
    func getForm() -> FormDescriptor {
        let form = FormDescriptor(title: "Reward Params")
        let section1 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        if let rewardID = codelessReinforcement.parameters["RewardID"] as? String,
            let row = RewardFormInput.row(for: "RewardID", defaultValue: rewardID as AnyObject) {
            section1.rows.append(row)
        }
        for (key, value) in codelessReinforcement.parameters {
            if key == "RewardID" { continue }
            if let row = RewardFormInput.row(for: key, defaultValue: value as AnyObject) {
                section1.rows.append(row)
            }
        }
        
        form.sections = [section1]
        
        return form
    }
    
    mutating func setForm(form: FormDescriptor) {
        let formValues = form.formValues()
        
        for (key, value) in formValues {
            print("Got form key:\(key) value:\(value) as \(NSStringFromClass(type(of: value)))")
            switch key {
            case "AccelX":
                codelessReinforcement.update(parameter: key, cgFloat: value)
                
            default:
                break
            }
            
//            if codelessReinforcement.parameters[key] != nil {
//                codelessReinforcement.parameters[key] = value
//            }
        }
        save()
    }
}

extension CodelessReinforcement {
    mutating func update(parameter key: String, cgFloat value: AnyObject) {
        if let value = value as? NSString {
            self.parameters[key] = CGFloat(value.doubleValue)
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
