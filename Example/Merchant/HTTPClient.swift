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
    var baseURL: String = "https://httpbin.org/"
    var level: LogLevel? = .body
    
    @GET("image/png", headers: ["accept": "image/png"])
    var get: Data
    
    // //anything  does not fail why?
    @POST("anything", body: Data.self,
          headers: ["accept": "image/png",
                    "content-type": " image/png"])
    var postImageData: Data
    
    func doSomeDamage() {
    }
}
