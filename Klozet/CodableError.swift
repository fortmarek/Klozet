//
//  CodableError.swift
//  Klozet
//
//  Created by Marek Fořt on 11/29/17.
//  Copyright © 2017 Marek Fořt. All rights reserved.
//

import Foundation


enum ServerError: String, Error {
    case alreadyRegistered = "Already Registered"
    case wrongUsernameOrPassword = "Wrong Email/Password"
    case defaultError = "Error"
}

struct ErrorStruct {
    let error: ServerError
}

extension ErrorStruct: Decodable {
    enum ErrorStructKeys: String, CodingKey {
        case errors = "errors"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ErrorStructKeys.self)
        let errors = try container.decode([CodableError].self, forKey: .errors)
        guard let error = errors.first else {self.init(error: .defaultError); return}
        let errorEnum: ServerError
        switch error.errorCode {
        case 402: errorEnum = .wrongUsernameOrPassword
        case 403: errorEnum = .alreadyRegistered
        default: errorEnum = .defaultError
        }
        self.init(error: errorEnum)
    }
}


struct CodableError {
    let errorCode: Int
    let errorDescription: String
}

extension CodableError: Decodable {
    enum CodableErrorKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorDescription = "error_description"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodableErrorKeys.self)
        let errorCode = try container.decode(Int.self, forKey: .errorCode)
        let errorDescription = try container.decode(String.self, forKey: .errorDescription)
        self.init(errorCode: errorCode, errorDescription: errorDescription)
    }
}
