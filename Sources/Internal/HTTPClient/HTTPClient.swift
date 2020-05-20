import Foundation
import Alamofire

public typealias Completion<T: Decodable> = (_ result: Result<ResponseObject<T>, Error>) -> Void

struct HTTPClient<T: Decodable> {
    
    let logger: Logger = Merchant.logger
    let decoder: JSONDecoder = JSONDecoder()
    let requestInterceptor: HTTPRequestInterceptor
    let session: Session
    
    func request(url: String, method: HTTPMethod,
                 headers: [String: String]?,
                 completion: @escaping Completion<T>) {
        
        session.request(url,
                        method: method,
                        headers: HTTPHeaders(headers ?? [:]),
                        interceptor: requestInterceptor)
            .responseDecodable(of: T.self, decoder: decoder) { response in
                
                self.processResponse(response, completion: completion)
                
        }
    }
    
    func requestWithBody<U: Encodable>(url: String,
                                        method: HTTPMethod,
                                        body: U?,
                                        headers: [String: String]?,
                                        formURLEncoded: Bool,
                                        completion: @escaping Completion<T>) {
        
        var encoder: ParameterEncoder = JSONParameterEncoder.default
        
        if (formURLEncoded) {
            encoder = URLEncodedFormParameterEncoder.default
        }
        
        session.request(url, method: method,
                        parameters: body,
                        encoder: encoder,
                        headers: HTTPHeaders(headers ?? [:]),
                        interceptor: requestInterceptor)
            .responseDecodable(of: T.self, decoder: decoder) { response in
                
                self.processResponse(response, completion: completion)
        }
    }
    
    private func processResponse(_ response: AFDataResponse<T>,
                                 completion: @escaping Completion<T>) {
        
        self.logger.log(response.response, data: response.data, metrics: response.metrics) // USE events
        
        guard let urlResponse = response.response else { return completion(.failure(RetroSwiftError.error(localizedDescription: "HTTPURLResponse is nil"))) }
        
        switch response.result {
            case .success(let model):
                return completion(
                    .success(ResponseObject(body: model, statusCode: urlResponse.statusCode, raw: response))
            )
            case .failure(let error):
                return completion(.failure(error))
        }
    }
}
