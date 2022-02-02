//
//  File.swift
//  
//
//  Created by Alex Littlejohn on 27/01/2022.
//

import Combine

public extension AnyPublisher {
    /// Return an empty result
    static var none: AnyPublisher<Output, Failure> {
        Empty<Output, Failure>(completeImmediately: false).eraseToAnyPublisher()
    }
}
