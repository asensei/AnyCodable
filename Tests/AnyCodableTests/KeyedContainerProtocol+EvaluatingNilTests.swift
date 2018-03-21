//
//  KeyedContainerProtocol+EvaluatingNilTests.swift
//  AnyCodableTests
//
//  Created by Valerio Mazzeo on 21/03/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import XCTest
@testable import AnyCodable

class KeyedContainerProtocolEvaluatingNilTests: XCTestCase {

    static let allTests = [
        ("testSome", testSome),
        ("testMissingKey", testMissingKey),
        ("testNilKey", testNilKey)
    ]

    func testSome() throws {

        let data = try JSONEncoder().encode(MockCodable("test"))

        let decoded = try JSONDecoder().decode(MockCodable.self, from: data)

        XCTAssertTrue(decoded.attribute != nil)
        XCTAssertEqual(decoded.attribute!, "test")
        XCTAssertEqual(decoded.attribute!!, "test")
    }

    func testMissingKey() throws {

        let data = try JSONEncoder().encode(MockCodable(nil))

        let decoded = try JSONDecoder().decode(MockCodable.self, from: data)

        XCTAssertTrue(decoded.attribute == nil)
    }

    func testNilKey() throws {

        let data = try JSONEncoder().encode(MockCodable(.some(nil)))

        let decoded = try JSONDecoder().decode(MockCodable.self, from: data)

        XCTAssertNil(decoded.attribute!)
        XCTAssertTrue(decoded.attribute != nil)
    }
}

extension KeyedContainerProtocolEvaluatingNilTests {

    struct MockCodable: Codable {

        let attribute: String??

        init(_ attribute: String??) {
            self.attribute = attribute
        }

        init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.attribute = try container.decodeIfPresentEvaluatingNil(String.self, forKey: .attribute)
        }
    }
}
