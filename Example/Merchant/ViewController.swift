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
        
        client.$postIt(query: ["someQuery": nil], body: "") { _ in
            
        }
    }
    
    struct Hello {
        let id: Int
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { e in
            e[keyPath: keyPath]
        }
    }
}
