//
//  _AnyUnkeyedEncodingContainer.swift
//  AnyCodable
//
//  Created by Valerio Mazzeo on 23/03/2018.
//

import Foundation

struct _AnyUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    // MARK: Properties
    /// A reference to the encoder we're writing to.
    private let encoder: _AnyEncoder

    /// A reference to the container we're writing to.
    private var container: [Any]

    /// The path of coding keys taken to get to this point in encoding.
    private(set) public var codingPath: [CodingKey]

    /// The number of elements encoded into the container.
    public var count: Int {
        return self.container.count
    }

    // MARK: - Initialization
    /// Initializes `self` with the given references.
    init(referencing encoder: _AnyEncoder, codingPath: [CodingKey], wrapping container: [Any]) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.container = container
    }

    // MARK: - UnkeyedEncodingContainer Methods
    public mutating func encodeNil()             throws { self.container.append(NSNull()) }
    public mutating func encode(_ value: Bool)   throws { self.container.append(value) }
    public mutating func encode(_ value: Int)    throws { self.container.append(value) }
    public mutating func encode(_ value: Int8)   throws { self.container.append(value) }
    public mutating func encode(_ value: Int16)  throws { self.container.append(value) }
    public mutating func encode(_ value: Int32)  throws { self.container.append(value) }
    public mutating func encode(_ value: Int64)  throws { self.container.append(value) }
    public mutating func encode(_ value: UInt)   throws { self.container.append(value) }
    public mutating func encode(_ value: UInt8)  throws { self.container.append(value) }
    public mutating func encode(_ value: UInt16) throws { self.container.append(value) }
    public mutating func encode(_ value: UInt32) throws { self.container.append(value) }
    public mutating func encode(_ value: UInt64) throws { self.container.append(value) }
    public mutating func encode(_ value: String) throws { self.container.append(value) }
    public mutating func encode(_ value: Float)  throws { self.container.append(value) }
    public mutating func encode(_ value: Double) throws { self.container.append(value) }

    public mutating func encode<T: Encodable>(_ value: T) throws {

        self.encoder.codingPath.append(_AnyKey(index: self.count))
        defer { self.encoder.codingPath.removeLast() }
        self.container.append(try self.encoder.box(value))
    }

    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        self.codingPath.append(_AnyKey(index: self.count))
        defer { self.codingPath.removeLast() }

        let dictionary = [AnyHashable: Any]()
        self.container.append(dictionary)

        let container = _AnyKeyedEncodingContainer<NestedKey>(referencing: self.encoder, codingPath: self.codingPath, wrapping: dictionary)
        return KeyedEncodingContainer(container)
    }

    public mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        self.codingPath.append(_AnyKey(index: self.count))
        defer { self.codingPath.removeLast() }

        let array = [Any]()
        self.container.append(array)
        return _AnyUnkeyedEncodingContainer(referencing: self.encoder, codingPath: self.codingPath, wrapping: array)
    }

    public mutating func superEncoder() -> Encoder {
        return _AnyReferencingEncoder(referencing: self.encoder, at: self.container.count, wrapping: self.container)
    }
}
