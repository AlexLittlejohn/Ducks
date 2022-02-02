//
//  Store.swift
//  Created by Alex Littlejohn on 01/11/2019.
//

import Combine
import Foundation
import SwiftUI

public typealias Reducer<A, S: Equatable, E> = (A, inout S, E) -> AnyPublisher<A, Never>

/// This is the Redux store implementation.
/// There is no built in subscription mechanism, rather we rely on Combine to publish a stream of state updates
public class Store<A, S: Equatable, E>: ObservableObject {

    @Published public private(set) var state: S

    public private(set) lazy var statePublisher = $state.removeDuplicates().share().eraseToAnyPublisher()

    public func send(_ action: A, animation: Animation? = nil) {
        if let animation = animation {
            withAnimation(animation) {
                actionSubject.send(action)
            }
        } else {
            actionSubject.send(action)
        }
    }

    private var actionSubject = PassthroughSubject<A, Never>()

    private var cancellables = Set<AnyCancellable>()

    /// Create a new store with a reducer and a stating state
    /// - Parameter reducer: A reducer is defined as `(action, currentState, environment) -> AnyPublisher<Action, Never>`. It will supply the current state for modifications in response to the supplied action. Can return a stream of actions to execute in response or a simple return `.none` if no further work is required.
    /// - Parameter state: The initial state held by the store
    /// - Parameter environment: A collection of all the dependencies required for this feature to operate. It will be supplied to the middleware to allow for usage during side effects.
    public init(reducer: @escaping Reducer<A, S, E>, state: S, environment: E) {
        self.state = state

        self.actionSubject.flatMap { action -> AnyPublisher<A, Never> in
            return reducer(action, &self.state, environment)
        }.sink { action in
            self.send(action)
        }.store(in: &cancellables)
    }
}
