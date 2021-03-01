//
//  Emptiable.swift
//  SceneMachine
//
//  Created by Duy Tran on 10/3/20.
//

import Foundation

/// A type that can be empty
public protocol Emptiable {
    
    /// A Boolean value indicating whether it is empty.
    var isEmpty: Bool { get }
}

extension Array: Emptiable {}
