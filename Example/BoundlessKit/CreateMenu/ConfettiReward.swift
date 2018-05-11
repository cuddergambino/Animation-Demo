//
//  ConfettiReward.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms
@testable import BoundlessKit

class ConfettiReward : RewardSettingsFormViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        rewardSettings = RewardSample.defaultSample(for: "ConfettiSample")!
        
        let form = FormDescriptor(title: "Confetti Settings")
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Duration.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Delay.formRow(rewardSettings.settings))
        
        form.sections = [saveSection, generalSection, basicViewSection, soundSection]
        self.form = form
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell
    }
}
