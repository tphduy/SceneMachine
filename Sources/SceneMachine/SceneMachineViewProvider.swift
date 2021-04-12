//
//  SceneMachineViewProvider.swift
//  SceneMachine
//
//  Created by Duy Tran on 10/3/20.
//

import UIKit

/// Auxiliary part of `SceneMachine`, providing the appropriate views to represent a state.
public protocol SceneMachineViewProvider: AnyObject {
    
    /// A view that the stateful views should be added as subview.
    var parentView: UIView { get }
    
    /// A view that the stateful views should be equal to by constraint implementation.
    var constraintView: UIView { get }
    
    /// The actual underlying content view, that should be covered up by the stateful views.
    var contentView: UIView { get }
    
    /// A view that will cover the underlying content view up when having no data.
    func emptyView() -> UIView?
    
    /// A stateful view that will cover the underlying content view up when loading.
    func loadingView() -> UIView?
    
    /// A stateful view that will cover the underlying content view up when encountering an error.
    func errorView(error: Error) -> UIView?
}
