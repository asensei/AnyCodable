//
//  _AnyKeyedEncodingContainer.swift
//  AnyCodable
//
//  Created by Valerio Mazzeo on 23/03/2018.
//

import Foundation

// MARK: - Encoding Containers
struct _AnyKeyedEncodingContainer<K: CodingKey>: KeyedEncodingContainerProtocol {

    typealias Key = K

    // MARK: Properties
    /// A reference to the encoder we're writing to.
    private let encoder: _AnyEncoder

    /// A reference to the container we're writing to.
    private var container: [AnyHashable: Any]

    /// The path of coding keys taken to get to this point in encoding.
    private(set) public var codingPath: [CodingKey]

    // MARK: - Initialization
    /// Initializes `self` with the given references.
    init(referencing encoder: _AnyEncoder, codingPath: [CodingKey], wrapping container: [AnyHashable: Any]) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.container = container
    }

    // MARK: - KeyedEncodingContainerProtocol Methods

    public mutating func encodeNil(forKey key: Key) throws {
        self.container[key.stringValue] = NSNull()
    }
    public mutating func encode(_ value: Bool, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }
    public mutating func encode(_ value: Int, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }
    public mutating func encode(_ value: Int8, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }
    public mutating func encode(_ value: Int16, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }
    public mutating func encode(_ value: Int32, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }
    public mutating func encode(_ value: Int64, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }
    public mutating func encode(_ value: UInt, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }
    public mutating func encode(_ value: UInt8, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }
    public mutating func encode(_ value: UInt16, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }
    public mutating func encode(_ value: UInt32, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }
    public mutating func encode(_ value: UInt64, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }
    public mutating func encode(_ value: String, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }

    public mutating func encode(_ value: Float, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }

    public mutating func encode(_ value: Double, forKey key: Key) throws {
        self.container[key.stringValue] = value
    }

    public mutating func encode<T: Encodable>(_ value: T, forKey key: Key) throws {

        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        self.container[key.stringValue] = try self.encoder.box(value)
    }

    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {

        let dictionary = [AnyHashable: Any]()
        self.container[key.stringValue] = dictionary

        self.codingPath.append(key)
        defer { self.codingPath.removeLast() }

        let container = _AnyKeyedEncodingContainer<NestedKey>(referencing: self.encoder, codingPath: self.codingPath, wrapping: dictionary)

        return KeyedEncodingContainer(container)
    }

    public mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let array = [Any]()
        self.container[key.stringValue] = array

        self.codingPath.append(key)
        defer { self.codingPath.removeLast() }

        return _AnyUnkeyedEncodingContainer(referencing: self.encoder, codingPath: self.codingPath, wrapping: array)
    }

    public mutating func superEncoder() -> Encoder {
        return _AnyReferencingEncoder(referencing: self.encoder, key: _AnyKey.super, convertedKey: _AnyKey.super, wrapping: self.container)
    }

    public mutating func superEncoder(forKey key: Key) -> Encoder {
        return _AnyReferencingEncoder(referencing: self.encoder, key: key, convertedKey: key, wrapping: self.container)
    }
}
