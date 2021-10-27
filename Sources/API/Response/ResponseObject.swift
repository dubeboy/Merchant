import Foundation
import Alamofire

// Should probably be namespaced
public struct ResponseObject<T: Decodable> {
    public let body: T
    public let statusCode: Int
    public let raw: AFDataResponse<T>
}
