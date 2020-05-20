import Foundation

public protocol LoggerOutput {
    func log(_ message: String?)
}

public class STDOutLogger: LoggerOutput {
    
    public static let instance: LoggerOutput = STDOutLogger()
    
    private init() {}
    
    public func log(_ message: String? = "") {
        #if DEBUG
            print(message ?? "")
        #endif
    }
}
