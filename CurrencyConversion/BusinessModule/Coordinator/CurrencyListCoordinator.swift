//
//  CurrencyListCoordinator.swift
//  CurrencyConversion
//
//  Created by Harshal Wani on 23/05/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import UIKit

final class CurrencyListCoordinator: Coordinator {
    
    private var presenter: UINavigationController
    private var currencyViewController: CurrencyViewController?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        let currencyViewController = CurrencyViewController()
        self.currencyViewController = currencyViewController
        presenter.pushViewController(currencyViewController, animated: true)
    }
}
