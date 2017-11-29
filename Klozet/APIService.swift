//
//  APIService.swift
//  Klozet
//
//  Created by Marek Fořt on 11/29/17.
//  Copyright © 2017 Marek Fořt. All rights reserved.
//

import Foundation
import ReactiveSwift

enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
}

enum ConnectionError: Error {
    case URLError
    case DecodeError
    case NoDataError
}

protocol APIServicing {
    
}

class APIService: APIServicing {
    
    var serverPath: String = "http://139.59.144.155/klozet/"
    //let userManager = UserManager()
    
    static let serverTestPath: String = "https://private-2ac87a-bitesized.apiary-mock.com/api/"
    
    func getData(path: String) -> SignalProducer<Data, ConnectionError> {
        return SignalProducer<Data, ConnectionError> { [weak self] sink, disposable in
            guard let url = URL(string: path) else {sink.send(error: .URLError); return}
            let request = URLRequest(url: url)
            //request.setCredentialsHeader()
            self?.startTask(request: request, sink: sink)
        }
    }
    
    func startTask(request: URLRequest, sink: SignalProducer<Data, ConnectionError>.ProducedSignal.Observer) {
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else {sink.send(error: .NoDataError); return}
            sink.send(value: data)
            sink.sendCompleted()
        })
        task.resume()
    }
    
    
    
    func getCodableStruct<T: Decodable>(subpath: String, codableType: T.Type) -> SignalProducer<T, ServerError> {
        return SignalProducer { [weak self] sink, disposable in
            guard let serverPath = self?.serverPath else {return}
            self?.getData(path: serverPath + subpath).startWithResult { result in
                guard let structData = result.value else {sink.send(error: .defaultError); return}
                self?.decodeCodableData(data: structData, codableType: codableType, sink: sink)
            }
        }
    }
    
    func postDataWithBody(_ bodyData: Data, path: String) -> SignalProducer<Data, ConnectionError> {
        return SignalProducer<Data, ConnectionError> { [weak self] sink, disposable in
            guard let serverPath = self?.serverPath else {return}
            guard let url = URL(string: serverPath + path) else {sink.send(error: .URLError); return}
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = bodyData
            request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            //request.setCredentialsHeader()
            self?.startTask(request: request, sink: sink)
        }
    }
    
    func sendData(jsonDictionary: [String: Any], subpath: String, httpMethod: String) -> SignalProducer<Data, ConnectionError> {
        let serverPath = self.serverPath
        return SignalProducer<Data, ConnectionError> { [weak self] sink, disposable in
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonDictionary)
            guard let url = URL(string: serverPath + subpath) else {sink.send(error: .URLError); return}
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            request.httpBody = jsonData
            request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            //request.setCredentialsHeader()
            
            self?.startTask(request: request, sink: sink)
        }
    }
    
    func postData(jsonDictionary: [String: Any], subpath: String) -> SignalProducer<Data, ConnectionError> {
        return sendData(jsonDictionary: jsonDictionary, subpath: subpath, httpMethod: "POST")
    }
    
    func putData(jsonDictionary: [String: Any], subpath: String) -> SignalProducer<Data, ConnectionError> {
        return sendData(jsonDictionary: jsonDictionary, subpath: subpath, httpMethod: "PUT")
    }
    
    func decodeCodableData<T: Decodable>(data: Data, codableType: T.Type, sink: SignalProducer<T, ServerError>.ProducedSignal.Observer) {
        let decoder = JSONDecoder()
        do {
            let resultStruct: T = try decoder.decode(T.self, from: data)
            sink.send(value: resultStruct)
            sink.sendCompleted()
        }
        catch let error {
            print(error)
            guard let serverError = try? decoder.decode(ErrorStruct.self, from: data).error else {return}
            sink.send(error: serverError)
        }
    }
    
    
    func putCodableData<T: Decodable>(jsonDictionary: [String: Any], subpath: String, codableType: T.Type) -> SignalProducer<T, ServerError> {
        return SignalProducer { [weak self] sink, disposable in
            guard let strongSelf = self else {return}
            strongSelf.putData(jsonDictionary: jsonDictionary, subpath: subpath).startWithResult { result in
                guard let structData = result.value else {return}
                strongSelf.decodeCodableData(data: structData, codableType: codableType, sink: sink)
            }
        }
    }
    
    func postCodableData<T: Decodable>(jsonDictionary: [String: Any], subpath: String, codableType: T.Type) -> SignalProducer<T, ServerError> {
        return SignalProducer { [weak self] sink, disposable in
            self?.postData(jsonDictionary: jsonDictionary, subpath: subpath).startWithResult { result in
                guard let structData = result.value else {return}
                self?.decodeCodableData(data: structData, codableType: codableType, sink: sink)
            }
        }
    }
}
