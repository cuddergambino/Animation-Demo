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
    
//    var selectedColor: UIColor = .purple
    let colorPicker = EFColorSelectionViewController()
    var colorPickerNav: UINavigationController!
    
    open override func configure() {
        super.configure()
//        colorPicker.delegate = self
        colorPicker.color = .lightGray
        accessoryType = .none
        colorPickerNav = UINavigationController(rootViewController: colorPicker)
        colorPickerNav.navigationBar.backgroundColor = UIColor.lightGray
        colorPickerNav.navigationBar.isTranslucent = false
        colorPickerNav.modalPresentationStyle = UIModalPresentationStyle.popover
        colorPickerNav.popoverPresentationController?.delegate = self
        colorPickerNav.popoverPresentationController?.sourceView = self.contentView
        colorPickerNav.popoverPresentationController?.sourceRect = self.contentView.bounds
        colorPickerNav.preferredContentSize = colorPicker.view.systemLayoutSizeFitting(
            UILayoutFittingCompressedSize
        )
        
        let doneBtn: UIBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("Done", comment: ""),
            style: UIBarButtonItemStyle.done,
            target: self,
            action: #selector(finishedSelectingColor(sender:))
        )
        colorPicker.navigationItem.rightBarButtonItem = doneBtn
    }
    
    open override func update() {
        super.update()
        titleLabel.text = rowDescriptor?.title
        if let selectedValue = rowDescriptor?.value as? String{
            valueLabel.text = selectedValue
        }
    }

    open override class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        guard let row = selectedRow as? FormColorPickerCell else { return }
        
        if let colorHex = row.rowDescriptor?.value as? String {
            row.colorPicker.color = UIColor.from(rgb: colorHex)
        }
        formViewController.present(row.colorPickerNav, animated: true)
    }
    
    
}

extension FormColorPickerCell {
    @objc func finishedSelectingColor(sender: AnyObject) {
        print("Colorpicker color value:\(colorPicker.color)")
        colorPickerNav.dismiss(animated: true)
        print("Row value:\(rowDescriptor?.value)")
        rowDescriptor?.value = colorPicker.color.hexString as AnyObject
        valueLabel.text = colorPicker.color.hexString
        print("New row key:\(rowDescriptor?.tag) value:\(rowDescriptor?.value)")
    }
    
//     : EFColorSelectionViewControllerDelegate
//    public func colorViewController(colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
//        selectedColor = color
//    }
}

extension FormColorPickerCell : UIPopoverPresentationControllerDelegate {
    
}
