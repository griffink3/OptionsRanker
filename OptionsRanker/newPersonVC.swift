//
//  newPersonVC.swift
//  OptionsRanker
//
//  Created by Griffin on 5/19/18.
//  Copyright © 2018 Revive Brand Management. All rights reserved.
//

import UIKit

class newPersonVC: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var name: String = ""
    var people: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        errorLabel.text = " "
        errorLabel.adjustsFontSizeToFitWidth = true
        errorLabel.textAlignment = .center
        nameField.delegate = self
        getNames()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNames() {
        for person in appDelegate.personArray {
            people.append(person.name)
        }
    }
    
    override func shouldPerformSegue(withIdentifier: String, sender: Any!) -> Bool {
        if withIdentifier == "addPerson" {
            if (name == "") {
                return false
            }
        }
        return true
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        name = textField.text!
    }
    
    // MARK: Actions
    
    @IBAction func addPerson(_ sender: UIButton) {
        if (name != "" || !people.contains(name)) {
            appDelegate.newPerson = name
        } else {
            errorLabel.text = "Please enter a name - one that doesn't already exist"
        }
    }
    
}


