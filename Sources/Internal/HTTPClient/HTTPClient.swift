import Foundation
import Alamofire

public typealias Completion<T: Decodable> = (_ result: Result<ResponseObject<T>, Error>) -> Void

struct HTTPClient<T: Decodable> {
    let session: Session
    let logger: MerchantLogger
    let decoder: JSONDecoder = JSONDecoder()
    
    func request(url: URL,
                 method: HTTPMethod,
                 headers: [String: String]?,
                 completion: @escaping Completion<T>) {
        session.request(
            url,
            method: method,
            headers: HTTPHeaders(headers ?? [:])
        ).responseDecodable(of: T.self, decoder: decoder) { response in
            self.processResponse(response, completion: completion)
        }
    }
 
    func requestWithBody<U: Encodable>(url: URL,
                                       method: HTTPMethod,
                                       body: U?,
                                       headers: [String: String]?,
                                       formURLEncoded: Bool,
                                       completion: @escaping Completion<T>) {
        request(
            url: url,
            method: method,
            body: body,
            headers: headers,
            formURLEncoded: formURLEncoded
        ).responseDecodable(of: T.self,
                            decoder: decoder) { response in
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
            encoder: encoder,
            headers: HTTPHeaders(headers ?? [:])
        )
    }
    
    private func processResponse(_ response: AFDataResponse<T>,
                                 completion: @escaping Completion<T>) {

        self.logger.log(response.response, data: response.data, metrics: response.metrics)

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
