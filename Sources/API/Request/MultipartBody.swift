//
//  MultipartBody.swift
//  Merchant
//
//  Created by Divine.Dube on 2020/10/01.
//

import Foundation

// interface this out so that the user does not have to import merchant every where
public struct MultipartBody: Encodable {
    
    let name: String
    let body: Data // Should be uploadable
    var filename: String? = nil
    var mime: String? = nil
    
    public init(name: String, body: Data, filename: String? = nil, mime: String? = nil) {
        self.name = name
        self.body = body
        self.filename = filename
        self.mime = mime
    }
    
    
}
