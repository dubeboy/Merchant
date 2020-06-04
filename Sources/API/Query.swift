import Foundation

public protocol Query: Decodable, Hashable, CaseIterable, RawRepresentable where RawValue == String { }

public enum Default: String, Query {
    case void
}

