//
//  KeyedEncodingContainerProtocol+AnyCodable.swift
//  AnyCodable
//
//  Created by Valerio Mazzeo on 22/03/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation

public extension KeyedEncodingContainerProtocol {

    public mutating func encodeIfPresent(_ value: AnyCodable?, forKey key: Self.Key) throws {

        guard let someValue = value, someValue.value != nil else {
            return
        }

        try self.encode(someValue, forKey: key)
    }
}
