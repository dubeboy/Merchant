import Alamofire
import Foundation

class LogEventMonitor: EventMonitor {

    var logger: MerchantLogger
    
    init(logger: MerchantLogger) {
        self.logger = logger
    }
 
    func request(_ request: Request, didCreateInitialURLRequest urlRequest: URLRequest) {
        logger.log(urlRequest)
    }
    
}
