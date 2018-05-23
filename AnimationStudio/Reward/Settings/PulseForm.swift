//
//  PulseForm.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms

class PulseForm : RewardForm {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        reward = RewardSample.defaultSample(for: "PulseSample")!
        self.form = generateForm()
    }
    
    override func generateForm() -> FormDescriptor {
        
        let form = FormDescriptor(title: "Pulse Settings")
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Duration.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Delay.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Count.formRow(reward.settings))
        
        let movementSection = FormSectionDescriptor(headerTitle: "Movement", footerTitle: nil)
        movementSection.rows.append(RewardParamKey.Scale.formRow(reward.settings))
        movementSection.rows.append(RewardParamKey.Velocity.formRow(reward.settings))
        movementSection.rows.append(RewardParamKey.Count.formRow(reward.settings))
        
        form.sections = [saveSection, generalSection, movementSection, basicViewSection, soundSection]
        return form
    }
}
