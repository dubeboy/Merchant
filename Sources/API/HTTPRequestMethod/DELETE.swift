import Foundation

@propertyWrapper
public struct DELETE<T: Decodable>: HttpRequestMethod {
    
    var path: String
    var headers: [String: String]? = nil
    
    public var wrappedValue: T {
        get { preconditionFailure("Cannot get this value") } 
        set { preconditionFailure("Cannot set this value") }
    }
    
    public var projectedValue: Self { self }
    
    public init(_ path: String = "", headers: [String: String]? = nil) {
        self.path = path
        self.headers = headers
    }
    
    func delete(pathParameters: [String: String]?, queryParamters: [String: String]?,
                completion: @escaping Completion<T>) {
        let url = createURL(with: pathParameters, and: queryParamters)
        client.request(url: url,  method: .delete,
                       headers: headers, completion: completion)
    }
}

extension DELETE { // play with clause
    
    public func callAsFunction(_ path: [String: String]? = nil,
                               query parameters: [String: String]? = nil,
                               completion: @escaping Completion<T>) {
        
        delete(pathParameters: path,
                    queryParamters: parameters,
                    completion: completion)
    }
}





