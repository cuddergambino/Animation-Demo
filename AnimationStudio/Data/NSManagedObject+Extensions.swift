//
//  NSManagedObject+Extensions.swift
//  AnimationStudio
//
//  Created by Akash Desai on 9/22/18.
//  Copyright © 2018 Boundless Mind. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension NSManagedObjectContext {

    func create<T: NSManagedObject>() -> T? {
        guard let entity = NSEntityDescription.entity(forEntityName: "\(T.self)", in: self) else {
            return nil
        }
        return T(entity: entity, insertInto: self)
    }

    func request<T: NSManagedObject>() -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: T.description())
    }

}
