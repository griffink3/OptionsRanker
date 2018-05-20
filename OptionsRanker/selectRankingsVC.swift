//
//  selectRankingsVC.swift
//  OptionsRanker
//
//  Created by Griffin on 5/20/18.
//  Copyright © 2018 Revive Brand Management. All rights reserved.
//

import UIKit

class selectRankingsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var personControl: UISegmentedControl!
    @IBOutlet weak var rankingsPicker: UIPickerView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var setRankingButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedPeople: [Person] = [Person]()
    var optionsGroup: OptionsGroup = OptionsGroup(name: "", options: [String]())
    var indexToPerson: Dictionary<Int, Person> = [Int: Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        errorLabel.adjustsFontSizeToFitWidth = true
        errorLabel.textAlignment = .center
        errorLabel.text = ""
        selectedPeople = appDelegate.selectedPeople
        optionsGroup = appDelegate.selectedGroup
        rankingsPicker.delegate = self
        rankingsPicker.dataSource = self
        setPersonControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "continueToRankings") {
            for person in selectedPeople {
                if (!person.hasGroup()) {
                    errorLabel.text = "You must set rankings for each person"
                    return false
                }
            }
            var optionToUtility: Dictionary<String, Int> = [String: Int]()
            for person in selectedPeople {
                var index: Int = 0
                for option in person.optionsGroup.options {
                    if (optionToUtility[option] == nil) {
                        optionToUtility[option] = index*10
                    } else {
                        optionToUtility[option] = optionToUtility[option]! + index*10
                    }
                    index = index + 1
                }
            }
            appDelegate.optionToUtility = optionToUtility
        }
        errorLabel.text = ""
        return true
    }
    
    func setPersonControl() {
        personControl.removeAllSegments()
        var index: Int = 0
        for person in selectedPeople {
            personControl.insertSegment(withTitle: person.name, at: index, animated: false)
            indexToPerson[index] = person
            index = index + 1
        }
    }
    
    func findIndex(option: String) -> Int {
        var index: Int = 0
        for o in optionsGroup.options {
            if (option == o) {
                return index
            }
            index = index + 1
        }
        return index
    }
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return optionsGroup.options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return optionsGroup.options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return optionsGroup.options[row]
    }
    
    // MARK: Actions
    @IBAction func setRanking(_ sender: UIButton) {
        if (personControl.selectedSegmentIndex < 0) {
            errorLabel.text = "Select a person to set rankings"
        } else {
            errorLabel.text = ""
            let currPerson: Person = indexToPerson[personControl.selectedSegmentIndex]!
            currPerson.setOptionsGroup(group: OptionsGroup(name: optionsGroup.name, options: [String]()))
            var index: Int = 0
            for _ in optionsGroup.options {
                let option: String = optionsGroup.options[rankingsPicker.selectedRow(inComponent: index)]
                if (currPerson.alreadyHasOption(option: option)) {
                    errorLabel.text = "You can't give an option two different rankings"
                    currPerson.setOptionsGroup(group: OptionsGroup(name: "", options: [String]()))
                    break
                } else {
                    errorLabel.text = "Set rankings for " + currPerson.name
                    currPerson.addOptionToOptionsGroupAtPosition(option: option, ranking: index)
                    index = index + 1
                }
            }
        }
    }
    
    @IBAction func selectPerson(_ sender: UISegmentedControl) {
        errorLabel.text = ""
        let currPerson: Person = indexToPerson[personControl.selectedSegmentIndex]!
        if (currPerson.hasGroup()) {
            var index: Int = 0
            for _ in optionsGroup.options {
                let option: String = currPerson.optionsGroup.options[index]
                rankingsPicker.selectRow(findIndex(option: option), inComponent: index, animated: true)
                index = index + 1
            }
        }
    }
    
    
    
}

