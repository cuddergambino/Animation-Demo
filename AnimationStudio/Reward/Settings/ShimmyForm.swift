//
//  ShimmyForm.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms

class ShimmyForm: RewardForm {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reward = SampleStruct.defaultSample(for: .Shimmy)
        self.form = generateForm()
    }

    override func generateForm() -> FormDescriptor {
        let form = FormDescriptor(title: "Shimmy Settings")

        let generalSection = FormSectionDescriptor(headerTitle: "General", footerTitle: nil)
        generalSection.rows.append(RewardParamKey.Duration.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Count.formRow(reward.settings))
        generalSection.rows.append(RewardParamKey.Translation.formRow(reward.settings))

        form.sections = [saveSection, generalSection, basicViewSection, soundSection]
        return form
    }
}
