//
//  ModifySample.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SwiftForms
@testable import BoundlessKit

class ModifySample : FormViewController {
    static var shared: FormViewController!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if self.isMovingFromParentViewController {
            saveForm()
        }
    }
    
    fileprivate func saveForm() {
        print("Message:\(self.form.formValues().description)")
        
        RewardSample.current.setForm(form: self.form)
    }
    
    func loadForm() {
        self.form = RewardSample.current.getForm(self)
        return
    }
    
    let group = DispatchGroup()
    func refreshForm() {
//        DispatchQueue.global().async {
//            if self.group.wait(timeout: .now()) == .success {
//                self.group.enter()
//                DispatchQueue.main.async() {
//                    self.loadForm()
//                    self.tableView.reloadData()
//                    self.group.leave()
//                }
//            }
//        }
    }
    
    
}
