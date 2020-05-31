import Foundation
import Alamofire

public protocol Service {
    
    var level: LogLevel? { get }
    var query: [String: String]? { get }
    var session: Session? { get }
    var baseURL: String { get }
    
    init()
}

extension Service {
    
    public init() {
        self.init()
    }
    
    public var level: LogLevel? { nil }
    public var query: [String: String]? { nil }
    public var session: Session? {
        get {
            return nil
        }
        set {
           
        }
    }
}

