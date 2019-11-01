import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DucksTests.allTests),
        testCase(StoreTests.allTests),
    ]
}
#endif
