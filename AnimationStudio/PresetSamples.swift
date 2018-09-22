//
//  PresetSamples.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import CoreGraphics

extension RewardSample {

    static var presets: [RewardSample] = {
        return [
            RewardSample.new(dict: [
                "RewardID": "Hello There",
                "primitive": "Emojisplosion",
                "SystemSound": 1010 as UInt32,
                "HapticFeedback": true,
                "Delay": 0 as Double,
                "ViewCustom": "",
                "ViewMarginY": 0.5 as CGFloat,
                "ViewMarginX": 0.5 as CGFloat,
                "ViewOption": "sender",
                "AccelY": -150 as CGFloat,
                "AccelX": 0 as CGFloat,
                "ScaleSpeed": 0.2 as CGFloat,
                "ScaleRange": 0.2 as CGFloat,
                "Scale": 0.6 as CGFloat,
                "Bursts": 1 as Double,
                "FadeOut": -0.2 as Float,
                "Spin": 0 as CGFloat,
                "EmissionRange": 45 as CGFloat,
                "EmissionAngle": -90 as CGFloat,
                "LifetimeRange": 0.5 as Float,
                "Lifetime": 2 as Float,
                "Quantity": 2 as Float,
                "Velocity": -50 as CGFloat,
                "Content": "🖐"
                ]),

            RewardSample.new(dict: [
                "RewardID": "Confetti Surprise",
                "primitive": "Confetti",
                "Duration": 2 as Double,
                "Color1": "#FB3247",
                "Alpha1": 0.8 as CGFloat,
                "Color2": "#F5FB61",
                "Alpha2": 0.8 as CGFloat,
                "Color3": "#9243F9",
                "Alpha3": 0.8 as CGFloat,
                "Amount": 4 as Int,
                "Size": 9 as Int,
                "ViewOption": "fixed",
                "ViewMarginX": 0 as CGFloat,
                "ViewMarginY": 0 as CGFloat,
                "ViewCustom": "",
                "Delay": 0 as Double,
                "HapticFeedback": false,
                "SystemSound": 0 as UInt32
                ]),

            RewardSample.new(dict: [
                "RewardID": "Rotate Preset",
                "primitive": "Rotate",
                "Duration": 1 as Double,
                "ViewOption": "sender",
                "ViewMarginX": 0 as CGFloat,
                "ViewMarginY": 0 as CGFloat,
                "ViewCustom": "",
                "Count": 2 as Float,
                "Delay": 0 as Double,
                "HapticFeedback": false,
                "SystemSound": 1016 as UInt32
                ])
        ]
    }()

    static func defaultSample(for primitive: RewardPrimitive) -> RewardSample {
        switch primitive {
        case .Popover:
            return RewardSample.new(dict: [
                "RewardID": "PopoverSample",
                "primitive": "Popover",
                "Content": "❤️",
                "FontSize": 24 as CGFloat,
                "Duration": 3 as Double,
                "Dark": false,
                "ViewOption": "fixed",
                "ViewMarginX": 0 as CGFloat,
                "ViewMarginY": 0 as CGFloat,
                "ViewCustom": "",
                "Delay": 0 as Double,
                "HapticFeedback": false,
                "SystemSound": 0 as UInt32
                ])

        case .Confetti:
            return RewardSample.new(dict: [
                "RewardID": "ConfettiSample",
                "primitive": "Confetti",
                "Duration": 2 as Double,
                "Color1": "#4d81fb",
                "Alpha1": 0.8 as CGFloat,
                "Color2": "#4ac4fb",
                "Alpha2": 0.8 as CGFloat,
                "Color3": "#9243f9",
                "Alpha3": 0.8 as CGFloat,
                "Amount": 4 as Int,
                "Size": 9 as Int,
                "ViewOption": "fixed",
                "ViewMarginX": 0 as CGFloat,
                "ViewMarginY": 0 as CGFloat,
                "ViewCustom": "",
                "Delay": 0 as Double,
                "HapticFeedback": false,
                "SystemSound": 0 as UInt32
                ])

        case .Rotate:
            return RewardSample.new(dict: [
                "RewardID": "RotateSample",
                "primitive": "Rotate",
                "Duration": 1 as Double,
                "ViewOption": "sender",
                "ViewMarginX": 0 as CGFloat,
                "ViewMarginY": 0 as CGFloat,
                "ViewCustom": "",
                "Count": 2 as Float,
                "Delay": 0 as Double,
                "HapticFeedback": false,
                "SystemSound": 0 as UInt32
                ])

        case .Emojisplosion:
            return RewardSample.new(dict: [
                "RewardID": "EmojisplosionSample",
                "primitive": "Emojisplosion",
                "SystemSound": 1109 as UInt32,
                "HapticFeedback": true,
                "Delay": 0 as Double,
                "ViewCustom": "",
                "ViewMarginY": 0.5 as CGFloat,
                "ViewMarginX": 0.5 as CGFloat,
                "ViewOption": "sender",
                "AccelY": -150 as CGFloat,
                "AccelX": 0 as CGFloat,
                "ScaleSpeed": 0.2 as CGFloat,
                "ScaleRange": 0.2 as CGFloat,
                "Scale": 0.6 as CGFloat,
                "Bursts": 1 as Double,
                "FadeOut": -0.2 as Float,
                "Spin": 0 as CGFloat,
                "EmissionRange": 45 as CGFloat,
                "EmissionAngle": -90 as CGFloat,
                "LifetimeRange": 0.5 as Float,
                "Lifetime": 4 as Float,
                "Quantity": 6 as Float,
                "Velocity": -50 as CGFloat,
                "Content": "❤️"
                ])

        case .Glow:
            return RewardSample.new(dict: [
                "RewardID": "GlowSample",
                "primitive": "Glow",
                "Color": "#3DCF01",
                "Duration": 3 as Double,
                "Alpha": 0.7 as CGFloat,
                "Count": 2 as Float,
                "ViewOption": "fixed",
                "ViewMarginX": 0 as CGFloat,
                "ViewMarginY": 0 as CGFloat,
                "ViewCustom": "",
                "Delay": 0 as Double,
                "HapticFeedback": false,
                "SystemSound": 0 as UInt32
                ])

        case .Sheen:
            return RewardSample.new(dict: [
                "RewardID": "SheenSample",
                "primitive": "Sheen",
                "Duration": 2 as Double,
                "Color": "#FFFFFF",
                "Alpha": 0 as CGFloat,
                "ViewOption": "sender",
                "ViewMarginX": 0 as CGFloat,
                "ViewMarginY": 0 as CGFloat,
                "ViewCustom": "",
                "Delay": 0 as Double,
                "HapticFeedback": true,
                "SystemSound": 0 as UInt32
                ])

        case .Pulse:
            return RewardSample.new(dict: [
                "RewardID": "PulseSample",
                "primitive": "Pulse",
                "Duration": 0.86 as Double,
                "Count": 1 as Float,
                "Scale": 1.4 as CGFloat,
                "Velocity": 5 as CGFloat,
                "Damping": 2 as CGFloat,
                "ViewOption": "sender",
                "ViewMarginX": 0 as CGFloat,
                "ViewMarginY": 0 as CGFloat,
                "ViewCustom": "",
                "Delay": 0 as Double,
                "HapticFeedback": false,
                "SystemSound": 0 as UInt32
                ])

        case .Shimmy:
            return RewardSample.new(dict: [
                "RewardID": "ShimmySample",
                "primitive": "Shimmy",
                "Duration": 5 as Double,
                "Count": 2 as Float,
                "Translation": 10 as Int,
                "ViewOption": "sender",
                "ViewMarginX": 0 as CGFloat,
                "ViewMarginY": 0 as CGFloat,
                "ViewCustom": "",
                "Delay": 0 as Double,
                "HapticFeedback": true,
                "SystemSound": 0 as UInt32
                ])

        case .Vibrate:
            return RewardSample.new(dict: [
                "RewardID": "VibrateSample",
                "primitive": "Vibrate",
                "VibrateDuration": 1 as Double,
                "VibrateCount": 6 as Int,
                "VibrateTranslation": 10 as Int,
                "VibrateSpeed": 3 as Float,
                "Scale": 0.8 as CGFloat,
                "ScaleDuration": 0.3 as Double,
                "ScaleCount": 1 as Float,
                "ScaleVelocity": 20 as CGFloat,
                "ScaleDamping": 10 as CGFloat,
                "ViewOption": "fixed",
                "ViewMarginX": 0 as CGFloat,
                "ViewMarginY": 0 as CGFloat,
                "ViewCustom": "",
                "Delay": 0 as Double,
                "HapticFeedback": false,
                "SystemSound": 0 as UInt32
                ])
        }

    }
}
