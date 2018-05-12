//
//  RotateReward.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms

class RotateReward : RewardForm {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        rewardSettings = RewardSample.defaultSample(for: "RotateSample")!
        self.form = generateForm()
    }
    
    override func generateForm() -> FormDescriptor {
        
        let form = FormDescriptor(title: "Rotate Settings")

        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Duration.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Delay.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Count.formRow(rewardSettings.settings))
        
        form.sections = [saveSection, generalSection, basicViewSection, soundSection]
        return form
    }
}
