//
//  SavedSamples.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms

class SavedSamples : FormViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let form = FormDescriptor(title: "Saved Reward Settings")
        
        let listSection = FormSectionDescriptor(headerTitle: "Names", footerTitle: nil)
        
        for name in Array(RewardSample.samples.keys).sorted(by: <) {
            let row = FormRowDescriptor(tag: RewardParamKey.RewardID.rawValue, type: .button, title: name)
            row.configuration.button.didSelectClosure = { _ in
                RewardSample.current = RewardSample.samples[name] ?? RewardSample.current
                self.navigationController?.popViewController(animated: true)
            }
            listSection.rows.append(row)
        }
        
        form.sections = [listSection]
        self.form = form
    }
}
