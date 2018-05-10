//
//  Reward.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 3/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import BoundlessKit

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




struct RewardParams {
    static var someJSON: [String: Any] = ("{"
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
    "}").toJSON
    
    var primitive: RewardPrimitive
    var strParams: [StringParam] = []
    
    init(dict: [String: Any] = RewardParams.someJSON) {
        primitive = RewardPrimitive(rawValue: dict["primitive"] as! String)!
        strParams = dict.flatMap({ (key, value) -> StringParam? in
            if let str = value as? String {
                return StringParam.init(key: key, value: str)
            } else { return nil }
        })
    }
}

struct StringParam {
    var key: String
    var value: String
}

extension String {
    var toJSON: [String: Any] {
        return (try! JSONSerialization.jsonObject(with: data(using: .utf8)!) as? [String: Any])!
    }
}

extension Dictionary {
    var toJSON: Data {
        return try! JSONSerialization.data(withJSONObject: self)
    }
}
