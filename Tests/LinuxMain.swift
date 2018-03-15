//
//  LinuxMain.swift
//  AnyCodable
//
//  Created by Valerio Mazzeo on 14/03/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

#if os(Linux)

import XCTest
@testable import AnyCodableTests

XCTMain([
    testCase(AnyCodableTests.allTests)
])

#endif
