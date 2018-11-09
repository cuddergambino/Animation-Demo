//
//  Sample.swift
//  AnimationStudio
//
//  Created by Akash Desai on 11/8/18.
//  Copyright © 2018 Boundless Mind. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Sample)
public class Sample: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var backgroundURL: URL?
    @NSManaged public var buttonFrameString: String?
    @NSManaged public var buttonImageString: String?
    @NSManaged public var effect: UXEffect?

    var buttonFrame: CGRect? {
        get {
            guard let buttonFrameString = buttonFrameString else {
                return nil
            }
            return CGRectFromString(buttonFrameString)
        }
        set {
            buttonFrameString = newValue == nil ? nil : NSStringFromCGRect(newValue!)
        }
    }

    var buttonImage: UIImage? {
        get {
            guard let buttonImageString = buttonImageString else {
                return nil
            }
            return UIImage.from(base64String: buttonImageString)
        }
        set {
            buttonImageString = newValue?.base64String
        }
    }

    var asDictionary: [String: Any] {
        var dict = [String: Any]()
        dict[RewardParamKey.RewardID.rawValue] = name
        dict[ImportedImageType.background.key] = backgroundURL
        dict[ImportedImageType.button.key + "-image"] = buttonImage
        dict[ImportedImageType.button.key + "-frame"] = buttonFrame
        if let effect = effect {
            dict[RewardParamKey.primitive.rawValue] = effect.name
            dict.merge(effect.attributes.map({($0.key, $0.value)}), uniquingKeysWith: {$1})
        }
        return dict
    }

    class func fetch(_ context: NSManagedObjectContext, name: String?) -> [Sample]? {
        var value: [Sample]?
        context.performAndWait {
            let request: NSFetchRequest<Sample> = context.request()
            if let name = name {
                request.predicate = NSPredicate(format: "\(#keyPath(Sample.name)) == '\(name)'")
            }
            do {
                value = try context.fetch(request)
            } catch {
                print(error)
            }
        }
        return value
    }

    class func insert(_ context: NSManagedObjectContext, dict: [String: Any]) -> Sample? {
        var value: Sample?
        var dict = dict
        context.performAndWait {
            if let name = dict.removeValue(forKey: RewardParamKey.RewardID.rawValue) as? String,
                let object: Sample = context.create() {

                object.name = name
                object.backgroundURL = dict[ImportedImageType.background.key] as? URL
                object.buttonImageString = dict[ImportedImageType.button.key + "-image"] as? String
                object.buttonFrameString = dict[ImportedImageType.button.key + "-frame"] as? String

                if let primitive = dict.removeValue(forKey: RewardParamKey.primitive.rawValue) as? String,
                    let effect: UXEffect = context.create() {
                    effect.name = primitive

                    for case let (key, value) in RewardParamKey.allCases
                        .map({($0.rawValue, dict.removeValue(forKey: $0.rawValue) as? NSObject)})
                        where value != nil {
                        if let object: UXEffectAttribute = context.create() {
                            object.key = key
                            object.value = value

                            effect.addToAttributes(object)
                        }
                    }

                    object.effect = effect
                }

                value = object
            }
        }
        return value
    }

    class func update(_ context: NSManagedObjectContext, dict: [String: Any]) -> Sample? {
        var value: Sample?
        context.performAndWait {
            if let name = dict[RewardParamKey.RewardID.rawValue] as? String,
                let objects = fetch(context, name: name) {
                for object in objects {
                    context.delete(object)
                }
            }
            value = insert(context, dict: dict)
        }
        return value
    }

}
