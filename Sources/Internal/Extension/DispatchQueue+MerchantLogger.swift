//
//  DispatchQueue+MerchantLogger.swift
//  Merchant
//
//  Created by Divine.Dube on 2020/05/30.
//

import Foundation

extension DispatchQueue {
    static let merchantResponseQueue: DispatchQueue =
        DispatchQueue(label: "com.github.merchant.merchant.response-queue",
                      qos: .userInitiated)
    
}
