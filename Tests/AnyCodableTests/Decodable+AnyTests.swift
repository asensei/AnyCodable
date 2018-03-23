//
//  Decodable+AnyTests.swift
//  AnyCodable
//
//  Created by Valerio Mazzeo on 23/03/2018.
//

import XCTest
@testable import AnyCodable

class DecodableAnyTests: XCTestCase {

    static let allTests = [
        ("testInitialization", testInitialization)
    ]

    func testInitialization() throws {

        let person = Person(name: "Johnny")
        let pet = try Pet(from: person)

        XCTAssertEqual(pet.name, person.name)
    }
}

extension DecodableAnyTests {

    struct Person: Codable {
        let name: String
    }

    struct Pet: Codable {
        let name: String
    }
}
