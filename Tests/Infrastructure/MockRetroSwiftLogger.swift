//
//  File.swift
//  
//
//  Created by Divine.Dube on 2020/05/12.
//

import Foundation
@testable import RetroSwift

class MockRetroSwiftLogger: RetroSwiftLogger {
    
    convenience init(_ logLevel: LogLevel) {
        self.init(level: logLevel, loggerOutput: MockSTDOutLogger())
    }
    
    var message: [String] {
        let mockLogger = self.loggerOutput as! MockSTDOutLogger
        return mockLogger.message
    }
    
}

class MockSTDOutLogger: LoggerOutput {
    
    var message: [String] = []
    
    func log(_ message: String?) {
        self.message.append(message ?? "")
    }
}
