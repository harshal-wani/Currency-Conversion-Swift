//
//  APIServiceTest.swift
//  CurrencyConversionTests
//
//  Created by Harshal Wani on 24/05/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import XCTest

@testable import CurrencyConversion

class APIServiceTest: XCTestCase {
    
    var aPIService: APIService?
    
    override func setUp() {
        super.setUp()
        aPIService = APIService()
    }

    override func tearDown() {
        aPIService = nil
        super.tearDown()
    }

    func testCurrencyListResponseDecoding() throws {
        
        let json = """
        {
           "success":true,
           "terms":"https://currencylayer.com/terms",
           "privacy":"https://currencylayer.com/privacy",
           "currencies":{
              "AED":"United Arab Emirates Dirham",
              "AFN":"Afghan Afghani",
              "ALL":"Albanian Lek",
              "AMD":"Armenian Dram",
              "ANG":"Netherlands Antillean Guilder",
              "AOA":"Angolan Kwanza",
              "ARS":"Argentine Peso",
              "AUD":"Australian Dollar",
              "USD":"United States Dollar"
           }
        }
        """.data(using: .utf8)!
        
        XCTAssertNoThrow(try JSONDecoder().decode(CurrencyListResponse.self, from: json))
    }
    
    func testCurrencyListAPISuccess() {

        // Given
        let aPIService = self.aPIService!

        // When search photo
        let expect = XCTestExpectation(description: "API called and returns success")

        aPIService.getDataFromURL(.currencyList()) { (result) in
            expect.fulfill()
            
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(CurrencyListResponse.self, from: data)
                    XCTAssertTrue(response.success)
                } catch {
                     XCTFail("Decode error")
                }
            case .failure(let err):
                XCTFail("error occured: \(err))")
                
            }
        }
        wait(for: [expect], timeout: 5.0)
    }
    
    func testCurrencyRateAPISuccess() {

        // Given
        let aPIService = self.aPIService!

        // When search photo
        let expect = XCTestExpectation(description: "API called and returns success")

        let requestParam = ["currencies": "USD, INR, NTD"]

        aPIService.getDataFromURL(.currencyRate(items: requestParam)) { (result) in
            expect.fulfill()
            
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(CurrencyListResponse.self, from: data)
                    XCTAssertTrue(response.success)
                } catch {
                     XCTFail("Decode error")
                }
            case .failure(let err):
                XCTFail("error occured: \(err))")
                
            }
        }
        wait(for: [expect], timeout: 5.0)
    }
}

