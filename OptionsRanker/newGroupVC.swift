//
//  newGroupVC.swift
//  OptionsRanker
//
//  Created by Griffin on 5/19/18.
//  Copyright © 2018 Revive Brand Management. All rights reserved.
//

import UIKit

class newGroupVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var optionField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var optionsPicker: UIPickerView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var name = ""
    var optionName = ""
    var options: [String] = [String]()
    var groups: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        errorLabel.text = " "
        errorLabel.adjustsFontSizeToFitWidth = true
        errorLabel.textAlignment = .center
        nameField.delegate = self
        optionField.delegate = self
        optionsPicker.delegate = self
        optionsPicker.dataSource = self
        options.removeAll()
        getNames()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNames() {
        for group in appDelegate.groupArray {
            groups.append(group.name)
        }
    }
    
    override func shouldPerformSegue(withIdentifier: String, sender: Any!) -> Bool {
        if withIdentifier == "addGroup" {
            if (name == "" || options.isEmpty) {
                return false
            }
        }
        return true
    }
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.restorationIdentifier == "nameField") {
            name = textField.text!
        } else if (textField.restorationIdentifier == "optionField") {
            optionName = textField.text!
        }
    }
    
    // MARK: Actions
    @IBAction func addOption(_ sender: UIButton) {
        if (optionName != "") {
            options.append(optionName)
            optionsPicker.reloadAllComponents()
            optionName = ""
            errorLabel.text = ""
        } else {
            errorLabel.text = "Please enter a valid option"
        }
    }
    
    @IBAction func removeOption(_ sender: UIButton) {
        options.remove(at: optionsPicker.selectedRow(inComponent: 0))
        optionsPicker.reloadAllComponents()
    }
    
    @IBAction func addGroup(_ sender: UIButton) {
        if (options.isEmpty) {
            errorLabel.text = "Please add an option"
        } else if (name == "") {
            errorLabel.text = "Please enter a valid name"
        } else {
            appDelegate.newGroupName = name
            for option in options {
                appDelegate.newGroupOptions.append(option)
            }
        }
    }
    
    
}


