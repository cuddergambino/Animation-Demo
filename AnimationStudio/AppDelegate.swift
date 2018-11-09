//
//  AppDelegate.swift
//  BoundlessKit
//
//  Created by cuddergambino on 03/05/2018.
//  Copyright (c) 2018 cuddergambino. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        _ = SampleStruct.allSamples

        return true
    }

}
