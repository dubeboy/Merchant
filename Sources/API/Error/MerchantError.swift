import Foundation
import Alamofire

// maybe network error
public enum MerchantError: Error {
    case error(localizedDescription: String)
}
