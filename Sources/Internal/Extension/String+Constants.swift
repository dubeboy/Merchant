import Foundation

extension String {
    static let errorMethodGet = "You cannot get this value"
    static let errorMethodSet = "You cannot set this value"
    
    static let errorNilInstance = "Nil Merchant instance. Try propertyWrapping your service struct with @Autowired"
    
    static let errorDuplicateKeys = "Duplicate keys in query parameter: %s and system wide query: %s"
    
    static let errorNilResponse = "❌ Nil response"
    
    static let errorNoneMatchingPathVariables = "Path variable: %s is not in path paramaters: %s"
    
    static let errorMalformedURL = "Failed to create URL from url components. baseURL: %s, path: %s and query parameters: %s"
    
    static let errorNilRequest = "❌ Nil URLRequest"
    
    static let errorUnexpected = "❌ An unexpected error happened, Please log bug on <github,com/>"
    
}
