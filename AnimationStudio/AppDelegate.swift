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

    var coredata: CoreDataManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        coredata = CoreDataManager()

        let context = coredata.newContext()
        context.performAndWait {

            guard let entity = NSEntityDescription.entity(forEntityName: EmojisplosionParams.description(), in: context) else { return }
            let popoverParams = EmojisplosionParams(entity: entity, insertInto: context)
            popoverParams.rewardId = "test"
            context.insert(popoverParams)
            do {
                try context.save()
            } catch {
                BMLog.error(error)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let context = self.coredata.newContext()
            context.performAndWait {
                var params: EmojisplosionParams?
                let request = NSFetchRequest<EmojisplosionParams>(entityName: EmojisplosionParams.description())
                do {
                    BMLog.warning("Count:\(try context.count(for: request))")
                    params = try context.fetch(request).first
                } catch { BMLog.error(error) }

                if let params = params {
                    self.window?.showEmojiSplosion(at: self.window!.bounds
                        .pointWithMargins(x: CGFloat(params.viewMargin![0]),
                                          y: CGFloat(params.viewMargin![1])),
                                               content: params.content!.utf8Decoded().image().cgImage,
                                               scale: CGFloat(params.scaleMean),
                                               scaleSpeed: CGFloat(params.scaleSpeed),
                                               scaleRange: CGFloat(params.scaleNoise),
                                               lifetime: params.lifetime,
                                               lifetimeRange: params.lifetimeNoise,
                                               fadeout: params.fade,
                                               quantity: Float(params.rate),
                                               bursts: params.duration,
                                               velocity: CGFloat(params.velocity),
                                               xAcceleration: CGFloat(params.acceleration![0]),
                                               yAcceleration: CGFloat(params.acceleration![1]),
                                               angle: CGFloat(params.angle),
                                               range: CGFloat(params.range),
                                               spin: CGFloat(params.spin),
                                               hapticFeedback: params.hapticFeedback,
                                               systemSound: UInt32(params.systemSound))
//                self.window?.showPopover(content: (e.content! as NSString).utf8Decoded()
//                    .image(font: .systemFont(ofSize: CGFloat(popoverParams.fontSize))),
//                                         duration: popoverParams.duration,
//                                         style: popoverParams.dark ? .dark : .light,
//                                         hapticFeedback: popoverParams.hapticFeedback,
//                                         systemSound: UInt32(popoverParams.systemSound))
                }}
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
