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
        
        rewardSettings = RewardSample.defaultSample(for: "EmojisplosionSample")!
        self.form = generateForm()
    }
    
    override func generateForm() -> FormDescriptor {
        
        let form = FormDescriptor(title: "Emojisplosion Settings")
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Content.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Bursts.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Delay.formRow(rewardSettings.settings))
        
        
        let repetitionSection = FormSectionDescriptor.init(headerTitle: "Repetition", footerTitle: nil)
        repetitionSection.rows.append(RewardParamKey.Quantity.formRow(rewardSettings.settings))
        repetitionSection.rows.append(RewardParamKey.Lifetime.formRow(rewardSettings.settings))
        repetitionSection.rows.append(RewardParamKey.LifetimeRange.formRow(rewardSettings.settings))
        repetitionSection.rows.append(RewardParamKey.FadeOut.formRow(rewardSettings.settings))
        
        
        let speedSection = FormSectionDescriptor.init(headerTitle: "Speed", footerTitle: nil)
        speedSection.rows.append(RewardParamKey.Velocity.formRow(rewardSettings.settings))
        speedSection.rows.append(RewardParamKey.AccelX.formRow(rewardSettings.settings))
        speedSection.rows.append(RewardParamKey.AccelY.formRow(rewardSettings.settings))
        speedSection.rows.append(RewardParamKey.Spin.formRow(rewardSettings.settings))
        speedSection.rows.append(RewardParamKey.EmissionAngle.formRow(rewardSettings.settings))
        speedSection.rows.append(RewardParamKey.EmissionRange.formRow(rewardSettings.settings))
        
        let placementSection = FormSectionDescriptor.init(headerTitle: "Placement", footerTitle: nil)
        placementSection.rows.append(RewardParamKey.ViewOption.formRow(rewardSettings.settings))
        placementSection.rows.append(RewardParamKey.ViewMarginX.formRow(rewardSettings.settings))
        placementSection.rows.append(RewardParamKey.ViewMarginY.formRow(rewardSettings.settings))
        placementSection.rows.append(RewardParamKey.Scale.formRow(rewardSettings.settings))
        placementSection.rows.append(RewardParamKey.ScaleSpeed.formRow(rewardSettings.settings))
        placementSection.rows.append(RewardParamKey.ScaleRange.formRow(rewardSettings.settings))
        
        form.sections = [saveSection, generalSection, repetitionSection, speedSection, placementSection, soundSection]
        return form
    }
    
}
