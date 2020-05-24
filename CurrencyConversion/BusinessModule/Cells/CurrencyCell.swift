//
//  CurrencyCell.swift
//  CurrencyConversion
//
//  Created by Harshal Wani on 18/05/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import UIKit
import FlexLayout

final class CurrencyCell: UITableViewCell, ReusableView {
    
    /// Local
    public static let reusableId: String = "CurrencyCell"
    private var padding: PaddingProtocol = ComponentPadding()

    //MARK: - UI Controls
    private var codeLabel = UILabel()
    private var nameLabel = UILabel()
    private var amountLabel = UILabel()
    
    //MARK: Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        selectionStyle = .none
        accessoryType = .none
        layout()
        layoutElements()
        
    }
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    //MARK: Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout(mode: .fitContainer)
    }
    
    //MARK: Private methods
    
    private func layout() {
        contentView.flex.direction(.row).grow(1).justifyContent(.spaceBetween).define { (flex) in
            
            flex.addItem().direction(.column).padding(padding.top).define({ (flex) in
                flex.addItem(codeLabel).grow(1)
                flex.addItem(nameLabel).grow(2)
                
            })
            flex.addItem().direction(.column).justifyContent(.spaceBetween).padding(padding.top).define({ (flex) in
                flex.addItem(amountLabel).grow(1).alignSelf(.center)
            })
        }
    }
    
    private func layoutElements() {
        codeLabel.font = UIFont.systemFont(ofSize: 18)
        
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = .gray
        
        amountLabel.font = UIFont.boldSystemFont(ofSize: 25)
        amountLabel.textAlignment = .right
    }
    
    //MARK: Public methods
    
    internal func configure(_ currencyDataViewModel : CurrencyDataViewModel) {
        codeLabel.text = "\(currencyDataViewModel.code)"
        codeLabel.flex.markDirty()
        
        nameLabel.text = "\(currencyDataViewModel.name)"
        nameLabel.flex.markDirty()
        
        if let amount = currencyDataViewModel.amount, let symbol = currencyDataViewModel.symbol{
            amountLabel.text = "\(symbol) \(amount)"
        }
        amountLabel.flex.markDirty()
        setNeedsLayout()
        
    }
}
