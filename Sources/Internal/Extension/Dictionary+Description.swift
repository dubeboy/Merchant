import Foundation

// customStringDebuggable
extension Dictionary {
    
    var debugDescription: [String] {
         self.map { "\($0): \($1)" }
    }
    
}
