//
//  selectOptionsVC.swift
//  OptionsRanker
//
//  Created by Griffin on 5/19/18.
//  Copyright © 2018 Revive Brand Management. All rights reserved.
//


import UIKit
import os.log

class selectOptionsVC: UIViewController, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var newGroupButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var groupTable: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var groupArray = [OptionsGroup]()
    var shouldSegue: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        errorLabel.adjustsFontSizeToFitWidth = true
        errorLabel.textAlignment = .center
        errorLabel.text = ""
        groupTable.register(UITableViewCell.self, forCellReuseIdentifier: "group")
        groupTable.dataSource = self
        groupTable.allowsSelection = true
        groupTable.allowsMultipleSelection = false
        groupArray = appDelegate.groupArray
        if let saveGroups = loadGroups() {
            groupArray += saveGroups
        }
        if (appDelegate.newGroupName != "" && !appDelegate.newGroupOptions.isEmpty) {
            groupArray.append(OptionsGroup(name: appDelegate.newGroupName, options: appDelegate.newGroupOptions))
            appDelegate.newGroupName = ""
            appDelegate.newGroupOptions.removeAll()
        }
        saveGroups()
        appDelegate.groupArray = groupArray
        appDelegate.selectedGroup = OptionsGroup(name: "", options: [String]())
        shouldSegue = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "groupContinue") {
            if (groupTable.indexPathForSelectedRow == nil) {
                errorLabel.text = "Please select a group of options"
                shouldSegue = false
            } else {
                saveGroups()
                shouldSegue = true
                errorLabel.text = ""
                appDelegate.selectedGroup = groupArray[(groupTable.indexPathForSelectedRow?.row)!]
            }
            return shouldSegue
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTable.dequeueReusableCell(withIdentifier: "group", for: indexPath)
        cell.textLabel!.text = groupArray[indexPath.row].name
        return cell
    }
    
    // MARK: Actions
    @IBAction func deleteGroup(_ sender: UIButton) {
        if (groupTable.indexPathForSelectedRow == nil) {
            errorLabel.text = "Please select people"
        } else {
            errorLabel.text = ""
            groupArray.remove(at: (groupTable.indexPathForSelectedRow?.row)!)
            saveGroups()
            groupTable.reloadData()
        }
    }
    
    
    // MARK: Private Methods
    private func saveGroups() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(groupArray, toFile: Person.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("OptionsGroups successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save OptionsGroups...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadGroups() -> [OptionsGroup]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: OptionsGroup.ArchiveURL.path) as? [OptionsGroup]
    }
    
}

