//
//  RewardSample.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import BoundlessKit
import SwiftForms

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
    
    mutating func setForm(form: FormDescriptor) {
        let formValues = form.formValues()
        
        for (key, value) in formValues {
            print("Got form key:\(key) value:\(value) as \(NSStringFromClass(type(of: value)))")
            guard let key = RewardParamKey(rawValue: key) else { continue }
            
            switch key {
            case .ViewMarginX, .ViewMarginY,
                 .Scale, .ScaleSpeed, .ScaleRange, .ScaleVelocity, .ScaleDamping,
                 .Velocity, .AccelY, .AccelX, .Damping,
                 .Spin, .EmissionRange, .EmissionAngle,
                 .Alpha, .Alpha1, .Alpha2, .Alpha3:
                update(parameter: key.rawValue, cgFloat: value)
                
            case .Count, .Quantity, .LifetimeRange, .Lifetime, .FadeOut, .VibrateSpeed, .ScaleCount:
                update(parameter: key.rawValue, float: value)
                
            case .Duration, .VibrateDuration, .ScaleDuration, .Delay, .Bursts:
                update(parameter: key.rawValue, double: value)
                
            case .RewardID:
                rewardID = value as? String ?? rewardID
                fallthrough
            case .primitive, .Content, .Color, .Color1, .Color2, .Color3, .ViewOption:
                update(parameter: key.rawValue, string: value)
                
            case .Translation, .VibrateCount, .VibrateTranslation:
                update(parameter: key.rawValue, int: value)
                
            case .SystemSound:
                update(parameter: key.rawValue, uint32: value)
                
            case .HapticFeedback, .Light:
                update(parameter: key.rawValue, bool: value)
            }
        }
        save()
    }
}

enum RewardParamViewOption: String {
    case sender, fixed
    static let cases: [RewardParamViewOption] = [.sender, .fixed]
    
    var title: String {
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
    mutating func update(parameter key: String, float value: AnyObject) {
        if let value = value as? NSString {
            self.settings[key] = value.floatValue
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
