import Foundation
import Alamofire

public protocol Service {
    var logger: LogLevel? { get }
    var query: [String: StringRepresentable]? { get }
    var session: Session? { get }
    var baseURL: String { get }
    // ability to set Multipart and also set upload threshold

    // TODO: we should maintain static refrence to this class @SingletonInstance
    // Option to Pretify JSOn

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

