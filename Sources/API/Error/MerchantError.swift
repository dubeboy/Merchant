import Foundation
import Alamofire

// maybe network error // should inherit from localizedError
public enum MerchantError: Error, LocalizedError {
    case error(localizedDescription: String)
}
