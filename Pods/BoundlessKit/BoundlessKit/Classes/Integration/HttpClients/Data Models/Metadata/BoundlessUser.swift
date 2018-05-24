//
//  BoundlessUser.swift
//  BoundlessKit
//
//  Created by Akash Desai on 5/4/18.
//

import Foundation

class BoundlessUser : NSObject {
    internal enum IdSource : String {
        case idfa, idfv, custom
    }
    
    internal var idSource: IdSource = .idfv {
        didSet {
            _id = nil
            _ = self.id
        }
    }
    
    fileprivate var _customId: String?
    public func set(customId: String?) {
        if let customId = customId?.asValidId {
            _customId = customId
            BoundlessKeychain.buid = customId
        }
        idSource = .custom
    }
    
    fileprivate var _id: String?
    var id: String {
        switch idSource {
        case .idfa:
            if _id == nil {
                _id = ASIdHelper.adId()?.uuidString.asValidId
            }
            fallthrough
        case .idfv:
            if _id == nil {
                _id = UIDevice.current.identifierForVendor?.uuidString
            }
            fallthrough
        case .custom:
            if _id == nil {
                _id = _customId ?? BoundlessKeychain.buid ?? {
                    let uuid = UUID().uuidString
                    _customId = uuid
                    BoundlessKeychain.buid = uuid
                    return uuid
                    }()
            }
            fallthrough
        default:
            return _id ?? "IDUnavailable"
        }
    }
    
    internal(set) var experimentGroup: String? {
        get {
            return BoundlessKeychain.experiementGroup
        }
        set {
            BoundlessKeychain.experiementGroup = newValue
        }
    }
}

fileprivate extension String {
    var asValidId: String? {
        if !self.isEmpty,
            self.count <= 36,
            self != "00000000-0000-0000-0000-000000000000",
            self.range(of: "[^a-zA-Z0-9\\-]", options: .regularExpression) == nil {
            return self
        }
        return nil
    }
}
