import Alamofire

class LogEventMonitor: EventMonitor {

    var queue: DispatchQueue = DispatchQueue.loggingQueue
    var logger: MerchantLogger
    
    init(logger: MerchantLogger) {
        self.logger = logger
    }
 
    func request(_ request: Request, didCreateInitialURLRequest urlRequest: URLRequest) {
        logger.log(urlRequest)
    }
    
}
