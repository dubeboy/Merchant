import Foundation

/// The StringRepresentable
public protocol StringRepresentable {
    
    /// The String Representation
    var stringRepresentation: String { get }
    
}

// MARK: - String+StringRepresentable
extension String: StringRepresentable {
    
    /// The String Representation
    public var stringRepresentation: String {
        return self
    }
    
}

// MARK: - Double+StringRepresentable
extension Double: StringRepresentable {
    
    /// The String Representation
    public var stringRepresentation: String {
        return .init(self)
    }
    
}

// MARK: - Float+StringRepresentable
extension Float: StringRepresentable {
    
    /// The String Representation
    public var stringRepresentation: String {
        return .init(self)
    }
    
}

// MARK: - Int+StringRepresentable
extension Int: StringRepresentable {
    
    /// The String Representation
    public var stringRepresentation: String {
        return .init(self)
    }
    
}

// MARK: - Int8+StringRepresentable
extension Int8: StringRepresentable {
    
    /// The String Representation
    public var stringRepresentation: String {
        return .init(self)
    }
    
}

// MARK: - Int16+StringRepresentable
extension Int16: StringRepresentable {
    
    /// The String Representation
    public var stringRepresentation: String {
        return .init(self)
    }
    
}

// MARK: - Int32+StringRepresentable
extension Int32: StringRepresentable {
    
    /// The String Representation
    public var stringRepresentation: String {
        return .init(self)
    }
    
}

// MARK: - Int64+StringRepresentable
extension Int64: StringRepresentable {
    
    /// The String Representation
    public var stringRepresentation: String {
        return .init(self)
    }
    
}

// MARK: - UInt+StringRepresentable
extension UInt: StringRepresentable {
    
    /// The String Representation
    public var stringRepresentation: String {
        return .init(self)
    }
    
}

// MARK: - UInt8+StringRepresentable
extension UInt8: StringRepresentable {
    
    /// The String Representation
    public var stringRepresentation: String {
        return .init(self)
    }
    
}

// MARK: - UInt16+StringRepresentable
extension UInt16: StringRepresentable {
    
    /// The String Representation
    public var stringRepresentation: String {
        return .init(self)
    }
    
}

// MARK: - UInt32+StringRepresentable
extension UInt32: StringRepresentable {
    
    /// The String Representation
    public var stringRepresentation: String {
        return .init(self)
    }
    
}

// MARK: - UInt64+StringRepresentable
extension UInt64: StringRepresentable {
    
    /// The String Representation
    public var stringRepresentation: String {
        return .init(self)
    }
    
}
