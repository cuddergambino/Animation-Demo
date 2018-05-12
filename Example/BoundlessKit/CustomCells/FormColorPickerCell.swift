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
        let noneButton: UIBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("None", comment: ""),
            style: UIBarButtonItemStyle.done,
            target: self,
            action: #selector(finishedPickingColor(sender:))
        )
        colorPicker.navigationItem.leftBarButtonItem = noneButton
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
        rowDescriptor?.value = color.rgb as AnyObject
        valueLabel.text = color.rgb
    }
    @objc func finishedPickingColorNone(sender: AnyObject) {
        colorPickerNav.dismiss(animated: true)
        rowDescriptor?.value = "" as AnyObject
        valueLabel.text = ""
    }
}


public extension UIColor {
    
    var rgba: String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgba:Int = (Int)(r*255)<<24 | (Int)(g*255)<<16 | (Int)(b*255)<<8 | (Int)(a*255)<<0
        
        return String(format:"#%08x", rgba).uppercased()
    }
    
    var rgb: String {
        return String(rgba.dropLast(2))
    }
    
    /// This function takes a hex string and alpha value and returns its UIColor
    ///
    /// - parameters:
    ///     - rgb: A hex string with either format `"#ffffff"` or `"ffffff"` or `"#FFFFFF"`.
    ///     - alpha: The alpha value to apply to the color, default is 1.0 for opaque
    ///
    /// - returns:
    ///     The corresponding UIColor for valid hex strings, `UIColor.grayColor()` otherwise.
    ///
    class func from(rgba: String) -> UIColor? {
        var colorString:String = rgba.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (colorString.hasPrefix("#")) {
            colorString.removeFirst()
        }
        
        if colorString.count == 6 {
            colorString += "FF"
        } else if colorString.count != 8 {
            return nil
        }
        
        var rgbaValue:UInt32 = 0
        Scanner(string: colorString).scanHexInt32(&rgbaValue)
        
        return UIColor(
            red: CGFloat((rgbaValue & 0xFF000000) >> 24) / 255.0,
            green: CGFloat((rgbaValue & 0x00FF0000) >> 16) / 255.0,
            blue: CGFloat((rgbaValue & 0x0000FF00) >> 8) / 255.0,
            alpha: CGFloat(rgbaValue & 0x000000FF) / 255.0
        )
    }
    
    class func from(rgb: String, alpha: CGFloat = 1.0) -> UIColor? {
        return UIColor.from(rgba: rgb).withAlphaComponent(alpha)
    }
}
