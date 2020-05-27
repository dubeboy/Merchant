import Foundation
import Alamofire

protocol HttpRequestMethod {
    
    associatedtype T: Decodable

    var path: String { get }
    var headers: [String: String]? { get }
    var client: HTTPClient<T> { get }

}

extension HttpRequestMethod {
    
    private var baseURL: String { Merchant.baseUrl }
    private var globalQueries: [String: String]? { Merchant.globalQuery }
    private var session: Session { Merchant.session }
    
    var client: HTTPClient<T> {
        HTTPClient(requestInterceptor: Merchant.logInterceptor, session: Merchant.session)
    }
    
    func createURL(with pathParameters: [String: String]?,
                   and queryParameters: [String: String]?) -> String {
        
        let injectedPath = injectPath(with: pathParameters)
        let query = appendGlobalQuery(to: queryParameters)
        
        var components = URLComponents(string: baseURL + injectedPath)
        components?.queryItems = query?.map { URLQueryItem(name: $0, value: $1) }
        
        guard let url = components?.url else {
            preconditionFailure("Failed to create URL from url components. baseURL: \(baseURL) path: \(injectedPath) and query parameters: \(String(describing: query))")
        }
        
        return url.absoluteString
    }
    
    private func injectPath(with pathParamters: [String: String]?) -> String {
        guard let pathParameters = pathParamters else { return path }
        
        var newPath = path
        
        for variable in getPathVariables(for: path) {
            guard let value = pathParameters[variable] else {
                preconditionFailure("Path variable: \(variable) is not in path paramaters: \(pathParameters)")
            }
            newPath = newPath.replacingOccurrences(of: "{\(variable)}", with: value)
        }
        
        return newPath
    }
    
    private func appendGlobalQuery(to queries: [String: String]?) -> [String: String]? {
        if let queries = queries, !queries.isEmpty {
            return queries.merging(globalQueries ?? [:]) {
                _,_  in preconditionFailure("Duplicate keys in query parameter: \(queries) and system wide query: \(String(describing: globalQueries))")
            }
        } else {
            return globalQueries
        }
    }
    
    private func getPathVariables(for path: String) -> [String] {
        
        let range = NSRange(location: 0, length: path.utf16.count)
        let regex = try! NSRegularExpression(pattern: "\\{.*?\\}")
        let res = regex.matches(in: path, options: [], range: range)
        
        return res
            .map { String(path[Range($0.range, in: path)!]) }
            .map { $0.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "") }
    }
}
