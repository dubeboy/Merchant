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
    
    func request<T: Decodable>(url: URL,
                               method: HTTPMethod,
                               headers: [String: String]?,
                               completion: @escaping Completion<T>) {
        
        let dataRequest = session.request(
            url,
            method: method,
            headers: HTTPHeaders(headers ?? [:])
        )
        
        switch T.self {
            case is Data.Type:
                responseDecodeData(dataRequest: dataRequest, completion: completion as! Completion<Data>)
            default:
                responseDecodeJSONData(dataRequest: dataRequest, completion: completion)
        }
    }
    
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
        
        switch T.self {
            case is Data.Type:
                responseDecodeData(dataRequest: dataRequest, completion: completion as! Completion<Data>)
            default:
                responseDecodeJSONData(dataRequest: dataRequest, completion: completion)
        }
    }
    
    private func responseDecodeJSONData<T: Decodable>(dataRequest: DataRequest, completion: @escaping Completion<T>) {
        dataRequest.responseDecodable(of: T.self, decoder: decoder) { response in
            self.processResponse(response, completion: completion)
        }
    }
    
    private func responseDecodeData(dataRequest: DataRequest, completion: @escaping Completion<Data>) {
        dataRequest.responseData { response in
            self.processResponse(response, completion: completion)
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
//            encoder: encoder,
            headers: HTTPHeaders(headers ?? [:])
        )
    }
    
    
    private func processResponse<T: Decodable>(_ response: AFDataResponse<T>,
                                               completion: @escaping Completion<T>) {
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
