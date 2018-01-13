//
//  AddToiletViewModel.swift
//  Klozet
//
//  Created by Marek Fořt on 1/12/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import ReactiveSwift 

protocol AddToiletViewModeling {
    func uploadToilet(_ toilet: Toilet, hoursImage: UIImage?, toiletImage: UIImage?)  -> SignalProducer<Void, ConnectionError>
}

class AddToiletViewModel: APIService, AddToiletViewModeling {
    
    
    func uploadToilet(_ toilet: Toilet, hoursImage: UIImage?, toiletImage: UIImage?) -> SignalProducer<Void, ConnectionError> {
        return SignalProducer<Void, ConnectionError> { sink, disposable in
            print(toilet)
            print(hoursImage)
            print(toiletImage)
        }
        
    }
}
