import Foundation
import Alamofire

struct HTTPRequestInterceptor: RequestInterceptor {
    
    let logger: Logger
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        logger.log(urlRequest, path: urlRequest.url?.absoluteString ?? "", data: urlRequest.httpBody)
        completion(.success(urlRequest))
    }
}
