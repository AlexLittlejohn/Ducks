import Combine
import XCTest
@testable import Ducks

enum CounterActions {
    case increment
    case decrement
    case set(Int)
}

struct CounterState: Equatable {
    var count: Int
}

struct CounterEnvironment { }

private let counterReducer: Reducer<CounterActions, CounterState, CounterEnvironment> = { action, state, environment in
    switch action {
    case .increment:
        state.count += 1
        return .none
    case .decrement:
        state.count -= 1
        return .none
    case .set(_):
        return Just(.increment).eraseToAnyPublisher()
    }
}

final class StoreTests: XCTestCase {
    struct Label {
        var text: String?
    }

    var store: Store<CounterActions, CounterState, CounterEnvironment>!

    var token: AnyCancellable!
    var label: Label!

    override func setUp() {
        store = Store<CounterActions, CounterState, CounterEnvironment>(reducer: counterReducer, state: CounterState(count: 0), environment: CounterEnvironment())
        label = Label()
    }

    override func tearDown() {
        label = nil
        store = nil
        token = nil
    }

    func testDispatch() {
        store.send(CounterActions.increment)

        XCTAssertEqual(store.state.count, 1)

        store.send(CounterActions.decrement)

        XCTAssertEqual(store.state.count, 0)

        store.send(CounterActions.set(5))

        XCTAssertEqual(store.state.count, 1)
    }

    func testSubscription() {
        token = store.statePublisher.map(\.count).map(String.init).assign(to: \.label.text, on: self)

        XCTAssertEqual(label.text, "0")

        store.send(CounterActions.increment)

        XCTAssertEqual(label.text, "1")
    }

    func testSubscriptionCleanup() {
        token = store.statePublisher.map(\.count).map(String.init).assign(to: \.label.text, on: self)

        XCTAssertEqual(label.text, "0")

        store.send(CounterActions.increment)

        XCTAssertEqual(label.text, "1")

        token = nil

        store.send(CounterActions.increment)

        XCTAssertEqual(label.text, "1")
    }
}
