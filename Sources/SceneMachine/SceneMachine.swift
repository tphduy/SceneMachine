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
        _ state: Loadable<Item>,
        by provider: SceneMachineViewProvider)
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
        _ state: Loadable<Item>,
        by provider: SceneMachineViewProvider) {
        guard
            let statefulView = getStatefulView(
                represent: state,
                by: provider)
        else {
            return
        }
        
        present(
            statefulView,
            in: provider.parentView,
            equalTo: provider.constraintView)
    }
    
    /// Determine which view is appropriate to represent the state that is made by the provider, or nil if none is appropriate.
    /// - Parameters:
    ///   - state: The state to represent.
    ///   - provider: The provider to provide the appropriate view.
    /// - Returns: A view that represents the state.
    func getStatefulView(
        represent state: Loadable<Item>,
        by provider: SceneMachineViewProvider) -> UIView? {
        switch state {
        case .isLoading(.some):
            return provider.contentView
        case .isLoading(.none):
            return provider.loadingView()
        case let .loaded(item):
            return item.isEmpty
                ? provider.emptyView()
                : provider.contentView
        case let .failed(error):
            return provider.errorView(error: error)
        }
    }
    
    /// Presents a stateful view over the current content.
    /// - Parameters:
    ///   - view: A view to present  over the current content.
    ///   - parentView: A view that the stateful view should be added as subview.
    ///   - constraintView: A view that the stateful view should be constrained to.
    func present(
        _ view: UIView,
        in parentView: UIView,
        equalTo constraintView: UIView) {
        if view.isDescendant(of: parentView) {
            parentView.bringSubviewToFront(view)
        } else {
            parentView.addSubview(view)
            constraint(view, equalTo: constraintView)
        }
    }
    
    /// Implement the constraints that defines the first view’s edges as equal to the second view layout margin guide.
    /// - Parameters:
    ///   - firstView: The sender view.
    ///   - secondView: The target view.
    func constraint(
        _ firstView: UIView,
        equalTo secondView: UIView) {
        firstView.translatesAutoresizingMaskIntoConstraints = false
        let secondViewLayoutMarginsGuide = secondView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: secondViewLayoutMarginsGuide.topAnchor),
            firstView.leadingAnchor.constraint(equalTo: secondViewLayoutMarginsGuide.leadingAnchor),
            firstView.bottomAnchor.constraint(equalTo: secondViewLayoutMarginsGuide.bottomAnchor),
            firstView.trailingAnchor.constraint(equalTo: secondViewLayoutMarginsGuide.trailingAnchor),
        ])
    }
}
