//
//  MultipartBody.swift
//  Merchant
//
//  Created by Divine.Dube on 2020/10/01.
//

import Foundation

struct MultipartBody {
    let name: String
    let body: Data // Should be uploadable
    var filename: String? = nil
    var mime: String? = nil
}
