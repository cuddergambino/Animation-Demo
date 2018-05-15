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
            title: NSLocalizedString("Select", comment: ""),
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
            if let hex = selectedValue as? String,
                let color = UIColor.from(rgb: hex) {
                colorPicker.color = color
            }
        }
    }
    
    var tempFormController: FormViewController?
    open override class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        guard let row = selectedRow as? FormColorPickerCell else { return }
        formViewController.present(row.colorPickerNav, animated: true)
        
        row.tempFormController = formViewController
    }
}

extension FormColorPickerCell : UIPopoverPresentationControllerDelegate {
    @objc func finishedPickingColor(sender: AnyObject) {
        let color = colorPicker.color
        colorPickerNav.dismiss(animated: true)
        rowDescriptor?.value = color.rgb as AnyObject
        valueLabel.text = color.rgb
        
        if rowDescriptor?.tag.contains("Color") ?? false {
            switch rowDescriptor?.tag {
            case "Color"?:
                FormLabeledSliderCell.alpha?.sliderView.tintColor = color
            case "Color1"?:
                FormLabeledSliderCell.alpha1?.sliderView.tintColor = color
            case "Color2"?:
                FormLabeledSliderCell.alpha2?.sliderView.tintColor = color
            case "Color3"?:
                FormLabeledSliderCell.alpha3?.sliderView.tintColor = color
            default: break
            }
        }
    }
}

