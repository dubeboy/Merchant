import Foundation

protocol Logger {
    func log(_ request: URLRequest?)
    func log(_ response: HTTPURLResponse?, data: Data?, metrics: URLSessionTaskMetrics?)
}

struct MerchantLogger: Logger {

    private let level: LogLevel
    private let output = "➡️"
    private let input = "⬅️"
    private let end = "END HTTP"
    private let formater = DateFormatter()
    private let loggerOutput: LoggerOutput = STDOutLogger.instance

    
    init(level: LogLevel) {
        formater.dateFormat = "yy-MM-dd HH:mm:ss.SSS"
        self.level = level
    }
    
    func log(_ request: URLRequest?) {
        if level == .nothing {
            return
        }
        guard let request = request else {
            log(.errorNilRequest)
            return
        }
        
        if level == .basic || level == .headers || level == .body {
            log("🚀 \(formater.string(from: Date()))")
            log("\(output) \(request.method?.rawValue ?? "nil") \(getPath(request.url?.absoluteString))")
        }
        
        logCommon(level, data: request.httpBody, headers: request.allHTTPHeaderFields, isRequest: true)
    }
    
    func log(_ response: HTTPURLResponse?, data: Data?, metrics: URLSessionTaskMetrics?) {
        if level == .nothing {
            return
        }
        guard let response = response else {
            log(.errorNilResponse)
            return
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
    
    private func getPath(_ path: String?) -> String {
        let components = URLComponents(string: path ?? "")
        guard let
            path = path,
            !path.isEmpty,
            let rangePath = components?.rangeOfPath
        else { return "nil" }
        
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