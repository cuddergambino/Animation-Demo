//
//  UXParams+Extensions.swift
//  AnimationStudio
//
//  Created by Akash Desai on 11/6/18.
//  Copyright © 2018 Boundless Mind. All rights reserved.
//

import Foundation
import CoreData
import CoreGraphics
import UIKit

extension UXParams {
    public override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(UUID().uuidString, forKey: #keyPath(id))
        setPrimitiveValue([0.5, 0.5] as [Float], forKey: #keyPath(viewMargins))
    }

    class HolderParent {
        let id: String
        let viewMarginX: Float
        let viewMarginY: Float

        init(_ params: UXParams) {
            id = params.id ?? "rewardIDNotSet"
            viewMarginX = params.viewMargins?[safe: 0] ?? 0.5
            viewMarginY = params.viewMargins?[safe: 1] ?? 0.5
        }

        func add(to settings: inout [String: Any]) {
            settings["primitive"] = "Did Not Set"
            settings["RewardID"] = id
            settings["ViewMarginX"] = CGFloat(viewMarginX)
            settings["ViewMarginY"] = CGFloat(viewMarginY)
        }
    }
}

extension UXRotateParams {
    class Holder: HolderParent {
        let count: Int64
        let delay: Double
        let duration: Double
        let hapticFeedback: Bool
        let systemSound: Int64
        let viewOption: String

        init(_ params: UXRotateParams) {
            self.count = params.count
            self.delay = params.delay
            self.duration = params.duration
            self.hapticFeedback = params.hapticFeedback
            self.systemSound = params.systemSound
            self.viewOption = params.viewOption ?? ""
            super.init(params)
        }

        override func add(to settings: inout [String: Any]) {
            super.add(to: &settings)
            settings["primitive"] = "Rotate"
            settings["Count"] = Float(count)
            settings["Delay"] = delay
            settings["Duration"] = duration
            settings["HapticFeedback"] = hapticFeedback
            settings["SystemSound"] = UInt32(systemSound)
            settings["ViewOption"] = viewOption
        }
    }
}

extension UXEmojisplosionParams {

    public override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue([0, -150], forKey: #keyPath(accelerations))
    }

    func show(on view: UIView) {
        guard let viewMargins = viewMargins, viewMargins.count == 2,
            let accelerations = accelerations, accelerations.count == 2,
            let content = content?.utf8Decoded().image().cgImage else {
                BMLog.error("Count not transform parameters")
                return
        }
        view.showEmojiSplosion(at: view.bounds
            .pointWithMargins(x: CGFloat(viewMargins[0]),
                              y: CGFloat(viewMargins[1])),
                               content: content,
                               scale: CGFloat(scaleMean),
                               scaleSpeed: CGFloat(scaleSpeed),
                               scaleRange: CGFloat(scaleNoise),
                               lifetime: lifetime,
                               lifetimeRange: lifetimeNoise,
                               fadeout: fade,
                               quantity: Float(rate),
                               bursts: duration,
                               velocity: CGFloat(velocity),
                               xAcceleration: CGFloat(accelerations[0]),
                               yAcceleration: CGFloat(accelerations[1]),
                               angle: CGFloat(angle),
                               range: CGFloat(range),
                               spin: CGFloat(spin),
                               hapticFeedback: hapticFeedback,
                               systemSound: UInt32(systemSound))
    }
}
