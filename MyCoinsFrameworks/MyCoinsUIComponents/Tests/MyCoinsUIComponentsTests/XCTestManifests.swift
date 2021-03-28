import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MyCoinsUIComponentsTests.allTests),
    ]
}
#endif
