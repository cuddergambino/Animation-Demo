//
//  PulseReward.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms
@testable import BoundlessKit

class PulseReward : RewardForm {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        rewardSettings = RewardSample.defaultSample(for: "PulseSample")!
        self.form = generateForm()
    }
    
    override func generateForm() -> FormDescriptor {
        
        let form = FormDescriptor(title: "Pulse Settings")
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Duration.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Delay.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Count.formRow(rewardSettings.settings))
        
        let movementSection = FormSectionDescriptor(headerTitle: "Movement", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Scale.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Velocity.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Count.formRow(rewardSettings.settings))
        
        form.sections = [saveSection, generalSection, movementSection, basicViewSection, soundSection]
        return form
    }
}
