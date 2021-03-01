//
//  SpySceneMachine.swift
//  SceneMachineTests
//
//  Created by Duy Tran on 10/5/20.
//

import Foundation
@testable import SceneMachine

final class SpySceneMachine<Item: Emptiable>: SceneMachine {
    
    var invokedPresent = false
    var invokedPresentCount = 0
    var invokedPresentParameters: (state: Loadable<Item>, provider: SceneMachineViewProvider)?
    var invokedPresentParametersList = [(state: Loadable<Item>, provider: SceneMachineViewProvider)]()

    func present(
        state: Loadable<Item>,
        provider: SceneMachineViewProvider) {
        invokedPresent = true
        invokedPresentCount += 1
        invokedPresentParameters = (state, provider)
        invokedPresentParametersList.append((state, provider))
    }
}
