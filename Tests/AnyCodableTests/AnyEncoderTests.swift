//
//  AnyEncoderTests.swift
//  AnyCodable
//
//  Created by Valerio Mazzeo on 23/03/2018.
//

import XCTest
@testable import AnyCodable

class AnyEncoderTests: XCTestCase {

    static let allTests = [
        ("testAnyEncoder", testAnyEncoder)
    ]

    func testAnyEncoder() throws {

        let value = MockCodable(
            array: [
                MockCodable(array: nil, dictionary: nil),
                MockCodable(array: nil, dictionary: nil)
            ],
            dictionary: [
                "key": MockCodable(array: nil, dictionary: nil),
                "anotherKey": MockCodable(array: nil, dictionary: nil)
            ]
        )

        let encodedValue = try AnyEncoder().encode(value)

        let decodedValue = try AnyDecoder().decode(MockCodable.self, from: encodedValue)

        XCTAssertEqual(decodedValue.string, "test")
        XCTAssertEqual(decodedValue.int, -4)
        XCTAssertEqual(decodedValue.int8, -5)
        XCTAssertEqual(decodedValue.int16, -6)
        XCTAssertEqual(decodedValue.int32, -7)
        XCTAssertEqual(decodedValue.int64, -8)
        XCTAssertEqual(decodedValue.uint, 4)
        XCTAssertEqual(decodedValue.uint8, 5)
        XCTAssertEqual(decodedValue.uint16, 6)
        XCTAssertEqual(decodedValue.uint32, 7)
        XCTAssertEqual(decodedValue.uint64, 8)
        XCTAssertEqual(decodedValue.float, 5.0)
        XCTAssertEqual(decodedValue.double, 6.0)
        XCTAssertTrue(decodedValue.bool)
        XCTAssertNotNil(decodedValue.array)
        XCTAssertEqual(decodedValue.array?.count, 2)
        XCTAssertNotNil(decodedValue.dictionary)
        XCTAssertEqual(decodedValue.dictionary?.count, 2)
        XCTAssertNotNil(decodedValue.dictionary?["key"])
        XCTAssertNotNil(decodedValue.dictionary?["anotherKey"])
    }
}

extension AnyEncoderTests {

    struct MockCodable: Codable {

        let string: String = "test"

        let int: Int = -4
        let int8: Int8 = -5
        let int16: Int16 = -6
        let int32: Int32 = -7
        let int64: Int64 = -8

        let uint: UInt = 4
        let uint8: UInt8 = 5
        let uint16: UInt16 = 6
        let uint32: UInt32 = 7
        let uint64: UInt64 = 8

        let float: Float = 5.0
        let double: Double = 6.0

        let bool: Bool = true

        let array: [MockCodable]?
        let dictionary: [String: MockCodable]?
    }
}
