//
//  PresetSamplesViewController.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms

class PresetSamplesViewController : FormViewController {
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = self.form.sections[indexPath.section].rows.remove(at: indexPath.row)
            let name = row.title!
            RewardSample.delete(rewardID: name)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}
