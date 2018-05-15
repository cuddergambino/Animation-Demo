////
////  FormPickerCellFixed.swift
////  AnimationStudio
////
////  Created by Akash Desai on 5/15/18.
////  Copyright © 2018 Boundless Mind. All rights reserved.
////
//
//import Foundation
//import SwiftForms
//
//class FormPickerCellFixed : FormPickerCell {
//    open override func update() {
//        super.update()
//        if let selectedValue = rowDescriptor?.value {
//            valueLabel.text = rowDescriptor?.configuration.selection.optionTitleClosure?(selectedValue)
//            if let options = rowDescriptor?.configuration.selection.options , !options.isEmpty {
//                var selectedIndex: Int?
//                for (index, value) in options.enumerated() {
//                    if value === selectedValue {
//                        selectedIndex = index
//                        break
//                    }
//                }
//                
//                if let index = selectedIndex {
//                    picker.selectRow(index, inComponent: 0, animated: false)
//                }
//            }
//        }
//    }
//}
//
