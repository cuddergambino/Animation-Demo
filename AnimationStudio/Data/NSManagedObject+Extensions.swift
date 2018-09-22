//
//  NSManagedObject+Extensions.swift
//  AnimationStudio
//
//  Created by Akash Desai on 9/22/18.
//  Copyright © 2018 Boundless Mind. All rights reserved.
//

import Foundation
import UIKit

extension UXEmojisplosionParams {
    public override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue([0, -150], forKey: #keyPath(accelerations))
        setPrimitiveValue([0.5, 0.5], forKey: #keyPath(viewMargins))
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
