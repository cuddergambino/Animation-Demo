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
    case Shimmy, Pulse, Vibrate, Rotate, Glow, Sheen, Emojisplosion, Confetti, popover
    static let cases:[RewardPrimitive] = [.Shimmy, .Pulse, .Vibrate, .Rotate, .Glow, .Sheen, .Emojisplosion, .Confetti, .popover]
    
    func test(viewController: UIViewController, view: UIView) {
        let completion = {
            print("Completed showing reward type:\(self.rawValue)")
        }
        
        switch self {
        case .Shimmy:
            view.showShimmy(completion: completion)
        case .Pulse:
            view.showPulse(completion: completion)
        case .Vibrate:
            view.showVibrate(hapticFeedback: true, systemSound: 1009, completion: completion)
        case .Rotate:
            view.rotate360Degrees(completion: completion)
        case .Glow:
            view.showGlow(completion: completion)
        case .Sheen:
            view.clipsToBounds = true
            view.showSheen(completion: completion)
        case .Emojisplosion:
            view.superview!.showEmojiSplosion(at: view.center, completion: completion)
        case .Confetti:
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
    
    func show(settings: [String: Any], targetInstance: NSObject, senderInstance: AnyObject?, completion: @escaping ()->Void = {}) {
        guard let delay = settings["Delay"] as? Double else { BKLog.debug(error: "Missing parameter", visual: true); return }
        guard let reinforcementType = settings["primitive"] as? String else { BKLog.debug(error: "Missing parameter", visual: true); return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if let viewAndLocation = CodelessReinforcement.reinforcementViews(senderInstance: senderInstance, targetInstance: targetInstance, options: settings) {
                switch reinforcementType {
                    
                case "Confetti":
                    guard let duration = settings["Duration"] as? Double else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let hapticFeedback = settings["HapticFeedback"] as? Bool  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let systemSound = settings["SystemSound"] as? UInt32  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    for (view, _) in viewAndLocation {
                        view.showConfetti(duration: duration, hapticFeedback: hapticFeedback, systemSound: systemSound, completion: completion)
                    }
                    return
                    
                case "Emojisplosion":
                    guard let content = settings["Content"] as? String else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let xAcceleration = settings["AccelX"] as? CGFloat else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let yAcceleration = settings["AccelY"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let bursts = settings["Bursts"] as? Double  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let angle = settings["EmissionAngle"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let range = settings["EmissionRange"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let fadeout = settings["FadeOut"] as? Float  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let lifetime = settings["Lifetime"] as? Float  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let lifetimeRange = settings["LifetimeRange"] as? Float  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let quantity = settings["Quantity"] as? Float  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let scale = settings["Scale"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let scaleRange = settings["ScaleRange"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let scaleSpeed = settings["ScaleSpeed"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let spin = settings["Spin"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let velocity = settings["Velocity"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let hapticFeedback = settings["HapticFeedback"] as? Bool  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let systemSound = settings["SystemSound"] as? UInt32  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    let image = content.decode().image().cgImage
                    for (view, location) in viewAndLocation {
                        view.showEmojiSplosion(at: location, content: image, scale: scale, scaleSpeed: scaleSpeed, scaleRange: scaleRange, lifetime: lifetime, lifetimeRange: lifetimeRange, fadeout: fadeout, quantity: quantity, bursts: bursts, velocity: velocity, xAcceleration: xAcceleration, yAcceleration: yAcceleration, angle: angle, range: range, spin: spin, hapticFeedback: hapticFeedback, systemSound: systemSound, completion: completion)
                    }
                    return
                    
                case "Rotate":
                    guard let count = settings["Count"] as? Float  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let duration = settings["Duration"] as? Double  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let hapticFeedback = settings["HapticFeedback"] as? Bool  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let systemSound = settings["SystemSound"] as? UInt32  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    for (view, _) in viewAndLocation {
                        view.rotate360Degrees(count: count, duration: duration, hapticFeedback: hapticFeedback, systemSound: systemSound, completion: completion)
                    }
                    return
                    
                case "Glow":
                    guard let duration = settings["Duration"] as? Double  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let colorString = settings["Color"] as? String  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let alpha = settings["Alpha"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let count = settings["Count"] as? Float  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let radius = settings["Radius"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let hapticFeedback = settings["HapticFeedback"] as? Bool  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let systemSound = settings["SystemSound"] as? UInt32  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    let color = UIColor.from(rgb: colorString)
                    for (view, _) in viewAndLocation {
                        view.showGlow(count: count, duration: duration, color: color, alpha: alpha, radius: radius, hapticFeedback: hapticFeedback, systemSound: systemSound, completion: completion)
                    }
                    return
                    
                case "Sheen":
                    guard let duration = settings["Duration"] as? Double  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let hapticFeedback = settings["HapticFeedback"] as? Bool  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let systemSound = settings["SystemSound"] as? UInt32  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    for (view, _) in viewAndLocation {
                        view.showSheen(duration: duration, hapticFeedback: hapticFeedback, systemSound: systemSound, completion: completion)
                    }
                    return
                    
                case "Pulse":
                    guard let count = settings["Count"] as? Float  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let duration = settings["Duration"] as? Double  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let scale = settings["Scale"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let velocity = settings["Velocity"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let damping = settings["Damping"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let hapticFeedback = settings["HapticFeedback"] as? Bool  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let systemSound = settings["SystemSound"] as? UInt32  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    for (view, _) in viewAndLocation {
                        view.showPulse(count: count, duration: duration, scale: scale, velocity: velocity, damping: damping, hapticFeedback: hapticFeedback, systemSound: systemSound, completion: completion)
                    }
                    return
                    
                case "Shimmy":
                    guard let count = settings["Count"] as? Int  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let duration = settings["Duration"] as? Double  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let translation = settings["Translation"] as? Int  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let hapticFeedback = settings["HapticFeedback"] as? Bool  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let systemSound = settings["SystemSound"] as? UInt32  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    for (view, _) in viewAndLocation {
                        view.showShimmy(count: count, duration: duration, translation: translation, hapticFeedback: hapticFeedback, systemSound: systemSound, completion: completion)
                    }
                    return
                    
                case "Shimmy":
                    guard let count = settings["Count"] as? Int  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let duration = settings["Duration"] as? Double  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let translation = settings["Translation"] as? Int  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let hapticFeedback = settings["HapticFeedback"] as? Bool  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let systemSound = settings["SystemSound"] as? UInt32  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    for (view, _) in viewAndLocation {
                        view.showShimmy(count: count, duration: duration, translation: translation, hapticFeedback: hapticFeedback, systemSound: systemSound, completion: completion)
                    }
                    return
                    
                case "Vibrate":
                    guard let vibrateDuration = settings["VibrateDuration"] as? Double  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let vibrateCount = settings["VibrateCount"] as? Int  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let vibrateTranslation = settings["VibrateTranslation"] as? Int  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let vibrateSpeed = settings["VibrateSpeed"] as? Float  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let scale = settings["Scale"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let scaleDuration = settings["ScaleDuration"] as? Double  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let scaleCount = settings["ScaleCount"] as? Float  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let scaleVelocity = settings["ScaleVelocity"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let scaleDamping = settings["ScaleDamping"] as? CGFloat  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let hapticFeedback = settings["HapticFeedback"] as? Bool  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    guard let systemSound = settings["SystemSound"] as? UInt32  else { BKLog.debug(error: "Missing parameter", visual: true); break }
                    for (view, _) in viewAndLocation {
                        view.showVibrate(vibrateCount: vibrateCount, vibrateDuration: vibrateDuration, vibrateTranslation: vibrateTranslation, vibrateSpeed: vibrateSpeed, scale: scale, scaleCount: scaleCount, scaleDuration: scaleDuration, scaleVelocity: scaleVelocity, scaleDamping: scaleDamping, hapticFeedback: hapticFeedback, systemSound: systemSound, completion: completion)
                    }
                    return
                    
                default:
                    // TODO: implement delegate callback for dev defined reinforcements
                    BKLog.debug(error: "Unknown reinforcement type:\(String(describing: settings))", visual: true)
                    return
                }
            }
        }
    }
}



