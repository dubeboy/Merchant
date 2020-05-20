import Foundation

protocol Interceptor {
    var headers: [String: String] { get set } // todo
    
    func adapt() // todo
}
