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
    static var samples: [String: RewardSample] = {
        let sampleIDs = UserDefaults.standard.object(forKey: "sampleIDs") as? [String] ?? [] //RewardPrimitive.cases.map({$0.rawValue + "Sample"})
        var samples: [String: RewardSample] = [:]
        for rewardID in sampleIDs {
            samples[rewardID] = load(rewardID: rewardID)
        }
        return samples
    }()
    
    static var current: RewardSample = samples.values.first ?? RewardSample.defaultSample(for: "ConfettiSample")!
    
    
    static func load(rewardID: String) -> RewardSample? {
        if let str = UserDefaults.standard.string(forKey: rewardID) {
            print("loaded:\(str)")
            return RewardSample(str: str)
        } else {
            return nil
        }
    }
    
    static let randomChars = ["😄", "🔥", "👍", "🤑","🏆", "⛳️", "❤️", "⁉️", "⭐️", "✨", "⛄️", "🍀", "🍬"]
    mutating func save() {
        if !RewardPrimitive.cases.filter({$0.rawValue + "Sample" == rewardID}).isEmpty {
            let generateName: (String) -> String = { baseName in
                var name = [baseName]
                for _ in 1...3 {
                    if let char = RewardSample.randomChars.randomElement {
                        name.append(char)
                    }
                }
                return name.joined()
            }
            var newName: String
            repeat {
                newName = generateName(rewardPrimitive.rawValue)
            } while(RewardSample.samples[newName] != nil)
            self.settings[RewardParamKey.RewardID.rawValue] = newName
        }
        print("Saving:\(settings.toJSONData.toJSONString as AnyObject)")
        UserDefaults.standard.set(settings.toJSONData.toJSONString, forKey: rewardID)
        RewardSample.samples[rewardID] = self
        UserDefaults.standard.set(Array(RewardSample.samples.keys) as [String], forKey: "sampleIDs")
    }
    
    static func delete(rewardID: String) {
        if let _ = RewardSample.samples.removeValue(forKey: rewardID) {
            UserDefaults.standard.removeObject(forKey: rewardID)
            UserDefaults.standard.set(Array(RewardSample.samples.keys) as [String], forKey: "sampleIDs")
            if rewardID == current.rewardID,
                let random = Array(RewardSample.samples.values).randomElement {
                RewardSample.current = random
            }
        }
    }
    
    let rewardPrimitive: RewardPrimitive
    var settings: [String: Any]
    var rewardID: String {
        return self.settings[RewardParamKey.RewardID.rawValue] as! String
    }
    
    init(str: String) {
        let dict = str.toJSONDict
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
                 .Spin, .EmissionRange, .EmissionAngle:
                 update(parameter: key.rawValue, cgFloat: value)
                    
            case .Alpha, .Alpha1, .Alpha2, .Alpha3:
                update(parameter: key.rawValue, cgFloat: value)
                
            case .Count, .Quantity, .LifetimeRange, .Lifetime, .FadeOut, .VibrateSpeed, .ScaleCount:
                update(parameter: key.rawValue, float: value)
                
            case .Duration, .VibrateDuration, .ScaleDuration, .Delay, .Bursts:
                update(parameter: key.rawValue, double: value)
                
            case .RewardID, .primitive, .Content, .Color, .Color1, .Color2, .Color3, .ViewOption:
                update(parameter: key.rawValue, string: value)
                
            case .Translation, .VibrateCount, .VibrateTranslation, .Amount, .Size:
                update(parameter: key.rawValue, int: value)
                
            case .SystemSound:
                update(parameter: key.rawValue, uint32: value)
                
            case .HapticFeedback, .Dark:
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
        } else if let value = value as? NSNumber {
            self.settings[key] = UInt32(truncating: value)
        }
    }
    mutating func update(parameter key: String, int value: AnyObject) {
        if let value = value as? NSString {
            self.settings[key] = value.integerValue
        } else if let value = value as? NSNumber {
            self.settings[key] = value.intValue
        }
    }
    mutating func update(parameter key: String, float value: AnyObject) {
        if let value = value as? NSString {
            self.settings[key] = value.floatValue
        } else if let value = value as? NSNumber {
            self.settings[key] = Float(truncating: value)
        }
    }
    mutating func update(parameter key: String, double value: AnyObject) {
        if let value = value as? NSString {
            self.settings[key] = value.doubleValue
        } else if let value = value as? NSNumber {
            self.settings[key] = value.doubleValue
        }
    }
    mutating func update(parameter key: String, cgFloat value: AnyObject) {
        if let value = value as? NSString {
            self.settings[key] = CGFloat(value.doubleValue)
        } else if let value = value as? NSNumber {
            self.settings[key] = CGFloat(truncating: value)
        }
    }
    mutating func update(parameter key: String, cgFloat2decimals value: AnyObject) {
        if let value = value as? NSString {
            self.settings[key] = CGFloat(value.doubleValue)
        } else if let value = value as? NSNumber {
            self.settings[key] = CGFloat(truncating: value)
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

extension CGFloat {
    /// Rounds the double to decimal places value
    func round(_ decimals: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(decimals))
        return Darwin.round(self * divisor) / divisor
    }
}

extension Array {
    var randomElement: Element? {
        guard !isEmpty else { return nil }
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}
