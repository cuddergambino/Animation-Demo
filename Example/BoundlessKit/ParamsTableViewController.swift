//
//  ParamsTableViewController.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class ParamsTableViewController : UITableViewController {
    
    static var shared: ParamsTableViewController!
    
    var savedParams = [String: RewardParams]()
    var curParams = RewardParams()
    
    override func viewDidAppear(_ animated: Bool) {
        ParamsTableViewController.shared = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curParams.strParams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParamsTableViewCell", for: indexPath) as! ParamsTableViewCell
        cell.valueLabel.delegate = cell
        cell.params = curParams
        
        cell.primitiveLabel.text = "<\(curParams.strParams[indexPath.row].key)>:"
        cell.valueLabel.text = "<\(curParams.strParams[indexPath.row].value)>"
        
        return cell
    }
}


class ParamsTableViewCell : UITableViewCell, UITextFieldDelegate {
    
    var params: RewardParams!
    
    @IBOutlet weak var primitiveLabel: UILabel!
    @IBOutlet weak var valueLabel: UITextField!
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Got key:\(primitiveLabel.text) text:\(textField.text as AnyObject)")
    }
    
    
}


