//
//  ViewController.swift
//  Merchant
//
//  Created by dubeboy on 05/21/2020.
//  Copyright (c) 2020 dubeboy. All rights reserved.
//

import UIKit
import Merchant

class ViewController: UIViewController {
    
    @Autowired
    var client: HTTPService

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        client.$get { _ in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

