//
//  DataRepository.swift
//  SceneMachine-Example
//
//  Created by Duy Tran on 01/03/2021.
//

import Foundation

protocol DataRepository {
    
    func data(promise: @escaping (Result<[Int], Error>) -> Void)
}

struct DefaultDataRepository: DataRepository {
    
    func data(promise: @escaping (Result<[Int], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if Bool.random() {
                let data = stride(from: 0, to: 100, by: 1).map { $0 }
                promise(.success(data))
            } else {
                promise(.failure(APIError()))
            }
        }
    }
}
