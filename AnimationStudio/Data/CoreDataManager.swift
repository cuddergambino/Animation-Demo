//
//  CoreDataManager.swift
//  Sesame
//
//  Created by Akash Desai on 7/29/18.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {

    // MARK: - CoreData Objects

    private lazy var managedObjectModel: NSManagedObjectModel? = {
        if let modelURL = Bundle(for: type(of: self)).url(forResource: "AnimationStudio", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL) {
            return model
        }
        return nil
    }()

    private lazy var persistentStoreURL: URL? = {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            return dir.appendingPathComponent("AnimationStudio.sqlite")
        }
        return nil
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        if let model = managedObjectModel,
            let persistentStoreURL = persistentStoreURL {
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                   configurationName: nil,
                                                   at: persistentStoreURL,
                                                   options: [NSInferMappingModelAutomaticallyOption: true,
                                                             NSMigratePersistentStoresAutomaticallyOption: true])
                return coordinator
            } catch {
                BMLog.error(error)
            }
        }
        return nil
    }()

    private lazy var managedObjectContext: NSManagedObjectContext? = {
        if let coordinator = persistentStoreCoordinator {
            let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = coordinator
            managedObjectContext.mergePolicy = NSOverwriteMergePolicy
            // Setup notifications
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(saveChanges(_:)),
                                                   name: NSNotification.Name.UIApplicationDidEnterBackground,
                                                   object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(saveChanges(_:)),
                                                   name: NSNotification.Name.UIApplicationWillTerminate,
                                                   object: nil)
            return managedObjectContext
        }
        return nil
    }()

    func newContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedObjectContext
        return context
    }

    // MARK: - Save & Delete Methods

    @objc
    func saveChanges(_ notification: Notification?) {
        managedObjectContext?.perform {
            if self.managedObjectContext?.hasChanges ?? false {
                do {
                    try self.managedObjectContext?.save()
                } catch {
                    BMLog.error("\(error)")
                }
            }
        }
    }

    func save() {
        managedObjectContext?.performAndWait {
            if managedObjectContext?.hasChanges ?? false {
                do {
                    try managedObjectContext?.save()
                } catch {
                    BMLog.error("\(error)")
                }
            }
        }
    }

    func deleteObjects() {
        managedObjectContext?.performAndWait {
            let entities = [ConfettiParams.self,
                              EmojisplosionParams.self,
                              GlowParms.self,
                              PopoverParams.self,
                              PulseForm.self,
                              RotateParams.self,
                              SheenParams.self,
                              ShimmyParams.self,
                              VibrateForm.self
                              ]
            for entity in entities {
                let request = NSFetchRequest<NSManagedObject>(entityName: entity.description())
                do {
                    if let objects = try managedObjectContext?.fetch(request) {
                        for object in objects {
                            managedObjectContext?.delete(object)
                        }
                    }
                } catch {
                    BMLog.error(error)
                }
            }
            save()
        }
    }

}

extension Optional where Wrapped == String {
    var predicateValue: String {
        return self == nil ? "nil" : "'\(self!)'"
    }
}
