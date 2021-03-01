//
//  APIError.swift
//  SceneMachine-Example
//
//  Created by Duy Tran on 01/03/2021.
//

import Foundation

struct APIError: LocalizedError {
    
    var errorDescription: String? {
        NSLocalizedString("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", comment: "")
    }
}
