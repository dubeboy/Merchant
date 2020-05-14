import Alamofire

//@propertyWrapper
public class RetroSwift {
   
    private static var _builder: Builder?
    
    static var builder: Builder {
        guard let builder = RetroSwift._builder else {
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
    
    static var logger: Logger { builder.logger ?? RetroSwiftLogger(level: .body) }
    static var session: Session { builder.session ?? AF }
    static var globalQuery: [String: String]? { builder.query }
    static var logInterceptor: HTTPRequestInterceptor { HTTPRequestInterceptor(logger: RetroSwift.logger) }
        
    @discardableResult
    public init(builder: Builder) {
        RetroSwift._builder = builder
    }
    
    public class Builder {
        
        var baseUrl: String?
        var logger: RetroSwiftLogger?
        var query: [String: String]?  // test for encoded URLQuery items
        var session: Session?
        
        public init() { }
     
        @discardableResult
        public func baseUrl(_ url: String) -> Self {
            self.baseUrl = url
            return self
        }
        
        @discardableResult
        public func logger(_ logger: RetroSwiftLogger) -> Self {
            self.logger = logger
            return self
        }
         
        @discardableResult
        public func session(_ session: Session) -> Self {
            self.session = session
            return self
        }
        
//        public func timeOut
        
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


