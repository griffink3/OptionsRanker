//
//  ViewController.swift
//  OptionsRanker
//
//  Created by Griffin on 5/19/18.
//  Copyright © 2018 Revive Brand Management. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var newPersonButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var personTable: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var personArray = [Person]()
    var shouldSegue: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        errorLabel.adjustsFontSizeToFitWidth = true
        errorLabel.textAlignment = .center
        errorLabel.text = ""
        personTable.register(UITableViewCell.self, forCellReuseIdentifier: "person")
        personTable.dataSource = self
        personTable.allowsSelection = true
        personTable.allowsMultipleSelection = true
        if (appDelegate.newPerson == "") {
            personArray = appDelegate.personArray
        }
        if let savePeople = loadPeople() {
            for person in savePeople {
                if (!checkName(people: personArray, name: person.name)) {
                    personArray.append(person)
                }
            }
        }
        if (appDelegate.newPerson != "") {
            personArray.append(Person(name: appDelegate.newPerson))
            appDelegate.newPerson = ""
        }
        savePeople()
        appDelegate.personArray = personArray
        appDelegate.selectedPeople.removeAll()
        shouldSegue = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "continue") {
            if (personTable.indexPathsForSelectedRows == nil) {
                errorLabel.text = "Please select people"
                shouldSegue = false
            } else {
                savePeople()
                shouldSegue = true
                errorLabel.text = ""
                for row in personTable.indexPathsForSelectedRows! {
                    appDelegate.selectedPeople.append(personArray[row.row])
                }
            }
            return shouldSegue
        }
        if (identifier == "back") {
            appDelegate.personArray.removeAll()
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = personTable.dequeueReusableCell(withIdentifier: "person", for: indexPath)
        cell.textLabel!.text = personArray[indexPath.row].name
        return cell
    }
    
    func checkName(people: [Person], name: String) -> Bool {
        for person in people {
            if (name == person.name) {
                return true
            }
        }
        return false
    }
    
    // MARK: Actions
    @IBAction func deletePerson(_ sender: UIButton) {
        if (personTable.indexPathsForSelectedRows == nil) {
            errorLabel.text = "Please select people"
        } else {
            errorLabel.text = ""
            var toDelete: [Person] = [Person]()
            for row in personTable.indexPathsForSelectedRows! {
                print(row.row)
                toDelete.append(personArray[row.row])
            }
            var temp: [Person] = [Person]()
            for person in personArray {
                var add: Bool = true
                for p in toDelete {
                    if (person.name == p.name) {
                        add = false
                    }
                }
                if (add) {
                    temp.append(person)
                }
            }
            personArray = temp
            savePeople()
            personTable.reloadData()
        }
    }
    
    @IBAction func selectPeople(_ sender: UIButton) {

    }

    // MARK: Private Methods
    private func savePeople() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(personArray, toFile: Person.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("People successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save people...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadPeople() -> [Person]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Person.ArchiveURL.path) as? [Person]
    }
    
}

