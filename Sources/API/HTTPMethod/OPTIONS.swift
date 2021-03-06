import Foundation

@propertyWrapper
public struct OPTIONS<T: Decodable>: HttpRequestMethod {
    
    var path: String
    var headers: [String: String]?
    
    public var wrappedValue: T {
        get { preconditionFailure(.HTTP_METHOD_CANNOT_GET) }
        set { preconditionFailure(.HTTP_METHOD_CANNOT_SET) }
    }
    
    public var projectedValue: Self { self }
    
    public init(_ path: String = "", headers: [String: String]? = nil) {
        self.path = path
        self.headers = headers
    }
    
    func options(pathParameters: [String: String]?, queryParamters: [String: String]?,
             completion: @escaping Completion<T>) {
        let url = createURL(with: pathParameters, and: queryParamters)
        client.request(url: url, method: .options, headers: headers, completion: completion)
    }
}

extension OPTIONS {
    public func callAsFunction(_ path: [String: String]? = nil,
                               query parameters: [String: String]? = nil,
                               completion: @escaping Completion<T>) {
        options(pathParameters: path, queryParamters: parameters, completion: completion)
    }
}
