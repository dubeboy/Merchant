import Foundation
import Alamofire

public protocol Service {
    var logger: LogLevel? { get }
    var query: [String: StringRepresentable]? { get }
    var session: Session? { get }
    var baseURL: String { get }
    
    init()
}

extension Service {
    public init() {
        self.init()
    }
    
    public var logger: LogLevel? { nil }
    public var query: [String: StringRepresentable]? { nil }
    public var session: Session? { nil }
}

