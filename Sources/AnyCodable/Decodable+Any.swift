//
//  Decodable+Any.swift
//  AnyCodable
//
//  Created by Valerio Mazzeo on 23/03/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation

public extension Decodable {

    public init<T: Encodable>(from encodable: T) throws {

        self = try AnyDecoder().decode(Self.self, from: AnyEncoder().encode(encodable))
    }
}
