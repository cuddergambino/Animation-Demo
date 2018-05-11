//
//  VibrateReward.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms
@testable import BoundlessKit

class VibrateReward : RewardSettingsFormViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        rewardSettings = RewardSample.defaultSample(for: "VibrateSample")!
        
        let form = FormDescriptor(title: "Vibrate Settings")
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Delay.formRow(rewardSettings.settings))
        
        let shakeSection = FormSectionDescriptor(headerTitle: "Shake", footerTitle: nil)
        shakeSection.rows.append(RewardParamKey.VibrateDuration.formRow(rewardSettings.settings))
        shakeSection.rows.append(RewardParamKey.VibrateCount.formRow(rewardSettings.settings))
        shakeSection.rows.append(RewardParamKey.VibrateTranslation.formRow(rewardSettings.settings))
        shakeSection.rows.append(RewardParamKey.VibrateSpeed.formRow(rewardSettings.settings))
        
        let scaleSection = FormSectionDescriptor(headerTitle: "Scale", footerTitle: nil)
        scaleSection.rows.append(RewardParamKey.Scale.formRow(rewardSettings.settings))
        scaleSection.rows.append(RewardParamKey.ScaleDuration.formRow(rewardSettings.settings))
        scaleSection.rows.append(RewardParamKey.ScaleCount.formRow(rewardSettings.settings))
        scaleSection.rows.append(RewardParamKey.ScaleVelocity.formRow(rewardSettings.settings))
        scaleSection.rows.append(RewardParamKey.ScaleDamping.formRow(rewardSettings.settings))
        
        form.sections = [saveSection, generalSection, shakeSection, scaleSection, basicViewSection, soundSection]
        self.form = form
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell
    }
}
