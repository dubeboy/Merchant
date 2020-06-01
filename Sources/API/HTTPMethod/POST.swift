import Foundation

@propertyWrapper
public struct POST<T: Decodable, U: Encodable, Q: Query>: MerchantHttpMethod {
    let holder: Holder = Holder()
    
    var merchant: Merchant? {
        didSet {
            holder.merchant = merchant
        }
    }

 
    let path: String
    let formURLEncoded: Bool
    let headers: [String: String]?
   
    public var wrappedValue: T {
        get { preconditionFailure(.errorMethodGet) }
        set { preconditionFailure(.errorMethodSet) }
    }
    
    public var projectedValue: Self { self }
    
    public init(_ path: String = "",
                query: Q.Type?,
                body: U.Type,
                formURLEncoded: Bool = false,
                headers: [String: String]? = nil) {
        self.path = path
        self.formURLEncoded = formURLEncoded
        self.headers = headers
    }
    
    func post(pathParameters: [String: String]?, queryParameters: [Q: String]?, body: U?,
              completion: @escaping Completion<T>) {
//        let url = createURL(with: pathParameters, and: queryParameters)
        let url = ""

        
        client.requestWithBody(url: url, method: .post, body: body, headers: headers,
                               formURLEncoded: formURLEncoded, completion: completion)
    }
}

extension POST {
    public func callAsFunction(_ path: [String: String]? = nil,
                        query parameters: [Q: String]? = nil, // this should take in a codeable
                        body: U,
                        completion: @escaping Completion<T>) {
        post(pathParameters: path, queryParameters: parameters, body: body, completion: completion)
    }
}

