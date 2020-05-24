//
//  RootView.swift
//  CurrencyConversion
//
//  Created by Harshal Wani on 17/05/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

final class RootView: UIView {
    
    ///Local
    internal lazy var viewModel: CurrencyViewModel = {
        return CurrencyViewModel()
    }()
    
    private let padding: PaddingProtocol = ComponentPadding()
    
    //MARK: - UI Controls
    fileprivate let root = UIView()
    
    internal lazy var pickerView: ToolbarPickerView = {
        let picker = ToolbarPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.toolbarDelegate = self
        return picker
    }()
    
    internal lazy var currencyText: UITextField = {
        let textfield = UITextField()
        textfield.keyboardType = UIKeyboardType.default
        var imageView = UIImageView();
        var image = UIImage(named: "ic-down");
        imageView.image = image;
        textfield.rightView = imageView
        textfield.rightViewMode = .always
        textfield.font = UIFont.systemFont(ofSize: 18)
        textfield.placeholder = LocalizableStrings.selectCurrency
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.inputView = self.pickerView
        textfield.inputAccessoryView = self.pickerView.toolbar
        return textfield
    }()
    
    internal lazy var amountText: UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.textAlignment = .right
        textfield.font = UIFont.systemFont(ofSize: 20)
        textfield.keyboardType = UIKeyboardType.decimalPad
        textfield.returnKeyType = UIReturnKeyType.done
        textfield.placeholder = LocalizableStrings.enterAmount
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        return textfield
    }()
    
    private lazy var currencyTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CurrencyCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorColor = .gray
        tableView.isEditing = false
        tableView.showsVerticalScrollIndicator = true
        tableView.isScrollEnabled = true
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    
    //MARK: - Initialize
    
    init() {
        super.init(frame: .zero)
        configure()
        layout()
        viewModelClosures()
        requestGetCurrencies()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View life cyle
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        root.pin.all(pin.safeArea)
        root.flex.layout(mode: .fitContainer)
        currencyTableView.pin.bottom().below(of: currencyText).marginTop(20)
    }
    
    //MARK: - Private methods
    
    private func configure() {
        root.backgroundColor = .tertiarySystemGroupedBackground
        
    }
    
    private func layout() {
        root.flex.direction(.column).define { (flex) in
            flex.addItem().direction(.row).define { (flex) in
                flex.addItem(amountText).height(50).margin(padding.top, padding.left, padding.bottom, padding.right).grow(1)
                flex.addItem(currencyText).height(50).width(170).marginTop(padding.top).marginRight(padding.right)
            }
            flex.addItem(currencyTableView).grow(1)
        }
        addSubview(root)
    }
    
    private func viewModelClosures() {
        
        /// Naive binding
        viewModel.showAlert = { (message) in
            DispatchQueue.main.async {
                UIAlertController.showAlert(title: LocalizableStrings.error, message: message, cancelButton: LocalizableStrings.ok)
            }
        }
        viewModel.updataCurrListData = { [weak self] () in
            DispatchQueue.main.async {
                self?.pickerView.reloadAllComponents()
            }
        }
        viewModel.updataCurrConvertData = { [weak self] () in
            DispatchQueue.main.async {
                self?.currencyTableView.reloadData()
            }
            
        }
    }
    
    internal func requestGetCurrencies() {
        viewModel.getCurrenciesList()
    }
}
