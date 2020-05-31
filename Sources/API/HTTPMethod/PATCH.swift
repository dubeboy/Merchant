import Foundation

@propertyWrapper
public struct PATCH<T: Decodable, U: Encodable>: MerchantHttpMethod {
    let holder: Holder = Holder()
    
    var merchant: Merchant? {
        didSet {
            holder.merchant = merchant
        }
    }

    let path: String
    let body: U.Type
    let formURLEncoded: Bool
    let headers: [String: String]?
    
    public var wrappedValue: T {
        get { preconditionFailure(.errorMethodGet) }
        set { preconditionFailure(.errorMethodSet) }
    }
    
    public var projectedValue: Self { self }
    
    public init(_ path: String = "", body: U.Type, formURLEncoded: Bool = false, headers: [String: String]? = nil) {
        self.path = path
        self.body = body
        self.formURLEncoded = formURLEncoded
        self.headers = headers
    }
    
    func patch(pathParameters: [String: String]?, queryParameters: [String: String]?, body: U?,
               completion: @escaping Completion<T>) {
        let url = createURL(with: pathParameters, and: queryParameters)
        client.requestWithBody(url: url, method: .patch, body: body, headers: headers, formURLEncoded: formURLEncoded,
                               completion: completion)
    }
    
}

extension PATCH {
    public func callAsFunction(_ path: [String: String]? = nil, query parameters: [String: String]? = nil,
                        body: U, completion: @escaping Completion<T>) {
        patch(pathParameters: path, queryParameters: parameters, body: body, completion: completion)
    }
}
