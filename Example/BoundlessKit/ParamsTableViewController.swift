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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curParams.strParams.count
    }
    
    var curParams = RewardParams()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParamsTableViewCell", for: indexPath) as! ParamsTableViewCell
        
        cell.primitiveLabel.text = "<\(curParams.strParams[indexPath.row].key)>:"
        cell.valueLabel.text = "<\(curParams.strParams[indexPath.row].value)>"
        
        return cell
        
    }
}


class ParamsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var primitiveLabel: UILabel!
    @IBOutlet weak var valueLabel: UITextField!
    
    
}


