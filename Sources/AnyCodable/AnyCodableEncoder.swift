//
//  AnyCodableEncoder.swift
//  AnyCodable
//
//  Created by Valerio Mazzeo on 23/03/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation

/// `AnyEncoder` facilitates the encoding of `Encodable` values into Any.
open class AnyEncoder {

    public init() {

    }

    open func encode<T: Encodable>(_ value: T) throws -> Any {
        fatalError()
        //let encoder = _AnyEncoder()

    }
}


/// Internal `Encoder` implementation for `AnyEncoder`.
class _AnyEncoder: Encoder {

    /// See `Encoder.codingPath`
    var codingPath: [CodingKey]

    /// See `Encoder.codingPath`
    var userInfo: [CodingUserInfoKey: Any]

    var storage: _AnyEncodingStorage

    /// Returns whether a new element can be encoded at this coding path.
    ///
    /// `true` if an element has not yet been encoded at this coding path; `false` otherwise.
    var canEncodeNewValue: Bool {
        // Every time a new value gets encoded, the key it's encoded for is pushed onto the coding path (even if it's a nil key from an unkeyed container).
        // At the same time, every time a container is requested, a new value gets pushed onto the storage stack.
        // If there are more values on the storage stack than on the coding path, it means the value is requesting more than one container, which violates the precondition.
        //
        // This means that anytime something that can request a new container goes onto the stack, we MUST push a key onto the coding path.
        // Things which will not request containers do not need to have the coding path extended for them (but it doesn't matter if it is, because they will not reach here).
        return self.storage.count == self.codingPath.count
    }

    /// Creates a new internal `_CodableDataEncoder`.
    init(codingPath: [CodingKey] = []) {
        self.codingPath = codingPath
        self.userInfo = [:]
        self.storage = _AnyEncodingStorage()
    }

    /// See `Encoder.container`
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {

        // If an existing keyed container was already requested, return that one.
        let topContainer: [AnyHashable: Any]

        if self.canEncodeNewValue {
            // We haven't yet pushed a container at this level; do so here.
            topContainer = self.storage.pushKeyedContainer()
        } else {
            guard let container = self.storage.containers.last as? [AnyHashable: Any] else {
                preconditionFailure("Attempt to push new keyed encoding container when already previously encoded at this path.")
            }

            topContainer = container
        }

        let container = _AnyKeyedEncodingContainer<Key>(referencing: self, codingPath: self.codingPath, wrapping: topContainer)

        return KeyedEncodingContainer(container)
    }

    /// See `Encoder.unkeyedContainer`
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError()
    }

    /// See `Encoder.singleValueContainer`
    func singleValueContainer() -> SingleValueEncodingContainer {
        fatalError()
    }
}

extension _AnyEncoder {

    func box<T: Encodable>(_ value: T) throws -> Any {

        // The value should request a container from the _JSONEncoder.
        let depth = self.storage.count
        do {
            try value.encode(to: self)
        } catch {
            // If the value pushed a container before throwing, pop it back off to restore state.
            if self.storage.count > depth {
                let _ = self.storage.popContainer()
            }

            throw error
        }

        // The top container should be a new container.
        guard self.storage.count > depth else {
            return [AnyHashable: Any]()
        }

        return self.storage.popContainer()
    }
}

struct _AnyEncodingStorage {

    private(set) internal var containers: [Any] = []

    init() {}

    var count: Int {
        return self.containers.count
    }

    mutating func pushKeyedContainer() -> [AnyHashable: Any] {
        let dictionary = [AnyHashable: Any]()
        self.containers.append(dictionary)

        return dictionary
    }

    mutating func pushUnkeyedContainer() -> [Any] {
        let array = [Any]()
        self.containers.append(array)

        return array
    }

    mutating func push(container: Any) {
        self.containers.append(container)
    }

    mutating func popContainer() -> Any {
        precondition(!self.containers.isEmpty, "Empty container stack.")

        return self.containers.popLast()!
    }
}

class _AnyReferencingEncoder: _AnyEncoder {
    // MARK: Reference types.
    /// The type of container we're referencing.
    private enum Reference {
        /// Referencing a specific index in an array container.
        case array([Any], Int)

        /// Referencing a specific key in a dictionary container.
        case dictionary([AnyHashable: Any], String)
    }

    // MARK: - Properties
    /// The encoder we're referencing.
    let encoder: _AnyEncoder

    /// The container reference itself.
    private let reference: Reference

    // MARK: - Initialization
    /// Initializes `self` by referencing the given array container in the given encoder.
    init(referencing encoder: _AnyEncoder, at index: Int, wrapping array: [Any]) {
        self.encoder = encoder
        self.reference = .array(array, index)
        super.init(codingPath: encoder.codingPath)

        self.codingPath.append(_AnyKey(index: index))
    }

    /// Initializes `self` by referencing the given dictionary container in the given encoder.
    init(referencing encoder: _AnyEncoder,
                     key: CodingKey, convertedKey: CodingKey, wrapping dictionary: [AnyHashable: Any]) {
        self.encoder = encoder
        self.reference = .dictionary(dictionary, convertedKey.stringValue)
        super.init(codingPath: encoder.codingPath)

        self.codingPath.append(key)
    }

    // MARK: - Coding Path Operations
    override var canEncodeNewValue: Bool {
        // With a regular encoder, the storage and coding path grow together.
        // A referencing encoder, however, inherits its parents coding path, as well as the key it was created for.
        // We have to take this into account.
        return self.storage.count == self.codingPath.count - self.encoder.codingPath.count - 1
    }

    // MARK: - Deinitialization
    // Finalizes `self` by writing the contents of our storage to the referenced encoder's storage.
    deinit {
        let value: Any
        switch self.storage.count {
        case 0: value = [AnyHashable: Any]()
        case 1: value = self.storage.popContainer()
        default: fatalError("Referencing encoder deallocated with multiple containers on stack.")
        }

        switch self.reference {
        case .array(var array, let index):
            array.insert(value, at: index)

        case .dictionary(var dictionary, let key):
            dictionary[key] = value
        }
    }
}
