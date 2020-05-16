//
//  HTTPClient.swift
//  RetroSwift_Example
//
//  Created by Divine.Dube on 2020/05/15.
//  Copyright © 2020 Divine Dube. All rights reserved.
//

import Foundation
import RetroSwift


struct HTTPClient {
    
    @GET("/awesome_path")
    var getWeather: Weather
}
