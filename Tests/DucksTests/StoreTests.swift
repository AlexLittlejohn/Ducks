import XCTest
@testable import Ducks

enum CounterActions {
    case increment
    case decrement
    case set(Int)
}

struct CounterState {
    var count: Int
}

struct CounterEnvironment { }

let counterReducer: Reducer<CounterActions, CounterState> = { action, state in
    switch action {
    case CounterActions.increment:
        state.count += 1
    case CounterActions.decrement:
        state.count -= 1
    case CounterActions.set(let value):
        state.count = value
    case _:
        break
    }
}

let incrementMiddleware: Middleware<CounterActions, CounterState, CounterEnvironment> = { store, next, environment, action in
    let state = store.state
    
    switch action {
    case CounterActions.increment:
        next(CounterActions.set(state.count + 2)) // increment by 2
    case _:
        next(action)
    }
}

let setMiddleware: Middleware<CounterActions, CounterState, CounterEnvironment> = { store, next, environment, action in
    switch action {
    case CounterActions.set(let value):
        next(CounterActions.set(value * 2)) // multiply by 2
    case _:
        next(action)
    }
}

final class StoreTests: XCTestCase {

    var store: Store<CounterActions, CounterState, CounterEnvironment>!
    
    override func setUp() {
        store = Store(reducer: counterReducer, state: CounterState(count: 0), environment: CounterEnvironment())
    }

    override func tearDown() {
        store = nil
    }

    func testDispatch() {
        store.send(CounterActions.increment)
        
        XCTAssertEqual(store.state.count, 1)
        
        store.send(CounterActions.decrement)
        
        XCTAssertEqual(store.state.count, 0)

        store.send(CounterActions.set(5))
        
        XCTAssertEqual(store.state.count, 5)
    }
    
    func testMiddleware() {
        
        store = Store(reducer: counterReducer, state: CounterState(count: 0), middleware: [incrementMiddleware], environment: CounterEnvironment())
        
        XCTAssertEqual(store.state.count, 0)

        store.send(CounterActions.increment)
        
        XCTAssertEqual(store.state.count, 2)
        
        store.send(CounterActions.decrement)
        
        XCTAssertEqual(store.state.count, 1)
    }
    
    func testNonRecursiveMiddleware() {
        
        store = Store(reducer: counterReducer, state: CounterState(count: 0), middleware: [setMiddleware], environment: CounterEnvironment())
        
        XCTAssertEqual(store.state.count, 0)

        store.send(CounterActions.increment)
        
        XCTAssertEqual(store.state.count, 1)
        
        store.send(CounterActions.set(3))
        
        XCTAssertEqual(store.state.count, 6)
    }
    
    func testMultipleMiddleware() {
        
        store = Store(reducer: counterReducer, state: CounterState(count: 0), middleware: [incrementMiddleware, setMiddleware], environment: CounterEnvironment())
        
        XCTAssertEqual(store.state.count, 0)

        store.send(CounterActions.increment)
        
        // increment is replaced with set
        // set multiplies its value * 2 i.e. (0 + 2) * 2
        XCTAssertEqual(store.state.count, 4)
    }
    
    static var allTests = [
        ("testDispatch", testDispatch),
        ("testMiddleware", testMiddleware),
        ("testNonRecursiveMiddleware", testNonRecursiveMiddleware),
        ("testMultipleMiddleware", testMultipleMiddleware),
    ]
}
