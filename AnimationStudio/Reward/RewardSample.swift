//
//  RewardSample.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SwiftForms
import AVFoundation
import CoreData

struct RewardSample {

    fileprivate static var coredata: CoreDataManager? {
        return (UIApplication.shared.delegate as? AppDelegate)?.coredata
    }

    static var samples: [String: RewardSample] = {
        var samples: [String: RewardSample] = [:]
        coredata?.newContext { context in
            let sampleRequest: NSFetchRequest<Sample> = Sample.fetchRequest()
            var savedSamples: [Sample]
            do {
                try savedSamples = context.fetch(sampleRequest)
                if savedSamples.isEmpty {
                    savedSamples = Sample.insertBeginner(context: context)
                    coredata?.save()
                }
            } catch {
                print(error)
                savedSamples = []
            }

            for sample in savedSamples {
                var sampleInfo = [String: Any]()
                for uxParam in sample.uxParams ?? [] {
                    if let uxParam = uxParam as? UXRotateParams {
                        uxParam.valuesHolder().add(to: &sampleInfo)
                    }
                }
                samples[sample.name ?? "unknown"] = RewardSample(dict: sampleInfo)
            }
        }
//        if let sampleIDs = UserDefaults.standard.object(forKey: "sampleIDs") as? [String] {
//            for rewardID in sampleIDs {
//                samples[rewardID] = load(rewardID: rewardID)
//            }
//        } else {
//            for preset in RewardSample.presets.reversed() {
//                samples[preset.rewardID] = preset
//            }
//                    RewardSample.presets[i].save()
//                }
//            }
//        }
        return samples
    }()

    fileprivate static var _current: RewardSample?
    static var current: RewardSample {
        get {
            if _current != nil {
                return _current!
            } else {
                let sample = samples.first?.value ?? RewardSample.defaultSample(for: .Confetti)
                _current = sample
                return sample
            }
        }
        set {
            _current = newValue
        }
    }

    let rewardPrimitive: RewardPrimitive
    var settings: [String: Any]
    var rewardID: String {
        return self.settings[RewardParamKey.RewardID.rawValue] as? String ?? "unknown"
    }
    var buttonView: UIImageView {
        get {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit

            guard let imageString = settings[ImportedImageType.button.key + "-image"] as? String,
                let frameString = settings[ImportedImageType.button.key + "-frame"] as? String else {
                    return imageView
            }
            imageView.image = UIImage.from(base64String: imageString)
            imageView.frame = CGRectFromString(frameString)
            return imageView
        }

        set {
            settings[ImportedImageType.button.key + "-image"] = newValue.image?.base64String
            settings[ImportedImageType.button.key + "-frame"] = NSStringFromCGRect(newValue.frame)
        }
    }
    var backgroundURL: URL? {
        get {
            guard let urlString = settings[ImportedImageType.background.key + "-url"] as? String,
                let url = URL(string: urlString) else {
                    return nil
            }
            return url
        }

        set {
            settings[ImportedImageType.background.key + "-url"] = newValue?.absoluteString
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
                BKLog.debug(error: "Unknown primitive")
                fatalError()
        }
        self.rewardPrimitive = primitive
    }

    static func new(dict: [String: Any]) -> RewardSample {
        var sample = RewardSample(dict: dict)
        if !RewardPrimitive.cases.filter({$0.rawValue + "Sample" == sample.rewardID}).isEmpty {
            var newName: String
            repeat {
                newName = String.generateName(withRoot: sample.rewardPrimitive.rawValue)
            } while(RewardSample.samples[newName] != nil)
            sample.settings[RewardParamKey.RewardID.rawValue] = newName
        }
        sample.buttonView = _current?.buttonView ?? {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "clickMe")
            imageView.frame = CGRect(x: 0, y: 80, width: 234, height: 234)
            imageView.adjustHeight()
            return imageView
        }()
        sample.backgroundURL = _current?.backgroundURL
        return sample
    }

    func save() {
//        RewardSample.samples[rewardID] = self
//        print("Saving:\(settings.toJSONData.toJSONString as AnyObject)")
//        UserDefaults.standard.set(settings, forKey: rewardID)
//        UserDefaults.standard.set(Array(RewardSample.samples.keys) as [String], forKey: "sampleIDs")
    }

    static func load(rewardID: String) -> RewardSample? {
//        if let dict = UserDefaults.standard.dictionary(forKey: rewardID) {
//            //            print("loaded:\(str)")
//            return RewardSample(dict: dict)
//        } else {
//            return nil
//        }
        return nil
    }

    static func delete(rewardID: String) {
        if RewardSample.samples.removeValue(forKey: rewardID) != nil {
            UserDefaults.standard.removeObject(forKey: rewardID)
            UserDefaults.standard.set(Array(RewardSample.samples.keys) as [String], forKey: "sampleIDs")
            if rewardID == current.rewardID,
                let first = RewardSample.samples.first?.value {
                RewardSample.current = first
            } else {
                RewardSample.current = RewardSample.defaultSample(for: .Confetti)
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
