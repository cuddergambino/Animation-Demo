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
        
        reward = RewardSample.defaultSample(for: .Confetti)
        self.form = generateForm()
    }
    
    override func generateForm() -> FormDescriptor {
        let form = FormDescriptor(title: "Confetti Settings")
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Duration.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Delay.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Color1.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Alpha1.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Color2.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Alpha2.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Color3.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Alpha3.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Amount.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Size.formRow(reward.settings))
        
        form.sections = [saveSection, generalSection, basicViewSection, soundSection]
        return form
    }
}
