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

class AddToiletViewModel: APIService, AddToiletViewModeling, ImagePostable {
    
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
            self?.uploadToiletData(toilet).startWithResult { result in
                guard let toiletId = result.value?.toiletId else {return}
                print(toiletId)
                if let toiletImage = toiletImage {
                    self?.postImage(image: toiletImage, toiletId: toiletId, uploadImageType: .toilet)
                }
                if let hoursImage = hoursImage {
                    self?.postImage(image: hoursImage, toiletId: toiletId, uploadImageType: .hours)
                }
            }
        }
    }
    
    private func uploadToiletData(_ toilet: Toilet) -> SignalProducer<ToiletId, ServerError> {
        return SignalProducer<ToiletId, ServerError> { [weak self] sink, disposable in
            guard let toiletDict = self?.createToiletDict(toilet) else {return}
            self?.postCodableData(jsonDictionary: toiletDict, subpath: "en", codableType: ToiletId.self).startWithResult { result in
                guard let toiletId = result.value else {sink.send(error: result.error ?? .defaultError); return}
                print(toiletId)
                sink.send(value: toiletId)
            }
        }
    }
}
