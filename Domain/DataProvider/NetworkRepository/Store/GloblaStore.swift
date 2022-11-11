//
//  GloblaStore.swift
//  MarketCoins
//
//  Created by Robson Moreira on 06/11/22.
//

import Foundation

protocol GlobalStoreProtocol: GenericStoreProtocol {
    func fetchGlobal(completion: @escaping completion<GlobalModel?>)
}

class GloblaStore: GenericStoreRequest, GlobalStoreProtocol {
    
    func fetchGlobal(completion: @escaping completion<GlobalModel?>) {
        do {
            guard let url = try GlobalRouter.global.asURLRequest() else {
                return completion(nil, error)
            }
            request(url: url, completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
}
