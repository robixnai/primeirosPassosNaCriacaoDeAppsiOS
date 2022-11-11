//
//  CurrentDataDataProvider.swift
//  MarketCoins
//
//  Created by Robson Moreira on 07/11/22.
//

import Foundation

protocol CurrentDataDataProviderDelegate: GenericDataProviderDelegate { }

class CurrentDataDataProvider: DataProviderManager<CurrentDataDataProviderDelegate, CurrentDataModel> {
    
    private let coinStore: CoinsStoreProtocol?
    
    init(coinStore: CoinsStoreProtocol = CoinsStore()) {
        self.coinStore = coinStore
    }
    
    func fetchCoin(by id: String) {
        coinStore?.fetchCoin(by: id, completion: { result, error in
            if let error {
                self.delegate?.errorData(self.delegate, error: error)
            }
            
            if let result {
                self.delegate?.success(model: result)
            }
        })
    }
    
}
