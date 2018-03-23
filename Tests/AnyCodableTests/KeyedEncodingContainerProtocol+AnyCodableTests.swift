//
//  KeyedEncodingContainerProtocol+AnyCodableTests.swift
//  AnyCodableTests
//
//  Created by Dale Buckley on 22/03/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import XCTest
@testable import AnyCodable

class KeyedEncodingContainerProtocolAnyCodableTests: XCTestCase {

    static let allTests = [
        ("testEncodingEmptyAnyCodable", testEncodingEmptyAnyCodable),
        ("testEncodingNSNullAnyCodable", testEncodingNSNullAnyCodable),
        ("testEncodingNonEmptyAnyCodable", testEncodingNonEmptyAnyCodable),
        ("testEncodingEmptyAutoSynthesizedAnyCodable", testEncodingEmptyAutoSynthesizedAnyCodable),
        ("testEncodingNSNullAutoSynthesizedAnyCodable", testEncodingNSNullAutoSynthesizedAnyCodable),
        ("testEncodingNonEmptyAutoSynthesizedAnyCodable", testEncodingNonEmptyAutoSynthesizedAnyCodable)
    ]

    func testEncodingEmptyAnyCodable() throws {

        let mock = MockCodable(nil)
        let data = try JSONEncoder().encode(mock)

        XCTAssertFalse(String(data: data, encoding: .utf8)!.contains("\"any\":"))

        let decoded = try JSONDecoder().decode(MockCodable.self, from: data)

        XCTAssertNil(decoded.any)
    }

    func testEncodingNSNullAnyCodable() throws {

        let mock = MockCodable(NSNull())
        let data = try JSONEncoder().encode(mock)

        XCTAssertTrue(String(data: data, encoding: .utf8)!.contains("\"any\":null"))

        let decoded = try JSONDecoder().decode(MockCodable.self, from: data)

        XCTAssertNil(decoded.any)
    }

    func testEncodingNonEmptyAnyCodable() throws {

        let mock = MockCodable("test")
        let data = try JSONEncoder().encode(mock)

        XCTAssertTrue(String(data: data, encoding: .utf8)!.contains("\"any\":\"test\""))

        let decoded = try JSONDecoder().decode(MockCodable.self, from: data)

        XCTAssertEqual(decoded.any as! String, "test")
    }

    func testEncodingEmptyAutoSynthesizedAnyCodable() throws {

        let mock = SynthesizedMockCodable(anyCodable: nil)
        let data = try JSONEncoder().encode(mock)

        XCTAssertFalse(String(data: data, encoding: .utf8)!.contains("\"anyCodable\":"))

        let decoded = try JSONDecoder().decode(SynthesizedMockCodable.self, from: data)

        XCTAssertNil(decoded.anyCodable?.value)
    }

    func testEncodingNSNullAutoSynthesizedAnyCodable() throws {

        let mock = SynthesizedMockCodable(anyCodable: AnyCodable(NSNull()))
        let data = try JSONEncoder().encode(mock)

        XCTAssertTrue(String(data: data, encoding: .utf8)!.contains("\"anyCodable\":null"))

        let decoded = try JSONDecoder().decode(SynthesizedMockCodable.self, from: data)

        XCTAssertNil(decoded.anyCodable?.value)
    }

    func testEncodingNonEmptyAutoSynthesizedAnyCodable() throws {

        let mock = SynthesizedMockCodable(anyCodable: AnyCodable("test"))
        let data = try JSONEncoder().encode(mock)

        XCTAssertTrue(String(data: data, encoding: .utf8)!.contains("\"anyCodable\":\"test\""))

        let decoded = try JSONDecoder().decode(SynthesizedMockCodable.self, from: data)

        XCTAssertEqual(decoded.anyCodable?.value as! String, "test")
    }
}

extension KeyedEncodingContainerProtocolAnyCodableTests {

    struct MockCodable: Codable {

        let any: Any?

        public init(_ any: Any? = nil) {

            self.any = any
        }

        // MARK: Codable

        private enum CodingKeys: String, CodingKey {
            case any
        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.any = try container.decodeIfPresent(AnyCodable.self, forKey: .any)?.value
        }

        public func encode(to encoder: Encoder) throws {

            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(AnyCodable(self.any), forKey: .any)
        }
    }

    struct SynthesizedMockCodable: Codable {

        let anyCodable: AnyCodable?
    }
}
