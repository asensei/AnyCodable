//
//  KeyedDecodingContainerProtocol+EvaluatingNil.swift
//  AnyCodable
//
//  Created by Valerio Mazzeo on 21/03/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation

public extension KeyedDecodingContainerProtocol {

    /**
     Decoding method that makes a distinction between keys which are not present, and keys which are explicitily set to `null`.

     - `nil` or `.none`: represents a missing key.
     - `"value"` or `.some("value")`: represents a value.
     - `.some(nil)`: represents `null`.
     */
    public func decodeIfPresentEvaluatingNil<T>(_ type: T.Type, forKey key: Self.Key) throws -> T?? where T: Decodable {

        guard self.contains(key) else {
            return nil
        }

        if try self.decodeNil(forKey: key) {
            return .some(nil)
        } else {
            return try self.decode(T.self, forKey: key)
        }
    }
}
