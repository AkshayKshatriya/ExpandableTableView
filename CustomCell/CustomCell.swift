//
//  CustomCell.swift
//  ExpandableTableView
//
//  Created by akshay on 03/01/19.
//  Copyright © 2019 akshay. All rights reserved.
//

import UIKit

protocol CustomCellDelegate: class {
    func dateWasSelected(selectedDateString: String)
    func maritalStatusSwitchChangedState(isOn: Bool)
    func textfieldTextWasChanged(newText: String, parentCell: CustomCell)
    func sliderDidChangeValue(newSliderValue: String)
}

class CustomCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK: - IBOutlet Properties
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var slExperienceLevel: UISlider!
    @IBOutlet weak var lblSwitchLabel: UILabel!
    @IBOutlet weak var swMaritalStatus: UISwitch!
    
    //MARK: - constants
    let bigFont = UIFont(name: "Avenir-Book", size: 17.0)
    let smallFont = UIFont(name: "Avenir-Light", size: 17.0)
    let primaryColor = UIColor.black
    let secondaryColor = UIColor.lightGray
    
    // MARK: Variables
    weak var delegate: CustomCellDelegate!

    
    //MARK: - actions
    @IBAction func handleSliderValueChange(_ sender: Any) {
        if (delegate != nil){
            guard let level = slExperienceLevel?.value else {
                print("can't get experience level")
                return
            }
            delegate.sliderDidChangeValue(newSliderValue: "\(level)")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func handleSwitchStateChange(_ sender: Any) {
        if delegate != nil {
            delegate.maritalStatusSwitchChangedState(isOn: swMaritalStatus.isOn)
        }
    }

    @IBAction func setDate(_ sender: Any) {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateStyle = .long
        let dateString = dateFormatter.string(from: datePicker.date)
        if (delegate != nil)
        {
            delegate.dateWasSelected(selectedDateString: dateString)
        }
    }
    
    //MARK: - lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if (textLabel != nil)
        {
            textLabel?.font = bigFont
            textLabel?.textColor = primaryColor
        }
        
        if (detailTextLabel != nil)
        {
            detailTextLabel?.font = smallFont
            detailTextLabel?.textColor = secondaryColor
        }
        
        if (textField != nil)
        {
            textField.font = bigFont
            textField.delegate = self
        }
        
        if (lblSwitchLabel != nil)
        {
            lblSwitchLabel.font = bigFont
        }
        
        if (slExperienceLevel != nil) {
            slExperienceLevel.minimumValue = 0
            slExperienceLevel.maximumValue = 10.0
            slExperienceLevel.value = 0.0
        }
    }

    
}
