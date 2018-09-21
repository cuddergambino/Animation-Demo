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

// note: in FormPickerCell, change selectedValue === AnyObject to include comparing string descriptions for proper initial picked value
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

                if let tag = rowDescriptor?.tag,
                    tag.contains("Color"),
                    let sections = formViewController?.form.sections {
                    let alphaRowTag = tag.replacingOccurrences(of: "Color", with: "Alpha")
                    for sec in 0 ... sections.count - 1 {
                        for row in 0 ... sections[sec].rows.count - 1 {
                            if sections[sec].rows[row].tag == alphaRowTag,
                                let cell = formViewController?.tableView.cellForRow(at: IndexPath(row: row, section: sec)) as? FormLabeledSliderCell {
                                cell.sliderView.tintColor = color.withAlphaComponent(CGFloat(cell.sliderView.value))
                                break
                            }
                        }
                    }
                }
            }
        }
    }

    open override class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        guard let row = selectedRow as? FormColorPickerCell else { return }
        formViewController.present(row.colorPickerNav, animated: true)
    }
}

extension FormColorPickerCell: UIPopoverPresentationControllerDelegate {
    @objc func finishedPickingColor(sender: AnyObject) {
        colorPickerNav.dismiss(animated: true)
        rowDescriptor?.value = colorPicker.color.rgb as AnyObject
        update()
    }
}
