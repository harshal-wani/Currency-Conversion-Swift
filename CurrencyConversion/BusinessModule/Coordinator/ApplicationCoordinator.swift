//
//  ApplicationCoordinator.swift
//  CurrencyConversion
//
//  Created by Harshal Wani on 23/05/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import UIKit

final class ApplicationCoordinator: Coordinator {
    
    private let window: UIWindow
    private let rootViewController: UINavigationController
    private var currencyListCoordinator: CurrencyListCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        currencyListCoordinator = CurrencyListCoordinator(presenter: rootViewController)
    }
    
    func start() {
        window.rootViewController = rootViewController
        currencyListCoordinator?.start()
        window.makeKeyAndVisible()
    }
}
