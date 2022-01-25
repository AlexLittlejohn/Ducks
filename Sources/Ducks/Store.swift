//
//  Store.swift
//  Created by Alex Littlejohn on 01/11/2019.
//

import Combine
import Foundation

/// This is the Redux store implementation.
/// There is no built in subscription mechanism, rather we rely on Combine to publish a stream of state updates
public class Store<A, S, E>: ObservableObject {
    
    @Published public private(set) var state: S
    
    public private(set) var send: Dispatch<A> = { _ in }
    
    private var isDispatching: Bool = false
    
    /// Create a new store with a reducer and a stating state
    /// - Parameter reducer: A reducer is defined as `(action, currentState) -> newState`. It will supply the current state for modifications in response to the supplied action.
    /// - Parameter state: The initial state held by the store
    /// - Parameter middleware: Middleware contains an array of side effect handlers
    /// - Parameter environment: A collection of all the dependencies required for this feature to operate. It will be supplied to the middleware to allow for usage during side effects.
    public init(reducer: @escaping Reducer<A, S>, state: S, middleware: [Middleware<A, S, E>] = [], environment: E) {
        self.state = state
        
        self.send = middleware
            .reversed()
            .reduce(
                { [unowned self] action in
                    precondition(Thread.isMainThread, "You can only dispatch actions from the main thread.")
                    precondition(!self.isDispatching, "PEBKAC error: don't dispatch actions from reducers.")
                    
                    self.isDispatching = true
                    reducer(action, &self.state)
                    self.isDispatching = false
                },
                { dispatchFunction, middleware in
                    let curryingMiddleware = curry(middleware)
                    return curryingMiddleware(self)(dispatchFunction)(environment)
                }
            )
    }
}

private func curry<A, B, C, D, E>(_ function: @escaping ((A, B, C, D)) -> E) -> (A) -> (B) -> (C) -> (D) -> E {
    { (a: A) -> (B) -> (C) -> (D) -> E in { (b: B) -> (C) -> (D) -> E in { (c: C) -> (D) -> E in { (d: D) -> E in function((a, b, c, d)) } } } }
}

