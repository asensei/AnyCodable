This repository is no longer maintained. It was meant as an experiment to explore if it was possible to make Codable works with undefined data structures.

We came to the conclusion that there are too many edge cases, and we have since then completely moved away from fuzzy decoding of Any types.

# AnyCodable

![Swift](https://img.shields.io/badge/swift-4.0.3-brightgreen.svg)
[![Build Status](https://travis-ci.org/asensei/AnyCodable.svg?branch=master)](https://travis-ci.org/asensei/AnyCodable)
[![CocoaPods](https://img.shields.io/cocoapods/v/AnyCodable.svg)](https://cocoapods.org/)

## Overview

Generic `Any?` data encapsulation meant to facilitate the transformation of loosely typed objects using Codable.

## License

Copyright © 2018 [Asensei](https://www.asensei.com). All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
