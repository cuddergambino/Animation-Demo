//
//  ConfettiForm.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms

class ConfettiForm : RewardForm {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        rewardSettings = RewardSample.defaultSample(for: "ConfettiSample")!
        self.form = generateForm()
    }
    
    override func generateForm() -> FormDescriptor {
        let form = FormDescriptor(title: "Confetti Settings")
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Duration.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Delay.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Color1.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Alpha1.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Color2.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Alpha2.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Color3.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Alpha3.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Amount.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Size.formRow(rewardSettings.settings))
        
        form.sections = [saveSection, generalSection, basicViewSection, soundSection]
        return form
    }
}
