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
}



