//
//  SpySceneMachineViewProvider.swift
//  SceneMachineTests
//
//  Created by Duy Tran on 10/3/20.
//

import UIKit
@testable import SceneMachine

final class SpySceneMachineViewProvider: SceneMachineViewProvider {

    var invokedParentViewGetter = false
    var invokedParentViewGetterCount = 0
    var stubbedParentView: UIView!

    var parentView: UIView {
        invokedParentViewGetter = true
        invokedParentViewGetterCount += 1
        return stubbedParentView
    }

    var invokedConstrainedTargetViewGetter = false
    var invokedConstrainedTargetViewGetterCount = 0
    var stubbedConstrainedTargetView: UIView!

    var constrainedTargetView: UIView {
        invokedConstrainedTargetViewGetter = true
        invokedConstrainedTargetViewGetterCount += 1
        return stubbedConstrainedTargetView
    }

    var invokedContentViewGetter = false
    var invokedContentViewGetterCount = 0
    var stubbedContentView: UIView!

    var contentView: UIView {
        invokedContentViewGetter = true
        invokedContentViewGetterCount += 1
        return stubbedContentView
    }

    var invokedEmptyView = false
    var invokedEmptyViewCount = 0
    var stubbedEmptyViewResult: UIView!

    func emptyView() -> UIView? {
        invokedEmptyView = true
        invokedEmptyViewCount += 1
        return stubbedEmptyViewResult
    }

    var invokedLoadingView = false
    var invokedLoadingViewCount = 0
    var stubbedLoadingViewResult: UIView!

    func loadingView() -> UIView? {
        invokedLoadingView = true
        invokedLoadingViewCount += 1
        return stubbedLoadingViewResult
    }

    var invokedErrorView = false
    var invokedErrorViewCount = 0
    var invokedErrorViewParameters: (error: Error, Void)?
    var invokedErrorViewParametersList = [(error: Error, Void)]()
    var stubbedErrorViewResult: UIView!

    func errorView(error: Error) -> UIView? {
        invokedErrorView = true
        invokedErrorViewCount += 1
        invokedErrorViewParameters = (error, ())
        invokedErrorViewParametersList.append((error, ()))
        return stubbedErrorViewResult
    }
}
