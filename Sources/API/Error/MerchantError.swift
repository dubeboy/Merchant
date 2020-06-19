import Foundation
import Alamofire

// maybe network error // should inherit from localizedError
public enum MerchantError: Error {
    case error(localizedDescription: String)
}
