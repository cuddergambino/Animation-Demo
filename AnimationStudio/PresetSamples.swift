//
//  PresetSamples.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

extension RewardSample {

    static var presets: [RewardSample] = {
        return [
            RewardSample.new(dict: [
                "RewardID": "Hello There",
                "primitive": "Emojisplosion",
                "SystemSound": 1010,
                "HapticFeedback": true,
                "Delay": 0,
                "ViewCustom": "",
                "ViewMarginY": 0.5,
                "ViewMarginX": 0.5,
                "ViewOption": "sender",
                "AccelY": -150,
                "AccelX": 0,
                "ScaleSpeed": 0.2,
                "ScaleRange": 0.2,
                "Scale": 0.6,
                "Bursts": 1,
                "FadeOut": -0.2,
                "Spin": 0,
                "EmissionRange": 45,
                "EmissionAngle": -90,
                "LifetimeRange": 0.5,
                "Lifetime": 2,
                "Quantity": 2,
                "Velocity": -50,
                "Content": "🖐"
                ]),

            RewardSample.new(dict: [
                "RewardID": "Confetti Surprise",
                "primitive": "Confetti",
                "Duration": 2,
                "Color1": "#FB3247",
                "Alpha1": 0.8,
                "Color2": "#F5FB61",
                "Alpha2": 0.8,
                "Color3": "#9243F9",
                "Alpha3": 0.8,
                "Amount": 4,
                "Size": 9,
                "ViewOption": "fixed",
                "ViewMarginX": 0,
                "ViewMarginY": 0,
                "ViewCustom": "",
                "Delay": 0,
                "HapticFeedback": false,
                "SystemSound": 0
                ]),

            RewardSample.new(dict: [
                "RewardID": "Rotate Preset",
                "primitive": "Rotate",
                "Duration": 1,
                "ViewOption": "sender",
                "ViewMarginX": 0,
                "ViewMarginY": 0,
                "ViewCustom": "",
                "Count": 2,
                "Delay": 0,
                "HapticFeedback": false,
                "SystemSound": 1016
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
                "FontSize": 24,
                "Duration": 3,
                "Dark": false,
                "ViewOption": "fixed",
                "ViewMarginX": 0,
                "ViewMarginY": 0,
                "ViewCustom": "",
                "Delay": 0,
                "HapticFeedback": false,
                "SystemSound": 0
                ])

        case .Confetti:
            return RewardSample.new(dict: [
                "RewardID": "ConfettiSample",
                "primitive": "Confetti",
                "Duration": 2,
                "Color1": "#4d81fb",
                "Alpha1": 0.8,
                "Color2": "#4ac4fb",
                "Alpha2": 0.8,
                "Color3": "#9243f9",
                "Alpha3": 0.8,
                "Amount": 4,
                "Size": 9,
                "ViewOption": "fixed",
                "ViewMarginX": 0,
                "ViewMarginY": 0,
                "ViewCustom": "",
                "Delay": 0,
                "HapticFeedback": false,
                "SystemSound": 0
                ])

        case .Rotate:
            return RewardSample.new(dict: [
                "RewardID": "RotateSample",
                "primitive": "Rotate",
                "Duration": 1,
                "ViewOption": "sender",
                "ViewMarginX": 0,
                "ViewMarginY": 0,
                "ViewCustom": "",
                "Count": 2,
                "Delay": 0,
                "HapticFeedback": false,
                "SystemSound": 0
                ])

        case .Emojisplosion:
            return RewardSample.new(dict: [
                "RewardID": "EmojisplosionSample",
                "primitive": "Emojisplosion",
                "SystemSound": 1109,
                "HapticFeedback": true,
                "Delay": 0,
                "ViewCustom": "",
                "ViewMarginY": 0.5,
                "ViewMarginX": 0.5,
                "ViewOption": "sender",
                "AccelY": -150,
                "AccelX": 0,
                "ScaleSpeed": 0.2,
                "ScaleRange": 0.2,
                "Scale": 0.6,
                "Bursts": 1,
                "FadeOut": -0.2,
                "Spin": 0,
                "EmissionRange": 45,
                "EmissionAngle": -90,
                "LifetimeRange": 0.5,
                "Lifetime": 4,
                "Quantity": 6,
                "Velocity": -50,
                "Content": "❤️"
                ])

        case .Glow:
            return RewardSample.new(dict: [
                "RewardID": "GlowSample",
                "primitive": "Glow",
                "Color": "#3DCF01",
                "Duration": 3,
                "Alpha": 0.7,
                "Count": 2,
                "Radius": 0,
                "ViewOption": "fixed",
                "ViewMarginX": 0,
                "ViewMarginY": 0,
                "ViewCustom": "",
                "Delay": 0,
                "HapticFeedback": false,
                "SystemSound": 0
                ])

        case .Sheen:
            return RewardSample.new(dict: [
                "RewardID": "SheenSample",
                "primitive": "Sheen",
                "Duration": 2,
                "Color": "#FFFFFF",
                "Alpha": 0,
                "ViewOption": "sender",
                "ViewMarginX": 0,
                "ViewMarginY": 0,
                "ViewCustom": "",
                "Delay": 0,
                "HapticFeedback": true,
                "SystemSound": 0
                ])

        case .Pulse:
            return RewardSample.new(dict: [
                "RewardID": "PulseSample",
                "primitive": "Pulse",
                "Duration": 0.86,
                "Count": 1,
                "Scale": 1.4,
                "Velocity": 5,
                "Damping": 2,
                "ViewOption": "sender",
                "ViewMarginX": 0,
                "ViewMarginY": 0,
                "ViewCustom": "",
                "Delay": 0,
                "HapticFeedback": false,
                "SystemSound": 0
                ])

        case .Shimmy:
            return RewardSample.new(dict: [
                "RewardID": "ShimmySample",
                "primitive": "Shimmy",
                "Duration": 5,
                "Count": 2,
                "Translation": 10,
                "ViewOption": "sender",
                "ViewMarginX": 0,
                "ViewMarginY": 0,
                "ViewCustom": "",
                "Delay": 0,
                "HapticFeedback": true,
                "SystemSound": 0
                ])

        case .Vibrate:
            return RewardSample.new(dict: [
                "RewardID": "VibrateSample",
                "primitive": "Vibrate",
                "VibrateDuration": 1,
                "VibrateCount": 6,
                "VibrateTranslation": 10,
                "VibrateSpeed": 3,
                "Scale": 0.8,
                "ScaleDuration": 0.3,
                "ScaleCount": 1,
                "ScaleVelocity": 20,
                "ScaleDamping": 10,
                "ViewOption": "fixed",
                "ViewMarginX": 0,
                "ViewMarginY": 0,
                "ViewCustom": "",
                "Delay": 0,
                "HapticFeedback": false,
                "SystemSound": 0
                ])
        }

    }
}
