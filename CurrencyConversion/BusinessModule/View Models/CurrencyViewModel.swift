//
//  CurrencyViewModel.swift
//  CurrencyConversion
//
//  Created by Harshal Wani on 19/05/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import UIKit

class CurrencyViewModel: NSObject {
    
    /// Local
    private let apiService: APIServiceProtocol
    internal var enteredAmount: Float?
    internal var selectedCurrencyIndex: Int?
    
    internal var currencyCount: Int {
        return cellViewModels.count
    }
    private var cellViewModels: [CurrencyDataViewModel] = [CurrencyDataViewModel]() {
        didSet {
            self.updataCurrListData?()
            self.updataCurrConvertData?()
        }
    }
    
    // Closure
    var showAlert: ((String) -> Void)?
    var updataCurrListData: (() -> ())?
    var updataCurrConvertData: (() -> ())?
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    //MARK: - Private
    
    /// Create DataCellViewModel for collection view and append to cellViewModels
    /// - Parameter models: Array of Photo model
    private func processFetchedData(_ models: [String:String]) {
        self.cellViewModels = models.map { CurrencyDataViewModel(code: $0.key, name: $0.value)  }.sorted(by: ({ $0.name < $1.name }))
    }
    
    
    /// Calculate exchange rate with selected currecy
    /// - Parameter models: Dictionary of currency:amount
    private func calculateConversions(_ models: inout [String:Float]) {
        
        //1. Remove USD from all keys
        models.updateKeys { $0[3...] }
        
        //2. Convert selected currency amount to USD
        guard let index = self.selectedCurrencyIndex,
            let selectedCurrModel = self.getCellViewModel(at: index) as CurrencyDataViewModel?,
            let amount = models[selectedCurrModel.code],
            let enteredAmount = self.enteredAmount else {
                self.showAlert?(APIError.conversionIssue.rawValue)
                return
        }
        
        let selectedCurToUsd = enteredAmount / amount
        
        //3. Enumerate cellViewModels
        for (index, item) in self.cellViewModels.enumerated() {
            
            //4. Find and update amount
            let temp = models.filter { $0.key == item.code }
            if temp.isEmpty == false {
                if let rate = temp[self.cellViewModels[index].code] {
                    self.cellViewModels[index].amount = "\((selectedCurToUsd * rate).cleanValue)"
                }
            }
        }
    }
    
    //MARK: - Public
    
    /// Get all available currencies list
    func getCurrenciesList() {
        
        self.apiService.getDataFromURL(.currencyList()) { [weak self] (result) in
            switch result {
            case .success(let data):
                do {
                    //                    print(String(decoding: data, as: UTF8.self))
                    let response = try JSONDecoder().decode(CurrencyListResponse.self, from: data)
                    guard response.success == true else {
                        self?.showAlert?(response.errorMsg ?? APIError.unknownError.rawValue)
                        return
                    }
                    if let currencies = response.currencies {
                        self?.processFetchedData(currencies)
                    }
                    
                } catch {
                    self?.showAlert?(APIError.decodeError.rawValue)
                }
            case .failure(let err):
                self?.showAlert?(err.rawValue)
                
            }
        }
    }
    
    func getConversionRates() {
        
        let requestParam = ["currencies": self.cellViewModels.map {$0.code}.joined(separator: ",")]
        self.apiService.getDataFromURL(.currencyRate(items: requestParam)) { [weak self] (result) in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(CurrencyRateResponse.self, from: data)
                    guard response.success == true else {
                        self?.showAlert?(response.errorMsg ?? APIError.unknownError.rawValue)
                        return
                    }
                    if var quotes = response.quotes {
                    self?.calculateConversions(&quotes)
                    }
                } catch {
                    self?.showAlert?(APIError.decodeError.rawValue)
                }
            case .failure(let err):
                self?.showAlert?(err.rawValue)
                
            }
        }
    }
    
    /// Get DataCellViewModel from cellViewModels
    /// - Parameter index: query index number
    func getCellViewModel( at index: NSInteger ) -> CurrencyDataViewModel {
        return cellViewModels[index]
    }
    
}

// MARK:- DataCellViewModel

struct CurrencyDataViewModel {
    let code, name: String
    var amount, symbol: String?
    
    init(code: String, name: String) {
        self.code = code
        self.name = name
        self.symbol = Utilities.getCurrencySymbol(code)
    }
}

