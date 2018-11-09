//
//  UXEffectAttribute.swift
//  AnimationStudio
//
//  Created by Akash Desai on 11/8/18.
//  Copyright © 2018 Boundless Mind. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UXEffectAttribute)
public class UXEffectAttribute: NSManagedObject {

    @NSManaged public var key: String
    @NSManaged public var value: NSObject?
    @NSManaged public var effect: UXEffect

}
