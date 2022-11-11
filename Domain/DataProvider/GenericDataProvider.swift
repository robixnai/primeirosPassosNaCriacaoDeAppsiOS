//
//  GenericDataProvider.swift
//  MarketCoins
//
//  Created by Robson Moreira on 06/11/22.
//

import Foundation

protocol GenericDataProviderDelegate {
    func success(model: Any)
    func errorData(_ provider: GenericDataProviderDelegate?, error: Error)
}

class DataProviderManager<T, S> {
    var delegate: T?
    var model: S?
}
