//
//  ViewController.swift
//  BoundlessKit
//
//  Created by Akash Desai on 07/13/2016.
//  Copyright (c) 2016 Akash Desai. All rights reserved.
//

import UIKit
import BoundlessKit
import CoreLocation

class SampleViewController: UIViewController {
    
    @IBOutlet weak var aView: UIImageView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let controller: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as UIViewController
        
        addChildViewController(controller)
        self.view.addSubview(controller.view)
        controller.view.frame = CGRect.init(x: 0, y: navigationController?.navigationBar.frame.maxY ?? 0, width: view.bounds.width, height: aView.frame.minY - 20 - (navigationController?.navigationBar.frame.maxY ?? 0))
        
        controller.didMove(toParentViewController: self)
        
    }
    
    @IBAction func didAwesomeThing(_ sender: UITapGestureRecognizer) {
        
        aView.showConfetti()
    }
    
    var curParams = RewardParams()
}
