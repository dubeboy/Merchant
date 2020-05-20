import Foundation

@propertyWrapper
struct PUT<T: Decodable, U: Encodable>: HttpRequestMethod {
    
    let path: String
    let body: U.Type
    let formURLEncoded: Bool
    let headers: [String: String]?
    
    public var wrappedValue: T {
        get { preconditionFailure(.HTTP_METHOD_CANNOT_GET) }
        set { preconditionFailure(.HTTP_METHOD_CANNOT_SET) }
    }
    
    public var projectedValue: Self { self }
    
    public init(_ path: String = "", body: U.Type, formURLEncoded: Bool = false,  headers: [String: String]? = nil) {
        self.path = path
        self.body = body
        self.formURLEncoded = formURLEncoded
        self.headers = headers
    }
    
    private func put(pathParameters: [String: String]?, queryParameters: [String: String]?, body: U?,
                     completion: @escaping Completion<T>) {
        let url = createURL(with: pathParameters, and: queryParameters)
        client.requestWithBody(url: url, method: .put, body: body, headers: headers, formURLEncoded: formURLEncoded,
                               completion: completion)
    }
    
}

extension PUT {
    public func callAsFunction(_ path: [String: String]? = nil,
                               query parameters: [String: String]? = nil,
                               body: U,
                               completion: @escaping Completion<T>) {  // allow only primitive value types here
        put(pathParameters: path, queryParameters: parameters, body: body, completion: completion)
    }
}


