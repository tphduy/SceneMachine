//
//  AnySceneMachine.swift
//  SceneMachine
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation

/// Type erasure implementation of `SceneMachine`
public struct AnySceneMachine<Item: Emptiable>: SceneMachine {
    
    // MARK: - SceneMachine
    
    public func present(
        _ state: Loadable<Item>,
        by provider: SceneMachineViewProvider) {
        presentHandler(state, provider)
    }
    
    // MARK: - Private
    
    private let presentHandler: (Loadable<Item>, SceneMachineViewProvider) -> Void
    
    // MARK: - Init
    
    public init<S: SceneMachine>(_ source: S) where S.Item == Item {
        self.presentHandler = source.present
    }
}
