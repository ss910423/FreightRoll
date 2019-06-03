//
//  FRPickerView.swift
//  FreightrollMobile
//
//  Created by Nick Forte on 8/27/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit

class FRPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var pickerData : [String]!
    var pickerTextField : UITextField!
    var selectionHandler : ((_ selectedText: String) -> Void)?

    init(pickerData: [String], dropdownField: UITextField) {
        super.init(frame: CGRect.zero)
        
        self.pickerData = pickerData
        self.pickerTextField = dropdownField
        
        self.delegate = self
        self.dataSource = self
        
        DispatchQueue.main.async(execute: {
            if pickerData.count > 0 {
                self.pickerTextField.text = self.pickerData[0]
                self.pickerTextField.isEnabled = true
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.isEnabled = false
            }
        })
        
        if self.pickerTextField.text != nil && self.selectionHandler != nil {
            selectionHandler?(self.pickerTextField.text!)
        }
    }
    
    convenience init?(pickerData: [String], dropdownField: UITextField, onSelect selectionHandler : @escaping (_ selectedText: String) -> Void) {
        
        self.init(pickerData: pickerData, dropdownField: dropdownField)
        self.selectionHandler = selectionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerData[row]
        pickerTextField.endEditing(true)
        selectionHandler?(self.pickerTextField.text!)
    }
}

extension UITextField   {
    func loadDropdownData(data: [String]) {
        self.inputView = FRPickerView(pickerData: data, dropdownField: self)
    }
    
    func loadDropdownData(data: [String], onSelect selectionHandler : @escaping (_ selectedText: String) -> Void) {
        self.inputView = FRPickerView(pickerData: data, dropdownField: self, onSelect: selectionHandler)
    }
}
