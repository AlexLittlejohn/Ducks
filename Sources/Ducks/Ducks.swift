//
//  Store.swift
//
//
//  Created by Alex Littlejohn on 01/11/2019.
//

public protocol Action { }

public protocol StateType { }

public typealias Dispatch = (Action) -> Void

public typealias Reducer<S> = (Action, S) -> S

public typealias Middleware<S: StateType> = (_ store: Store<S>, _ next: @escaping Dispatch, _ action: Action) -> Void

public typealias Subscriber<S: StateType> = (S) -> Void
