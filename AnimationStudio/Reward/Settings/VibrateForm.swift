//
//  VibrateForm.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms

class VibrateForm : RewardForm {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        reward = RewardSample.defaultSample(for: "VibrateSample")!
        self.form = generateForm()
    }
    
    override func generateForm() -> FormDescriptor {
        
        let form = FormDescriptor(title: "Vibrate Settings")
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Delay.formRow(reward.settings))
        
        let shakeSection = FormSectionDescriptor(headerTitle: "Shake", footerTitle: nil)
        shakeSection.rows.append(RewardParamKey.VibrateDuration.formRow(reward.settings))
        shakeSection.rows.append(RewardParamKey.VibrateCount.formRow(reward.settings))
        shakeSection.rows.append(RewardParamKey.VibrateTranslation.formRow(reward.settings))
        shakeSection.rows.append(RewardParamKey.VibrateSpeed.formRow(reward.settings))
        
        let scaleSection = FormSectionDescriptor(headerTitle: "Scale", footerTitle: nil)
        scaleSection.rows.append(RewardParamKey.Scale.formRow(reward.settings))
        scaleSection.rows.append(RewardParamKey.ScaleDuration.formRow(reward.settings))
        scaleSection.rows.append(RewardParamKey.ScaleCount.formRow(reward.settings))
        scaleSection.rows.append(RewardParamKey.ScaleVelocity.formRow(reward.settings))
        scaleSection.rows.append(RewardParamKey.ScaleDamping.formRow(reward.settings))
        
        form.sections = [saveSection, generalSection, shakeSection, scaleSection, basicViewSection, soundSection]
        return form
    }
}
