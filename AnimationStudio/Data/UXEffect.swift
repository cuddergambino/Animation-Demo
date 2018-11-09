//
//  UXEffect.swift
//  AnimationStudio
//
//  Created by Akash Desai on 11/8/18.
//  Copyright © 2018 Boundless Mind. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UXEffect)
public class UXEffect: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var attributes: Set<UXEffectAttribute>
    @NSManaged public var sample: Sample

    // MARK: Generated accessors for attributes
    @objc(addAttributesObject:)
    @NSManaged public func addToAttributes(_ value: UXEffectAttribute)

    @objc(removeAttributesObject:)
    @NSManaged public func removeFromAttributes(_ value: UXEffectAttribute)

    @objc(addAttributes:)
    @NSManaged public func addToAttributes(_ values: NSSet)

    @objc(removeAttributes:)
    @NSManaged public func removeFromAttributes(_ values: NSSet)

}
