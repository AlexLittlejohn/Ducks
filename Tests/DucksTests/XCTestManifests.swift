import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(StoreTests.allTests),
        testCase(SubscriptionTests.allTests),
    ]
}
#endif
