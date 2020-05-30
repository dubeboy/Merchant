import Foundation
import Alamofire

public protocol Service {
    
    var logger: MerchantLogger? { get }
    var query: [String: String]? { get }
    var session: Session? { get }
    var baseURL: String { get }
    
    init()
}

extension Service {
    
    public init() {
        print("called ")
        self.init()
       
    }
    
    public var logger: MerchantLogger? {
        nil
    }
    
    public var query: [String: String]? {
        nil
    }
    
    public var session: Session? {
        nil
    }
}

