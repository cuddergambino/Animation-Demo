//
//  RewardFormViewController.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SwiftForms
@testable import BoundlessKit

class RewardFormViewController : FormViewController {
    static var shared: FormViewController!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(RewardFormViewController.submit(_:)))
//    }
//
//    // MARK: Actions
//
//    @objc func submit(_: UIBarButtonItem!) {
//
//        let message = self.form.formValues().description
//
//        let alertController = UIAlertController(title: "Form output", message: message, preferredStyle: .alert)
//
//        let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
//        }
//
//        alertController.addAction(cancel)
//
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    // MARK: Private interface
    
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
