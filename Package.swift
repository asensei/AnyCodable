// swift-tools-version:4.0

//
//  Package.swift
//  AnyCodable
//
//  Created by Valerio Mazzeo on 14/03/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import PackageDescription

let package = Package(

    name: "AnyCodable",

    products: [
      .library(name: "AnyCodable", targets: ["AnyCodable"])
    ],

    targets: [
        .target(name: "AnyCodable"),
        .testTarget(name: "AnyCodableTests", dependencies: ["AnyCodable"])
    ]
)
