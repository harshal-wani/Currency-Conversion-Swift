//
//  RootView+Extensions.swift
//  CurrencyConversion
//
//  Created by Harshal Wani on 19/05/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation
import UIKit

 private let MAX_AMOUNT_LENGHT      = 7
 private let ACCEPTABLE_NUMBERS     = "0123456789."

//MARK: - UITableViewDelegate and UITableViewDataSource delegates

extension RootView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90.0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currencyCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CurrencyCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(viewModel.getCellViewModel( at: indexPath.row ))
        return cell
    }
    
}

//MARK: - UIPickerView delegates

extension RootView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.currencyCount
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let model = viewModel.getCellViewModel( at: row )
        return "\(model.name) (\(model.code))"
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currencyText.text = viewModel.getCellViewModel( at: row ).code
    }
}

//MARK: - ToolbarPickerViewDelegate delegates

extension RootView: ToolbarPickerViewDelegate {
    
    @objc func didTapDone() {
        self.amountText.resignFirstResponder()
        self.currencyText.resignFirstResponder()

        if amountText.text?.utf8.count == 0 || currencyText.text?.utf8.count == 0{
            return
        }
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.viewModel.enteredAmount = (self.amountText.text! as NSString).floatValue
        self.viewModel.selectedCurrencyIndex = row
        self.viewModel.getConversionRates()
    }
    
    func didTapCancel() {
        self.currencyText.resignFirstResponder()
    }
}

//MARK: - UITextFieldDelegate delegates

extension RootView: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength: Int = textField.text!.count + string.count - range.length
        let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
        let strValid = string.rangeOfCharacter(from: numberOnly) == nil
        
         if let text = textField.text as NSString? {
               let updatedText = text.replacingCharacters(in: range, with: string)
            if Float(updatedText) != nil || Int(updatedText) != nil || updatedText == "" {
                return (strValid && (newLength <= MAX_AMOUNT_LENGHT) )
            }
        }
        return false
    }
    
    public override func endEditing(_ force: Bool) -> Bool {
        self.didTapDone()
        return true
    }

}
