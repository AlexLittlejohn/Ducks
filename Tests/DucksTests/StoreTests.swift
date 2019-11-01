import XCTest
@testable import Ducks

enum CounterActions: Action {
    case increment
    case decrement
    case set(Int)
}

struct CounterState: StateType {
    let count: Int
}

let counterReducer: Reducer<CounterState> = { action, state in
    switch action {
    case CounterActions.increment:
        return CounterState(count: state.count + 1)
    case CounterActions.decrement:
        return CounterState(count: state.count - 1)
    case CounterActions.set(let value):
        return CounterState(count: value)
    case _:
        return state
    }
}

let incrementMiddleware: Middleware<CounterState> = { store, next, action in
    let state = store.state
    
    switch action {
    case CounterActions.increment:
        next(CounterActions.set(state.count + 2)) // increment by 2
    case _:
        next(action)
    }
}

let setMiddleware: Middleware<CounterState> = { store, next, action in
    switch action {
    case CounterActions.set(let value):
        next(CounterActions.set(value * 2)) // multiply by 2
    case _:
        next(action)
    }
}

final class StoreTests: XCTestCase {

    var store: Store<CounterState>!
    
    override func setUp() {
        store = Store(reducer: counterReducer, state: CounterState(count: 0))
    }

    override func tearDown() {
        store = nil
    }

    func testDispatch() {
        store.dispatch(CounterActions.increment)
        
        XCTAssertEqual(store.state.count, 1)
        
        store.dispatch(CounterActions.decrement)
        
        XCTAssertEqual(store.state.count, 0)

        store.dispatch(CounterActions.set(5))
        
        XCTAssertEqual(store.state.count, 5)
    }
    
    func testMiddleware() {
        
        store = Store(reducer: counterReducer, state: CounterState(count: 0), middleware: [incrementMiddleware])
        
        XCTAssertEqual(store.state.count, 0)

        store.dispatch(CounterActions.increment)
        
        XCTAssertEqual(store.state.count, 2)
        
        store.dispatch(CounterActions.decrement)
        
        XCTAssertEqual(store.state.count, 1)
    }
    
    func testNonRecursiveMiddleware() {
        
        store = Store(reducer: counterReducer, state: CounterState(count: 0), middleware: [setMiddleware])
        
        XCTAssertEqual(store.state.count, 0)

        store.dispatch(CounterActions.increment)
        
        XCTAssertEqual(store.state.count, 1)
        
        store.dispatch(CounterActions.set(3))
        
        XCTAssertEqual(store.state.count, 6)
    }
    
    func testMultipleMiddleware() {
        
        store = Store(reducer: counterReducer, state: CounterState(count: 0), middleware: [incrementMiddleware, setMiddleware])
        
        XCTAssertEqual(store.state.count, 0)

        store.dispatch(CounterActions.increment)
        
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
