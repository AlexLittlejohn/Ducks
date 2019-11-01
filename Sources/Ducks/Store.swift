//
//  Store.swift
//  Created by Alex Littlejohn on 01/11/2019.
//

import Combine

/// This is the Redux store implementation.
/// There is no built in subscription mechanism, rather we rely on Combine to publish a stream of state updates
public class Store<S: StateType>: ObservableObject {
    
    @Published public private(set) var state: S
    
    public private(set) var dispatch: Dispatch!
    
    private var isDispatching: Bool = false
    
    /// Create a new store with a reducer and a stating state
    /// - Parameter reducer: A reducer is defined as `(action, currentState) -> newState`. It will supply the current state and create a new state in response to the supplied action
    /// - Parameter state: The starting state held by the store
    /// - Parameter middleware: Middleware contains an array of side effect handlers
    public init(reducer: @escaping Reducer<S>, state: S, middleware: [Middleware<S>] = []) {
        self.state = state
        
        self.dispatch = middleware
            .reversed()
            .reduce(
                { [unowned self] action in
                    precondition(!self.isDispatching, "PEBKAC error: don't dispatch actions from reducers.")
                    
                    self.isDispatching = true
                    let newState = reducer(action, self.state)
                    self.isDispatching = false
                    
                    self.state = newState
                },
                { dispatchFunction, middleware in
                    let curryingMiddleware = curry(middleware)
                    return curryingMiddleware(self)(dispatchFunction)
                }
        )
    }
}

private func curry<A, B, C, D>(_ function: @escaping ((A, B, C)) -> D) -> (A) -> (B) -> (C) -> D {
    { (a: A) -> (B) -> (C) -> D in { (b: B) -> (C) -> D in { (c: C) -> D in function((a, b, c)) } } }
}

