//
//  Layout.swift
//  CurrencyConversion
//
//  Created by Harshal Wani on 22/05/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation
import UIKit

public protocol PaddingProtocol {
    var left: CGFloat { get set }
    var right: CGFloat { get set }
    var top: CGFloat { get set }
    var bottom: CGFloat { get set }
}

public struct ComponentPadding: PaddingProtocol {
    public var left: CGFloat = 16.0
    public var right: CGFloat = 16.0
    public var top: CGFloat = 16.0
    public var bottom: CGFloat = 16.0
}
