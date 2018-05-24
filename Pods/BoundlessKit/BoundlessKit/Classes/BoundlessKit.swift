//
//  BoundlessKit.swift
//  BoundlessKit
//
//  Created by Akash Desai on 4/7/16.
//  Copyright © 2018 Boundless Mind. All rights reserved.
//

import Foundation

open class BoundlessKit : NSObject {
    internal static var _standard: BoundlessKit?
    open class var standard: BoundlessKit {
        guard _standard == nil else {
            return _standard!
        }
        _standard = BoundlessKit()
        return _standard!
    }
    
    internal let apiClient: BoundlessAPIClient
    
    init(apiClient: BoundlessAPIClient) {
        self.apiClient = apiClient
        super.init()
    }
    
    public convenience override init() {
        guard let properties = BoundlessProperties.fromFile(using: BKUserDefaults.standard) else {
            fatalError("Missing <BoundlessProperties.plist> file")
        }
        self.init(apiClient: BoundlessAPIClient(credentials: properties.credentials, version: properties.version))
    }
    
    @objc
    open func track(actionID: String, metadata: [String: Any] = [:]) {
        let action = BKAction(actionID, metadata)
        apiClient.version.trackBatch.store(action)
        apiClient.syncIfNeeded()
    }
    
    @objc
    open func reinforce(actionID: String, metadata: [String: Any] = [:], completion: @escaping (String)->Void) {
        apiClient.version.refreshContainer.decision(forActionID: actionID) { reinforcementDecision in
            let reinforcement = BKReinforcement(reinforcementDecision, metadata)
            completion(reinforcement.name)
            self.apiClient.version.reportBatch.store(reinforcement)
            self.apiClient.syncIfNeeded()
        }
    }
}

extension BoundlessKit {
    /// Set a custom identity for Boundless
    ///
    /// - Parameters:
    ///   - id: A non-empty string that is less than 36 characters and only contains alphanumerics or dashes. If an invalid string is passed, one will be genereated using the UUID class.
    ///   - completion: An optional callback with the latest user id and experiment group
    @objc
    open func setCustomUserId(_ id: String, completion: ((String, String?) -> ())? = nil) {
        apiClient.setCustomUserIdentity(id, completion: completion)
    }
    
    @objc
    open func getUserId() -> String {
        return apiClient.credentials.user.id
    }
    
    @objc
    open func getUserExperimentGroup() -> String? {
        return apiClient.credentials.user.experimentGroup
    }
}

extension BoundlessKit {
    @objc
    open class func track(actionID: String, metadata: [String: Any] = [:]) {
        standard.track(actionID: actionID, metadata: metadata)
    }
    
    @objc
    open class func reinforce(actionID: String, metadata: [String: Any] = [:], completion: @escaping (String)->Void) {
        standard.reinforce(actionID: actionID, metadata: metadata, completion: completion)
    }
}
