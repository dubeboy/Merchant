//
//  HTTPClient.swift
//  Merchant_Example
//
//  Created by Divine.Dube on 2020/05/27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Merchant

struct HTTPService: Service {
    var baseURL: String = "Some URL"
    
    @GET
    var get: String
}
 

