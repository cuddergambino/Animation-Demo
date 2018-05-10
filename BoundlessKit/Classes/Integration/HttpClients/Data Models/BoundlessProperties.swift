//
//  BoundlessProperties.swift
//  BoundlessKit
//
//  Created by Akash Desai on 5/3/18.
//

import Foundation

internal struct BoundlessProperties {
    let credentials: BoundlessCredentials
    let version: BoundlessVersion
    
    static var fromFile: BoundlessProperties? {
        if let propertiesFile = Bundle.main.path(forResource: "BoundlessProperties", ofType: "plist"),
            let propertiesDictionary = NSDictionary(contentsOfFile: propertiesFile) as? [String: Any],
            let credentials = BoundlessCredentials.convert(from: propertiesDictionary) {
            return BoundlessProperties(credentials: credentials,
                                       version: BoundlessVersion.convert(from: propertiesDictionary) ?? BoundlessVersion())
        } else {
            return nil
        }
    }
}
