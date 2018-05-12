//
//  FormColorCell.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftForms
import EFColorPicker

open class FormColorPickerCell: FormValueCell {
    
    var colorPickerNav: UINavigationController!
    let colorPicker = EFColorSelectionViewController()
    
    open override func configure() {
        super.configure()
        
        colorPickerNav = UINavigationController(rootViewController: colorPicker)
        colorPickerNav.navigationBar.backgroundColor = UIColor.lightGray
        colorPickerNav.navigationBar.isTranslucent = false
        colorPickerNav.modalPresentationStyle = UIModalPresentationStyle.popover
        colorPickerNav.popoverPresentationController?.delegate = self
        colorPickerNav.popoverPresentationController?.sourceView = self.contentView
        colorPickerNav.popoverPresentationController?.sourceRect = self.contentView.bounds
        colorPickerNav.preferredContentSize = colorPicker.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        let doneButton: UIBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("Done", comment: ""),
            style: UIBarButtonItemStyle.done,
            target: self,
            action: #selector(finishedPickingColor(sender:))
        )
        colorPicker.navigationItem.rightBarButtonItem = doneButton
    }
    
    open override func update() {
        super.update()
        
        titleLabel.text = rowDescriptor?.title
        
        if let selectedValue = rowDescriptor?.value {
            valueLabel.text = selectedValue.description
            if let hex = selectedValue as? String {
                colorPicker.color = UIColor.from(rgb: hex)
            }
        }
    }
    
    open override class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        guard let row = selectedRow as? FormColorPickerCell else { return }
        formViewController.present(row.colorPickerNav, animated: true)
    }
}

extension FormColorPickerCell : UIPopoverPresentationControllerDelegate {
    @objc func finishedPickingColor(sender: AnyObject) {
        let color = colorPicker.color
        colorPickerNav.dismiss(animated: true)
        rowDescriptor?.value = color.hexString as AnyObject
        valueLabel.text = color.hexString
    }
}
