//
//  Store.swift
//
//
//  Created by Alex Littlejohn on 01/11/2019.
//

public typealias Dispatch<A> = (A) -> Void

/// A `Reducer` is a pure function that receives an action and the current state. Since state is provided as an `inout` parameter, it is protected from asynchronous access and escaping functions. This essentially protects it from side effects which should be extracted to `Middleware`.
public typealias Reducer<A, S> = (A, inout S) -> Void

/// `Middleware` is a function that should contain any side effects such as networking, logging or database access. We can also ensure that it remains pure by providing all the necessary dependancies using the environment object.
public typealias Middleware<A, S, E> = (_ store: Store<A, S, E>, _ next: @escaping Dispatch<A>, _ environment: E, _ action: A) -> Void
