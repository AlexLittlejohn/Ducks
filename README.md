![header](./header.png)

- - - -
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/alexlittlejohn/ducks/Swift)](https://github.com/AlexLittlejohn/Ducks/actions) [![License MIT](https://img.shields.io/github/license/alexlittlejohn/ducks)](https://opensource.org/licenses/MIT) [![Swift 5.5](https://img.shields.io/badge/swift-5.5-blue)](./) [![codecov](https://codecov.io/gh/AlexLittlejohn/Ducks/branch/master/graph/badge.svg?token=R65EFKRU56)](https://codecov.io/gh/AlexLittlejohn/Ducks)
---

# Overview

Ducks is a micro Redux implementation that borrows "a lot" of inspiration from the [Composable Architecture](ComposableArchitecture). However, it is designed to be much simpler and a more barebones offering.  

[ComposableArchitecture]: https://github.com/pointfreeco/swift-composable-architecture

## Installation
Ducks supports installation through SPM on iOS 13, macOS 10.15, tvOS & watchOS.

Simply add Ducks to your package manifest.

```swift
dependencies: [
    .package(url: "https://github.com/alexLittlejohn/ducks.git", from: "1.0.0")
]
```

## Examples

Check the Examples directory for the example app which will showcase how to use the framework as well as how to write tests for your features that use this library.
