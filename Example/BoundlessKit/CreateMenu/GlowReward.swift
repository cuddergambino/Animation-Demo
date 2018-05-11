//
//  GlowReward.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import SwiftForms
@testable import BoundlessKit

class GlowReward : RewardSettingsFormViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        rewardSettings = RewardSample.load(rewardID: "GlowSample") ?? RewardSample.defaultSample(for: "GlowSample")!
        
        let form = FormDescriptor(title: "Glow Settings")
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Duration.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Delay.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Count.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Alpha.formRow(rewardSettings.settings))
        
        form.sections = [saveSection, generalSection, basicViewSection]
        self.form = form
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell
    }
}