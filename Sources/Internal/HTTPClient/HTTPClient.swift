import Foundation
import Alamofire

public typealias Completion<T: Decodable> = (_ result: Result<ResponseObject<T>, Error>) -> Void
// TODO: test spead if these methods using the measure test suite!!!
// should we call clean up everytime
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
        
        // TODO: Creates an extenstion on HTTPHeaders that accepts a Nil value
        // You can see the curl request, its worth while to check how they do it!!!!
        let dataRequest = session.request(url,
                                          method: method,
                                          headers: HTTPHeaders(headers ?? [:]))
                responseDecodeJSON(dataRequest: dataRequest, completion: completion)
    }
    
    /// Facilitates HTTP requests that require a body parameter
    func requestWithBody<T: Decodable, U: Encodable>(url: URL,
                                                     method: HTTPMethod,
                                                     body: U?,
                                                     headers: [String: String]?,
                                                     formURLEncoded: Bool,
                                                     completion: @escaping Completion<T>) {
        let dataRequest = request(url: url,
                                       method: method,
                                       body: body,
                                       headers: headers,
                                       formURLEncoded: formURLEncoded)
        
            responseDecodeJSON(dataRequest: dataRequest, completion: completion)
    }
    
    func uploadMiltipartFormData<T: Decodable>(url: URL,
                                 multipartBody: [MultipartBody],
                                 completion: @escaping Completion<T>) {
        let uploadRequest = session.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data("one".utf8), withName: "one")
            multipartBody.forEach { body in
                multipartFormData.append(body.body, withName: body.name, fileName: body.filename, mimeType: body.mime)
            }
        }, to: url)
               
       responseDecodeJSON(dataRequest: uploadRequest, completion: completion)
    }
}

// MARK: Helper functions

extension HTTPClient {
    
    private func respond<T>(type: T,
                            request: DataRequest,
                            completion: @escaping Completion<T>) {
            responseDecodeJSON(dataRequest: request, completion: completion)
    }
    
//    body: U? = (()) as? U, try this out yoh!!
    private func request<U: Encodable>(url: URL,
                                       method: HTTPMethod,
                                       body: U? = (()) as? U,
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
    
    private func processResponse<T: Decodable>(_ response: AFDataResponse<T>,
                                               completion: @escaping Completion<T>) {
        
        logger.log(response.response, data: response.data, metrics: response.metrics)
        
        guard let urlResponse = response.response else {
            return completion(
                .failure(
                    // try to return arEffor
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
