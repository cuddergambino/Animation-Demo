//
//  SampleStruct.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SwiftForms
import AVFoundation
import CoreData

struct SampleStruct {

    static var coredata = CoreDataManager()

    static var insertBeginnerSamples: Void = {
        coredata.newContext { context in
            if Sample.fetch(context, name: nil)?.count ?? 0 == 0 {
                for preset in presets {
                    _ = Sample.insert(context, dict: preset.settings)
                }
                do {
                    try context.save()
                    coredata.save()
                } catch {
                    print(error)
                }
            }
        }
    }()

    static var allSamples: [SampleStruct] {
        _ = insertBeginnerSamples
        var allSamples = [SampleStruct]()
        coredata.newContext { context in
            if let objects = Sample.fetch(context, name: nil) {
                allSamples = objects.map({SampleStruct(dict: $0.asDictionary)})
            }
        }
        return allSamples
    }

    let rewardPrimitive: RewardPrimitive
    var settings: [String: Any]
    var rewardID: String {
        get {
            return settings[RewardParamKey.RewardID.rawValue] as? String ?? "unknownRewardId"
        }
        set {
            settings[RewardParamKey.RewardID.rawValue] = newValue
        }
    }
    var buttonView: UIImageView? {
        get {
            guard let imageString = settings[ImportedImageType.button.key + "-image"] as? String,
                let frameString = settings[ImportedImageType.button.key + "-frame"] as? String else {
                    return nil
            }
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage.from(base64String: imageString)
            imageView.frame = CGRectFromString(frameString)
            return imageView
        }

        set {
            settings[ImportedImageType.button.key + "-image"] = newValue?.image?.base64String
            settings[ImportedImageType.button.key + "-frame"] = newValue == nil ? nil : NSStringFromCGRect(newValue!.frame)
        }
    }
    var backgroundURL: URL? {
        get {
            return settings[ImportedImageType.background.key] as? URL
        }

        set {
            settings[ImportedImageType.background.key] = newValue
        }
    }
    var backgroundMovie: AVPlayerItem? {
        guard let url = backgroundURL,
            url.isMovie else {
                return nil
        }
        return AVPlayerItem(url: url)
    }
    var backgroundImage: UIImage? {
        guard let url = backgroundURL,
            url.isImage else {
                return nil
        }
        return UIImage(contentsOfFile: url.path)
    }

    fileprivate init(dict: [String: Any]) {
        self.settings = dict
        guard let primitiveName = dict["primitive"] as? String,
            let primitive = RewardPrimitive(rawValue: primitiveName) else {
                BKLog.debug(error: "Unknown primitive for :\(dict)")
                fatalError()
        }
        self.rewardPrimitive = primitive
    }

    static func new(dict: [String: Any]) -> SampleStruct {
        var sample = SampleStruct(dict: dict)
        coredata.newContext { context in
            if let samples = Sample.fetch(context, name: nil) {
                var name = sample.rewardID
                repeat {
                    name = String.generateName(withRoot: name)
                } while( !samples.filter({$0.name == name}).isEmpty )
                sample.rewardID = name
            }
        }
        return sample
    }

    func save() {
        SampleStruct.coredata.newContext { context in
            _ = Sample.update(context, dict: settings)
            print("Saving:\(settings.filter({$0.key != ImportedImageType.button.key + "-image"}))")
            do {
                if context.hasChanges {
                    try context.save()
                    SampleStruct.coredata.save()
                }
            } catch {
                print(error)
            }
        }
    }

    static func load(rewardID: String) -> SampleStruct? {
        var value: SampleStruct?
        coredata.newContext { context in
            if let object = Sample.fetch(context, name: rewardID)?.first {
                value = .init(dict: object.asDictionary)
            }
        }
        return value
    }

    static func delete(rewardID: String) {
        coredata.newContext { context in
            for object in Sample.fetch(context, name: rewardID) ?? [] {
                context.delete(object)
            }
            do {
                if context.hasChanges {
                    try context.save()
                    SampleStruct.coredata.save()
                }
            } catch {
                print(error)
            }
        }
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
                 .FontSize:
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
            return "Button"

        case .fixed:
            return "Screen"
        }
    }
}

extension SampleStruct {
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
        if let data = data(using: .utf8),
            let dict = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] {
            return dict
        }
        return [:]
    }
}

extension Dictionary {
    var toJSONData: Data {
        return (try? JSONSerialization.data(withJSONObject: self)) ?? Data()
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
