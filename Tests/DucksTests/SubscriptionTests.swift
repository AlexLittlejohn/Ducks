//
//  SubscriptionTests.swift
//  
//
//  Created by Alex Littlejohn on 01/11/2019.
//

import Combine
import XCTest

@testable import Ducks

struct Label {
    var text: String?
}

final class SubscriptionTests: XCTestCase {

    var store: Store<CounterState>!
    var token: AnyCancellable!
    var label: Label!
    
    override func setUp() {
        label = Label()
        store = Store(reducer: counterReducer, state: CounterState(count: 0))
    }

    override func tearDown() {
        label = nil
        store = nil
        token = nil
    }
    
    func testSubscription() {
        token = store.$state.map(\.count).map(String.init).assign(to: \.label.text, on: self)
        
        XCTAssertEqual(label.text, "0")
        
        store.dispatch(CounterActions.increment)
        
        XCTAssertEqual(label.text, "1")
    }
    
    func testSubscriptionCleanup() {
        token = store.$state.map(\.count).map(String.init).assign(to: \.label.text, on: self)
        
        XCTAssertEqual(label.text, "0")
        
        store.dispatch(CounterActions.increment)
        
        XCTAssertEqual(label.text, "1")
        
        token = nil
        
        store.dispatch(CounterActions.increment)
        
        XCTAssertEqual(label.text, "1")
    }

    static var allTests = [
        ("testSubscription", testSubscription),
        ("testSubscriptionCleanup", testSubscriptionCleanup),
    ]
}
