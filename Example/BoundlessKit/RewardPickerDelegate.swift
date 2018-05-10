//
//  RewardPickerDelegate.swift
//  To Do List
//
//  Created by Akash Desai on 6/14/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit

//static let newTaskRewardPickerDelegate = RewardPickerDelegate(type: .newTask)
class RewardPickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RewardPrimitive.cases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RewardPrimitive.cases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        label.font = UIFont(name: "Montserrat", size: UIFont.systemFontSize)
        label.textAlignment = .center
        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        label.backgroundColor = RewardPrimitive.colorForIndex(row)
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ParamsTableViewController.shared.curParams = ParamsTableViewController.shared.savedParams[RewardPrimitive.cases[row].rawValue]!
    }
    
}
