import Foundation

@propertyWrapper
public struct POST<T: Decodable, U: Encodable>: MerchantHttpMethod {
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
                body: U.Type,
                formURLEncoded: Bool = false,
                headers: [String: String]? = nil) {
        self.path = path
        self.formURLEncoded = formURLEncoded
        self.headers = headers
    }
    
    
}

extension POST {
    public func callAsFunction(_ path: [String: String]? = nil,
                        query parameters: [String: StringRepresentable?]? = nil,
                        body: U,
                        completion: @escaping Completion<T>) {
        post(pathParameters: path, queryParameters: parameters, body: body, completion: completion)
    }
    // TODO: all of these should be private!!!

    private func post(pathParameters: [String: String]?,
                      queryParameters: [String: StringRepresentable?]?,
                      body: U,
                      completion: @escaping Completion<T>) {
        let url = createURL(with: pathParameters, and: queryParameters)
        client.requestWithBody(url: url,
                                method: .post,
                                body: body,
                                headers: headers,
                                formURLEncoded: formURLEncoded,
                                completion: completion)
    }
    
}

extension POST where U == [MultipartBody] {
    public func callAsFunction(_ path: [String: String]? = nil,
                               query parameters: [String: StringRepresentable?]? = nil,
                               body: U,
                               completion: @escaping Completion<T>) { // add upload progress here
        postMultipart(pathParameters: path, queryParameters: parameters, body: body, completion: completion)
    }
    
    private func postMultipart(pathParameters: [String: String]?,
                               queryParameters: [String: StringRepresentable?]?,
                               body: U,
                               completion: @escaping Completion<T>) {
        
        let url = createURL(with: pathParameters, and: queryParameters)
        client.uploadMiltipartFormData(url: url,
                                       multipartBody: body,
                                       completion: completion)
    }
    
    
}

