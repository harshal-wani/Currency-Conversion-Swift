//
//  CurrencyConversionTests.swift
//  CurrencyConversionTests
//
//  Created by Harshal Wani on 17/05/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import XCTest
@testable import CurrencyConversion

class CurrencyConversionTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
    
    func testIsInternetAvailable() {
        if Utilities.isInternetAvailable() {
            XCTAssertTrue(Utilities.isInternetAvailable())
        } else {
            XCTAssertFalse(Utilities.isInternetAvailable())
        }
    }
    
    func testDataCellViewModel() {
        
        let currencyDataViewModel = CurrencyDataViewModel(code: "USD", name: "United States Dollar")
        let symbol = "$"
        XCTAssertEqual("USD", currencyDataViewModel.code)
        XCTAssertEqual("United States Dollar", currencyDataViewModel.name)
        XCTAssertEqual(symbol, currencyDataViewModel.symbol)
    }
}
