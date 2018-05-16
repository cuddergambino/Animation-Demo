//
//  FormLabeledSliderCell.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SwiftForms

open class FormLabeledSliderCell: FormSliderCell {
    
    static var alpha: FormLabeledSliderCell?
    static var alpha1: FormLabeledSliderCell?
    static var alpha2: FormLabeledSliderCell?
    static var alpha3: FormLabeledSliderCell?
    
    @objc public let valueView = UILabel()
    
    // MARK: FormBaseCell
    
    open override func configure() {
        super.configure()
        valueView.translatesAutoresizingMaskIntoConstraints = false
        valueView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        contentView.addSubview(valueView)
        sliderView.addTarget(self, action: #selector(FormLabeledSliderCell.valueChanged2(_:)), for: .valueChanged)
    }
    
    open override func update() {
        super.update()
        valueView.text = String(format: "%.2f", sliderView.value)
        if rowDescriptor?.tag.contains("Alpha") ?? false {
            sliderView.tintColor = sliderView.tintColor.withAlphaComponent(CGFloat(sliderView.value))
            switch rowDescriptor?.tag {
            case "Alpha"?:
                FormLabeledSliderCell.alpha = self
            case "Alpha1"?:
                FormLabeledSliderCell.alpha1 = self
            case "Alpha2"?:
                FormLabeledSliderCell.alpha2 = self
            case "Alpha3"?:
                FormLabeledSliderCell.alpha3 = self
            default: break
            }
        }
    }
    
    open override func constraintsViews() -> [String : UIView] {
        return ["titleLabel" : titleLabel, "sliderView" : sliderView, "valueView" : valueView]
    }
    
    open override func defaultVisualConstraints() -> [String] {
        var constraints: [String] = []
        
        constraints.append("V:|[valueView]|")
        constraints.append("H:|-16-[titleLabel]-16-[sliderView]-16-[valueView]-16-|")
        
        return constraints
    }
    
    // MARK: Actions
    
    @objc internal func valueChanged2(_: UISlider) {
        valueView.text = String(format: "%.2f", sliderView.value)
    }
}
