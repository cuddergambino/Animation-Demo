//
//  GlowReward.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms
import BoundlessKit
import EFColorPicker

class GlowReward : RewardSettingsFormViewController {
    
    var selectedColor = UIColor.green
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        rewardSettings = RewardSample.defaultSample(for: "GlowSample")!
        self.form = generateForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.form = generateForm()
        super.viewWillAppear(animated)
    }
    
    override func generateForm() -> FormDescriptor {
        
        let form = FormDescriptor(title: "Glow Settings")
        
        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Duration.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Delay.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Count.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Color.formRow(rewardSettings.settings))
        generalSection.rows.append(RewardParamKey.Alpha.formRow(rewardSettings.settings))
        
        form.sections = [saveSection, generalSection, basicViewSection, soundSection]
        return form
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell
    }
}

extension GlowReward : EFColorSelectionViewControllerDelegate {
    func colorViewController(colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        self.selectedColor = color
        print("COlor hex:\(color.hexString)")
        self.rewardSettings.settings[RewardParamKey.Color.rawValue] = color.hexString
    }
}
