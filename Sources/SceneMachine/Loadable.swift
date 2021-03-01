//
//  Loadable.swift
//  SceneMachine
//
//  Created by Duy Tran on 10/3/20.
//

import Foundation

/// A type that can be loaded with the latency.
public enum Loadable<T> {
    
    case isLoading(last: T?)
    case loaded(T)
    case failed(Error)
    
    /// Some resources that was loaded,
    /// or nil if the loading process was failed or hasn't been finished.
    public var value: T? {
        switch self {
        case let .loaded(value):
            return value
        case let .isLoading(last):
            return last
        case .failed:
            return nil
        }
    }
    
    /// An error object that indicates why the loading process failed,
    /// or nil if the loading process was successful.
    public var error: Error? {
        switch self {
        case let .failed(error):
            return error
        case .isLoading, .loaded:
            return nil
        }
    }
}

extension Loadable: Equatable where T: Equatable {
    
    public static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case let (.isLoading(lhsItem), .isLoading(rhsItem)):
            return lhsItem == rhsItem
        case let (.loaded(lhsItem), .loaded(rhsItem)):
            return lhsItem == rhsItem
        case let (.failed(lhsError), .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
