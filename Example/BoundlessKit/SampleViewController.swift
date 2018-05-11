//
//  ViewController.swift
//  BoundlessKit
//
//  Created by Akash Desai on 07/13/2016.
//  Copyright (c) 2016 Akash Desai. All rights reserved.
//

import UIKit
@testable import BoundlessKit
import CoreLocation

class SampleViewController: UIViewController {
    
    @IBOutlet weak var aView: UIImageView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        let mainMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
        mainMenuController.mainMenuDelegate = self
        
        addChildViewController(mainMenuController)
        self.view.addSubview(mainMenuController.view)
        mainMenuController.view.frame = CGRect.init(x: 0, y: aView.frame.maxY + 30, width: view.bounds.width, height: view.bounds.maxY - aView.frame.maxY)
        mainMenuController.didMove(toParentViewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = RewardSample.current.settings["primitive"] as? String ?? navigationController?.navigationBar.topItem?.title
    }
    
    @IBAction func didAwesomeThing(_ sender: UITapGestureRecognizer) {
        RewardSample.current.sample(target: self, sender: aView)
    }
}

extension SampleViewController : MainMenuDelegate {
    func didImport(image: UIImage) {
        DispatchQueue.main.async {
            self.aView.image = image
        }
    }
}
