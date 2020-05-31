import Foundation

class Holder {
     var merchant: Merchant?
}

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
    
    public var wrappedValue: T {
        get { preconditionFailure(.errorMethodGet) }
        set { preconditionFailure(.errorMethodSet) }
    }
    
    public var projectedValue: Self { self }

    public init(_ path: String = "", headers: [String: String]? = nil) {
        self.path = path
        self.headers = headers
    }

    func get(pathParameters: [String: String]? = nil, queryParamters: [String: String]? = nil,
             completion: @escaping Completion<T>) {
        let url = createURL(with: pathParameters, and: queryParamters)
        client.request(url: url, method: .get, headers: headers, completion: completion)
    }
}

extension GET {
    public func callAsFunction(_ path: [String: String]? = nil,
                               query parameters: [String: String]? = nil,
                               completion: @escaping Completion<T>) {
        get(pathParameters: path, queryParamters: parameters, completion: completion)
    }
}
