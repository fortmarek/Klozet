//
//  AddToiletViewModel.swift
//  Klozet
//
//  Created by Marek Fořt on 1/12/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import ReactiveSwift 

protocol AddToiletViewModeling {
    func uploadToilet(_ toilet: Toilet, hoursImage: UIImage?, toiletImage: UIImage?)  -> SignalProducer<Void, ServerError>
}

class AddToiletViewModel: APIService, AddToiletViewModeling {
    
    private func createToiletDict(_ toilet: Toilet) -> [String : Any] {
        var toiletDict: [String : Any] = [:]
        toiletDict["toilet_id"] = toilet.toiletId
        toiletDict["price"] = toilet.price
        toiletDict["open_times"] = []
        toiletDict["coordinates"] = [toilet.coordinate.longitude, toilet.coordinate.latitude]
        var addressDict: [String : Any] = [:]
        addressDict["main_address"] = toilet.title ?? ""
        addressDict["sub_address"] = toilet.subtitle ?? ""
        toiletDict["address"] = addressDict
        print(toiletDict)
        return toiletDict
    }
    
    
    func uploadToilet(_ toilet: Toilet, hoursImage: UIImage?, toiletImage: UIImage?) -> SignalProducer<Void, ServerError> {
        return SignalProducer<Void, ServerError> { [weak self] sink, disposable in
            guard let toiletDict = self?.createToiletDict(toilet) else {return}
            self?.postCodableData(jsonDictionary: toiletDict, subpath: "en", codableType: Toilet.self).startWithResult { result in
                guard result.error == nil else {sink.send(error: result.error ?? .defaultError); return}
                sink.sendCompleted()
            }
        }
        
    }
}
