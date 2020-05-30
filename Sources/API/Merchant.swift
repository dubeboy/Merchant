import Alamofire

class Merchant {
    
    private let defaultLogger = MerchantLogger(level: .body)
    
    var service: Service
    
    var logger: MerchantLogger { service.logger ?? defaultLogger }
    var session: Session { service.session ?? AF }
    var globalQuery: [String: String]? { service.query }
    var baseURL: String { service.baseURL }
    
    init(service: Service) {
        self.service = service
    }
}

struct MerchantInstance {
    
    static var _instance: Merchant?
    
    static var instance: Merchant {
        guard let instance = Self._instance else { preconditionFailure(.errorNilInstance) }
        return instance
    }
    
    private init() {}
    
    static func create(service: Service) {
        Self._instance = Merchant(service: service)
    }
}

@propertyWrapper
public struct Autowired<T: Service> {
    
    public var wrappedValue: T {
        MerchantInstance.instance.service as! T
    }
    
    public init(service: T = T()) {
        MerchantInstance.create(service: service)
    }
}




