//
//  Sample+Extensions.swift
//  AnimationStudio
//
//  Created by Akash Desai on 11/6/18.
//  Copyright © 2018 Boundless Mind. All rights reserved.
//

import Foundation
import CoreData

extension Sample {

    @discardableResult
    class func insertBeginner(context: NSManagedObjectContext) -> [Sample] {
        var samples = [Sample]()
        context.performAndWait {
            if let sample: Sample = context.create(),
                let param1: UXRotateParams  = context.create() {

                param1.count = 2
                sample.addToUxParams(param1)

                samples.append(sample)
            }
        }
        return samples
    }

}
