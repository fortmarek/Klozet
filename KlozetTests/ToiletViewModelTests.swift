//
//  ToiletViewModelTests.swift
//  KlozetTests
//
//  Created by Marek Fořt on 11/29/17.
//  Copyright © 2017 Marek Fořt. All rights reserved.
//

import XCTest
import Foundation
import ReactiveSwift
@testable import Klozet
import CoreLocation

class ToiletViewModelTests: XCTestCase {
    
    let toiletViewModelMock = ToiletViewModelMock()
    
    override func setUp() {
        super.setUp()
        
    }
    
    func testGettingToiletsGetsToilets() {
        let getToiletsExpectation = expectation(description: "Wait for getting toilets")
        
//        let expectedToilet = Toilet.init(title: "Ondříčkova 580/39", subtitle: "Close to Stadium", coordinate: CLLocationCoordinate2D.init(latitude: 14.456224317, longitude: 50.0823295810001) , openTimes: [OpenTimes(hours: ["08:00", "22:00"], days: [1, 2], isNonstop: false)], price: "5 CZK", toiletId: 1)
        
        toiletViewModelMock.toilets.producer.startWithValues { toilets in
            guard let toilet = toilets.first else {XCTFail(); return}
//            XCTAssertEqual(toilet.title, expectedToilet.title)
//            XCTAssertEqual(toilet.toiletId, expectedToilet.toiletId)
//            XCTAssertEqual(toilet.openTimes, expectedToilet.openTimes)
        }
        
        toiletViewModelMock.getToilets().startWithCompleted {
            getToiletsExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
}



class ToiletViewModelMock: ToiletViewModel {
    override init() {
        super.init()
        serverPath = "https://private-2ac87a-bitesized.apiary-mock.com/api/"
    }
}

