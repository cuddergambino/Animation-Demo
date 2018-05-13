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
        print("Slider valu:\(sliderView.value)")
        valueView.text = String(format: "%.2f", sliderView.value)
        if rowDescriptor?.tag.contains("Alpha") ?? false {
            sliderView.tintColor = sliderView.tintColor.withAlphaComponent(CGFloat(sliderView.value))
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
