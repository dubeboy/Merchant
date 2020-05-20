import Alamofire

public class Merchant {
   
    private static var _builder: Builder?
    
    static var builder: Builder {
        guard let builder = Merchant._builder else {
            preconditionFailure("RetroSwift builder is nil")
        }
        return builder
    }
    
    static var baseUrl: String {
        guard let baseUrl = builder.baseUrl, !baseUrl.isEmpty else {
            preconditionFailure("Base URL is nil")
        }
        return baseUrl
    }
    
    static var logger: Logger { builder.logger ?? MerchantLogger(level: .body) }
    static var session: Session { builder.session ?? AF }
    static var globalQuery: [String: String]? { builder.query }
    static var logInterceptor: HTTPRequestInterceptor { HTTPRequestInterceptor(logger: Merchant.logger) }
        
    @discardableResult
    public init(builder: Builder) {
        Merchant._builder = builder
    }
    
    public class Builder {
        
        private(set) var baseUrl: String?
        private(set) var logger: MerchantLogger?
        private(set) var query: [String: String]?
        private(set) var session: Session?
        
        public init() { }
     
        @discardableResult
        public func baseUrl(_ url: String) -> Self {
            self.baseUrl = url
            return self
        }
        
        @discardableResult
        public func logger(_ logger: MerchantLogger) -> Self {
            self.logger = logger
            return self
        }
         
        @discardableResult
        public func session(_ session: Session) -> Self {
            self.session = session
            return self
        }
                
        @discardableResult
        public func query(_ query: [String: String]) -> Self {
            self.query = query
            return self
        }

        public func build() -> Builder {
            let builder = Builder()
            builder.baseUrl = baseUrl
            builder.logger = logger
            builder.session = session
            builder.query = query
            return builder
        }
    }
}


