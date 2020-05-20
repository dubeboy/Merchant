import Foundation

protocol Logger {
    
    var level: LogLevel { get }
    
    func log(_ request: URLRequest?, path: String, data: Data?)
    func log(_ response: HTTPURLResponse?, data: Data?, metrics: URLSessionTaskMetrics?)
}


open class MerchantLogger: Logger {

    let level: LogLevel
    let output = "➡️"
    let input = "⬅️"
    let end = "END HTTP"
    let formater = DateFormatter()
    let loggerOutput: LoggerOutput

    public init(level: LogLevel,
                loggerOutput: LoggerOutput = STDOutLogger.instance,
                dateFormat: String = "yy-MM-dd HH:mm:ss.SSS") {
        self.level = level
        self.loggerOutput = loggerOutput
        formater.dateFormat = dateFormat // todo test this
    }
    
    open func log(_ request: URLRequest?, path: String, data: Data?) {
        
        guard let request = request else {
            log("URLRequest is nil")
            return
        }
        
        if level == .basic || level == .headers || level == .body {
            log(formater.string(from: Date()))
            log("\(output) \(request.method?.rawValue ?? "nil") \(getPath(path))")
        }
        
        logCommon(level, data: data, headers: request.allHTTPHeaderFields, isRequest: true)
    }
    
    open func log(_ response: HTTPURLResponse?, data: Data?, metrics: URLSessionTaskMetrics?) {
        
        guard let response = response else {
            log("HTTPURLResponse is nil")
            return;
        }
        
        if level == .basic || level == .headers || level == .body {
            let splitSec = String(format: "%.2f", metrics?.taskInterval.duration ?? -1)
            log("\(input) \(response.statusCode) (\(splitSec)ms)")
        }
        
        logCommon(level, data: data, headers: response.allHeaderFields, isRequest: false)
    }

    private func log(_ message: String? = "") {
        loggerOutput.log(message)
    }
    
    private func getPath(_ path: String) -> String {
        let components = URLComponents(string: path)
        guard let rangePath = components?.rangeOfPath else { return "nil" }
        
        return rangePath.isEmpty ? "/" : String(path[rangePath.lowerBound...])
    }
    
    private func logCommon(_ level: LogLevel, data: Data?, headers: [AnyHashable : Any]?, isRequest: Bool) {
        if level == .headers || level == .body {
            headers?.debugDescription.forEach {
                log($0)
            }
        }
        
        if level == .body {
            if let data = data {
                log(String(data: data, encoding: .utf8) ?? "")
            }
        }
        
        if level == .headers || level == .body {
            let direction = isRequest ? output : input
            log("\(direction) \(end)")
        }
    }
    
}

public extension MerchantLogger {
    static var basic: MerchantLogger { MerchantLogger(level: .basic) }
    static var body: MerchantLogger { MerchantLogger(level: .body) }
    static var headers: MerchantLogger { MerchantLogger(level: .headers) }
    static var nothing: MerchantLogger { MerchantLogger(level: .nothing) }
}
