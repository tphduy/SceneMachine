//
//  SceneMachine.swift
//  SceneMachine
//
//  Created by Duy Tran on 10/3/20.
//

import UIKit

/// An object that manages the stateful views covering up underlying content.
public protocol SceneMachine {
    
    associatedtype Item: Emptiable
    
    /// Cover underlying content view up with a stateful view,
    /// that is associated with the current state.
    /// - Parameters:
    ///   - state: The current state.
    ///   - provider: The view provider, that provides the associated stateful view.
    func present(
        state: Loadable<Item>,
        provider: SceneMachineViewProvider)
}

extension SceneMachine {
    
    /// Wraps this object with a type erasure.
    /// - Returns: An `AnySceneMachine` wrapping this object.
    public func eraseToAnySceneMachine() -> AnySceneMachine<Item> {
        AnySceneMachine(self)
    }
}

/// A default implementation of `SceneMachine`
public struct DefaultSceneMachine<Item: Emptiable>: SceneMachine {
    
    public init() {}
    
    public func present(
        state: Loadable<Item>,
        provider: SceneMachineViewProvider) {
        let view: UIView
        switch state {
        case .isLoading(.some):
            view = provider.contentView
        case .isLoading(.none):
            view = provider.loadingView()
        case let .loaded(item):
            view = item.isEmpty
                ? provider.emptyView()
                : provider.contentView
        case let .failed(error):
            view = provider.errorView(error: error)
        }
        
        present(
            statefulView: view,
            parentView: provider.parentView,
            constrainedTargetView: provider.constrainedTargetView)
    }
    
    /// Presents a stateful view over the current content.
    /// - Parameters:
    ///   - view: A view to display over the current content.
    ///   - parentView: A view that the stateful view should be added as subview.
    ///   - constrainedTargetView: A view that the stateful view should be constrained to.
    func present(
        statefulView: UIView,
        parentView: UIView,
        constrainedTargetView: UIView) {
        if statefulView.isDescendant(of: parentView) {
            parentView.bringSubviewToFront(statefulView)
        } else {
            parentView.addSubview(statefulView)
            statefulView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                statefulView.topAnchor.constraint(equalTo: constrainedTargetView.topAnchor),
                statefulView.leadingAnchor.constraint(equalTo: constrainedTargetView.leadingAnchor),
                statefulView.bottomAnchor.constraint(equalTo: constrainedTargetView.bottomAnchor),
                statefulView.trailingAnchor.constraint(equalTo: constrainedTargetView.trailingAnchor),
            ])
        }
    }
}
