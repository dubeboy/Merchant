import Foundation

@propertyWrapper
public struct GET<T: Decodable>: MerchantHttpMethod {
    
    let holder: Holder = Holder()
    
    var merchant: Merchant? {
        didSet {
            holder.merchant = merchant
        }
    }

    var path: String
    var headers: [String: String]?
    
    // Try and move this to protocol please it will reduce the code we have to type
    public var wrappedValue: T {
        get { preconditionFailure(.errorMethodGet) }
        set { preconditionFailure(.errorMethodSet) }
    }
    
    public var projectedValue: Self { self }

    // expose alamofire HTTPHeader instead they are more powerful
    public init(_ path: String = "", headers: [String: String]? = nil) {
        self.path = path
        self.headers = headers
    }

    func get(
        pathParameters: [String: StringRepresentable]? = nil,
        queryParamters: [String: StringRepresentable?]? = nil,
        completion: @escaping Completion<T>
    ) {
        let url = createURL(with: pathParameters, and: queryParamters)
        client.request(url: url, method: .get, headers: headers, completion: completion)
    }
    
    private func getDataDecodable(
        pathParameters: [String: StringRepresentable]? = nil, queryParamters: [String:
        StringRepresentable?]? = nil,
        completion: @escaping Completion<Data>
    ) {
        
    }
}

extension GET {
    // should rename path -> path parameters
    public func callAsFunction(_ path: [String: StringRepresentable]? = nil,
                               query parameters: [String: StringRepresentable?]? = nil,
                               completion: @escaping Completion<T>) {
        get(pathParameters: path, queryParamters: parameters, completion: completion)
    }
}


