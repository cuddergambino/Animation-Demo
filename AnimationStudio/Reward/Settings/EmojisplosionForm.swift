//
//  EmojisplosionForm.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms


class EmojisplosionForm : RewardForm {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        reward = RewardSample.defaultSample(for: .Emojisplosion)
        self.form = generateForm()
    }
    
    override func generateForm() -> FormDescriptor {
        
        let form = FormDescriptor(title: "Emojisplosion Settings")
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Content.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Bursts.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Delay.formRow(reward.settings))
        
        
        let repetitionSection = FormSectionDescriptor.init(headerTitle: "Repetition", footerTitle: nil)
        repetitionSection.rows.append(RewardParamKey.Quantity.formRow(reward.settings))
        repetitionSection.rows.append(RewardParamKey.Lifetime.formRow(reward.settings))
        repetitionSection.rows.append(RewardParamKey.LifetimeRange.formRow(reward.settings))
        repetitionSection.rows.append(RewardParamKey.FadeOut.formRow(reward.settings))
        
        
        let speedSection = FormSectionDescriptor.init(headerTitle: "Speed", footerTitle: nil)
        speedSection.rows.append(RewardParamKey.Velocity.formRow(reward.settings))
        speedSection.rows.append(RewardParamKey.AccelX.formRow(reward.settings))
        speedSection.rows.append(RewardParamKey.AccelY.formRow(reward.settings))
        speedSection.rows.append(RewardParamKey.Spin.formRow(reward.settings))
        speedSection.rows.append(RewardParamKey.EmissionAngle.formRow(reward.settings))
        speedSection.rows.append(RewardParamKey.EmissionRange.formRow(reward.settings))
        
        let placementSection = FormSectionDescriptor.init(headerTitle: "Placement", footerTitle: nil)
        placementSection.rows.append(RewardParamKey.ViewOption.formRow(reward.settings))
        placementSection.rows.append(RewardParamKey.ViewMarginX.formRow(reward.settings))
        placementSection.rows.append(RewardParamKey.ViewMarginY.formRow(reward.settings))
        placementSection.rows.append(RewardParamKey.Scale.formRow(reward.settings))
        placementSection.rows.append(RewardParamKey.ScaleSpeed.formRow(reward.settings))
        placementSection.rows.append(RewardParamKey.ScaleRange.formRow(reward.settings))
        
        form.sections = [saveSection, generalSection, repetitionSection, speedSection, placementSection, soundSection]
        return form
    }
    
}
