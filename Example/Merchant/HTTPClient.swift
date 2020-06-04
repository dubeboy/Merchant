//
//  HTTPClient.swift
//  Merchant_Example
//
//  Created by Divine.Dube on 2020/05/27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Merchant


struct Grocery: Codable {
    let name: String
    var id: Int?
    let available: Bool
}

struct StatusReponse<T: Decodable> : Decodable {
    let status: Bool
    let message: String
    let entity: T
}


struct HTTPService: Service {
    var baseURL: String = "http://192.168.88.251:8080/groceries"
    
    @GET
    var get: Grocery
    
    @POST(body: String.self)
    var postIt: Grocery
}
