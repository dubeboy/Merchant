import Foundation

extension Dictionary {
    
    var debugDescription: [String] {
         self.map { "\($0): \($1)" }
    }
    
}
