import Foundation
import Alamofire

protocol MerchantHttpMethodBase {
    var merchant: Merchant? { get set }
    var holder: Holder { get }
}

protocol MerchantHttpMethod: MerchantHttpMethodBase {
    
    associatedtype T: Decodable

    var path: String { get }
    var headers: [String: String]? { get }
    var client: HTTPClient<T> { get }

}

extension MerchantHttpMethod {
    
    private var nonNilMerchant: Merchant {
        guard let merchant = holder.merchant else {
            preconditionFailure(.errorUnexpected)
        }
        return merchant
    }
    
    private var baseURL: String { nonNilMerchant.baseURL }
    
    private var globalQueries: [String: StringRepresentable]? { nonNilMerchant.globalQuery }

    var client: HTTPClient<T> {
        HTTPClient(
            session: nonNilMerchant.session,
            logger: nonNilMerchant.logger
        )
    }
    
    func createURL(with pathParameters: [String: StringRepresentable]?,
                   and queryParameters: [String: StringRepresentable?]?) -> URL {
        let injectedPath = injectPath(with: pathParameters)
        let query = appendGlobalQuery(to: queryParameters)
        var components = URLComponents(string: baseURL + injectedPath)
        components?.queryItems = query?.map { URLQueryItem(name: $0, value: $1?.stringRepresentation) }
        guard let url = components?.url else {
            preconditionFailure(
                String(
                    format: .errorMalformedURL,
                    baseURL,
                    injectedPath,
                    String(describing: query)
                )
            )
        }
        return url
    }
}

extension MerchantHttpMethod {
    private func injectPath(with pathParamters: [String: StringRepresentable]?) -> String {
        guard let pathParameters = pathParamters else { return path }
        
        var newPath = path
        for variable in getPathVariables(for: path) {
            guard let value = pathParameters[variable] else {
                preconditionFailure(
                    String(
                        format: .errorNoneMatchingPathVariables,
                        variable, pathParameters
                    )
                )
            }
            newPath = newPath.replacingOccurrences(of: "{\(variable)}", with: value.stringRepresentation)
        }
        return newPath
    }
        
    private func appendGlobalQuery(to queries: [String: StringRepresentable?]?) -> [String: StringRepresentable?]? {
        if let queries = queries, !queries.isEmpty {
            return queries.merging(globalQueries ?? [:]) {
                _,_  in preconditionFailure(
                    String(
                        format: .errorDuplicateKeys,
                        queries,
                        String(describing: globalQueries)
                    )
                )
            }
        }
        return globalQueries
    }
    
    private func getPathVariables(for path: String) -> [String] {
        let range = NSRange(location: 0, length: path.utf16.count)
        let regex = try! NSRegularExpression(pattern: "\\{.*?\\}")
        let res = regex.matches(in: path, options: [], range: range)
        return res
            .map { String(path[Range($0.range, in: path)!]) }
            .map {
                $0.replacingOccurrences(of: "{", with: "")
                .replacingOccurrences(of: "}", with: "")
            }
    }
}
