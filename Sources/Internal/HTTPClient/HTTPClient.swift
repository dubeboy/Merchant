import Foundation
import Alamofire

public typealias Completion<T: Decodable> = (_ result: Result<ResponseObject<T>, Error>) -> Void

struct HTTPClient {
    init(session: Session, logger: MerchantLogger) {
        self.session = session
        self.logger = logger
    }
    
    let session: Session
    let logger: MerchantLogger
    let decoder: JSONDecoder = JSONDecoder()
    
    // MARK: ALAMOFIRE powered HTTP methods
    
    /// Facilitates HTTP requests that do not require a body parameter
    func request<T: Decodable>(url: URL,
                               method: HTTPMethod,
                               headers: [String: String]?,
                               completion: @escaping Completion<T>) {
        // create an extenstion on HTTPHeaders that accepts a Nil value
        let dataRequest = session.request(
            url,
            method: method,
            headers: HTTPHeaders(headers ?? [:])
        )
        
        // create a private function that that handles all tge posible cases
        switch T.self {
            case is Data.Type:
                responseDecodeData(dataRequest: dataRequest, completion: completion as! Completion<Data>)
            default:
                responseDecodeJSON(dataRequest: dataRequest, completion: completion)
        }
    }
    
    /// Facilitates HTTP requests that require a body parameter
    func requestWithBody<T: Decodable, U: Encodable>(url: URL,
                                                     method: HTTPMethod,
                                                     body: U?,
                                                     headers: [String: String]?,
                                                     formURLEncoded: Bool,
                                                     completion: @escaping Completion<T>) {
        let dataRequest = request(
            url: url,
            method: method,
            body: body,
            headers: headers,
            formURLEncoded: formURLEncoded
        )
    }
}

// MARK: Helper functions

extension HTTPClient {
    
    private func respond<T>(type: T,
                            request: DataRequest,
                            completion: @escaping Completion<T>) {
        if type is Data {
            // Safe unwrap here because we are guarteed that T is Data
            responseDecodeData(dataRequest: request, completion: completion as! Completion<Data>)
        } else {
            responseDecodeJSON(dataRequest: request, completion: completion)
        }
    }
    
    private func request<U: Encodable>(url: URL,
                                       method: HTTPMethod,
                                       body: U?,
                                       headers: [String: String]?,
                                       formURLEncoded: Bool) -> DataRequest {
        var encoder: ParameterEncoder = JSONParameterEncoder.default
        if formURLEncoded {
            encoder = URLEncodedFormParameterEncoder.default
        }
        
        return session.request(
            url,
            method: method,
            parameters: body,
            encoder: encoder,
            headers: HTTPHeaders(headers ?? [:])
        )
    }
    
    private func responseDecodeJSON<T: Decodable>(dataRequest: DataRequest, completion: @escaping Completion<T>) {
        dataRequest.responseDecodable(of: T.self, decoder: decoder) { response in
            self.processResponse(response, completion: completion)
        }
    }
    
    private func responseDecodeData(dataRequest: DataRequest, completion: @escaping Completion<Data>) {
        dataRequest.responseData { response in
            self.processResponse(response, completion: completion)
        }
    }
    
    private func processResponse<T: Decodable>(_ response: AFDataResponse<T>,
                                               completion: @escaping Completion<T>) {
        // TODO: Should log data on another thread probably
        logger.log(response.response, data: response.data, metrics: response.metrics)
        
        guard let urlResponse = response.response else {
            return completion(
                .failure(
                    MerchantError.error(localizedDescription: .errorNilInstance)
                )
            )
        }
        
        switch response.result {
            case .success(let model):
                return completion(
                    .success(
                        ResponseObject(
                            body: model,
                            statusCode: urlResponse.statusCode,
                            raw: response
                        )
                    )
                )
            case .failure(let error):
                return completion(.failure(error))
        }
    }
    
}
