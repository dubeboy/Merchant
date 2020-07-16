//
//  DispatchQueue+MerchantLogger.swift
//  Merchant
//
//  Created by Divine.Dube on 2020/05/30.
//

import Foundation

extension DispatchQueue {
    static var loggingQueue: DispatchQueue {
        DispatchQueue(label: "io.github.merchant.MerchantLogger")
    }
}
