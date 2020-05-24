//
//  Currency.swift
//  CurrencyConversion
//
//  Created by Harshal Wani on 19/05/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation

struct CurrencyListResponse: Decodable {
    let success: Bool
    let currencies: [String:String]?
    let errorMsg: String?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case currencies = "currencies"
        case error = "error"
        case info = "info"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        currencies = try container.decodeIfPresent([String:String].self, forKey: .currencies)
        
        if container.contains(.error) {
            let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
            errorMsg = try response.decodeIfPresent(String.self, forKey: .info)
        } else {
            errorMsg = nil
        }
    }
    
}

struct CurrencyRateResponse: Decodable {
    let source: String
    let success: Bool
    var quotes: [String:Float]?
    let errorMsg: String?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case source = "source"
        case quotes = "quotes"
        case error = "error"
        case info = "info"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        source = try container.decode(String.self, forKey: .source)
        quotes = try container.decodeIfPresent([String:Float].self, forKey: .quotes)
        
        if container.contains(.error) {
            let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
            errorMsg = try response.decodeIfPresent(String.self, forKey: .info)
        } else {
            errorMsg = nil
        }
    }
}

