@propertyWrapper
public struct HEAD: MerchantHttpMethod {
    let holder: Holder = Holder()
    
    var merchant: Merchant? {
        didSet {
            holder.merchant = merchant
        }
    }


    public typealias T = Nothing
    
    var path: String
    var headers: [String: String]?
    
    public var wrappedValue: T {
        get { preconditionFailure(.errorMethodGet) }
        set { preconditionFailure(.errorMethodSet) }
    }
    
    public var projectedValue: Self { self }
    
    public init(_ path: String = "", headers: [String: String]? = nil) {
        self.path = path
        self.headers = headers
    }
    
    func head(pathParameters: [String: StringRepresentable]?, queryParamters: [String: StringRepresentable?]?,
             completion: @escaping Completion<T>) {
        let url = createURL(with: pathParameters, and: queryParamters)
        client.request(url: url, method: .head, headers: headers, completion: completion)
    }
}

extension HEAD {
    public func callAsFunction(_ path: [String: StringRepresentable]? = nil,
                               query parameters: [String: StringRepresentable?]? = nil,
                               completion: @escaping Completion<Nothing>) {
        head(pathParameters: path, queryParamters: parameters, completion: completion)
    }
}
