import Alamofire

class Merchant: Service {
    var service: Service
    var logger: MerchantLogger // todo better name
    var session: Session
    
    var globalQuery: [String: StringRepresentable]? { service.query }
    var baseURL: String { service.baseURL }
    var client: HTTPClient
    
    init(service: Service) {
        self.service = service
        logger = MerchantLogger(level: service.level ?? .body)
        session = Merchant.create(with: service)
        client = HTTPClient(session: session, logger: logger) // TODO: - Can be better
        setMerchant(to: service)
    }
    
    // Create a new Alamofire from the session given by the developer
    private static func create(with service: Service) -> Session {
        if let session = service.session {
            return Session(
                session: session.session,
                delegate: session.delegate,
                rootQueue: session.rootQueue,
                startRequestsImmediately: session.startImmediately,
                requestQueue: session.requestQueue,
                serializationQueue: session.serializationQueue,
                interceptor: session.interceptor,
                serverTrustManager: session.serverTrustManager,
                redirectHandler: session.redirectHandler,
                cachedResponseHandler: session.cachedResponseHandler,
                eventMonitors: [session.eventMonitor,
                                createEventMonitor(level: service.level)]
            )
        }
        return Session(eventMonitors: [createEventMonitor(level: service.level)])
    }
    
    private static func createEventMonitor(level: LogLevel?) -> LogEventMonitor {
        LogEventMonitor(logger: createLogger(level: level))
    }
    
    private static func createLogger(level: LogLevel?) -> MerchantLogger {
        MerchantLogger(level: level ?? .body)
    }
    
    private func setMerchant(to service: Service) {
        let mirror = Mirror(reflecting: service)
        for child in mirror.children {
            if var method = child.value as? AnyMerchantHttpMethod {
                method.merchant = self
            }
        }
    }
}

// Create a singleton equivalent

@propertyWrapper
public struct Autowired<T: Service> {
    
    var merchant: Merchant
    var service: T
    
    public var wrappedValue: T {
        return service
    }
    
    public init(service: Service = T()) {
        self.merchant = Merchant(service: service)
        guard let service = merchant.service as? T else {
            preconditionFailure(.errorUnexpected)
        }
        self.service = service
    }
}
