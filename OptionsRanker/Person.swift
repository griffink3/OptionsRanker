//
//  Person.swift
//  OptionsRanker
//
//  Created by Griffin on 5/19/18.
//  Copyright © 2018 Revive Brand Management. All rights reserved.
//

import Foundation
import os.log

class Person: NSObject, NSCoding {
    
    struct PropertyKey {
        static let name = "name"
    }
    
    // MARK: Properties
    var name: String
    var optionsGroup = OptionsGroup(name: "", options: [String]())
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("people")
    
    // MARK: Initialization
    init(name: String) {
        self.name = name
    }
    
    func setOptionsGroup(group: OptionsGroup) {
        optionsGroup = group
    }
    
    func alreadyHasOption(option: String) -> Bool {
        return optionsGroup.hasOption(option: option)
    }
    
    func hasGroup() -> Bool {
        if (optionsGroup.name == "") {
            return false
        }
        return true
    }
    
    func addOptionToOptionsGroupAtPosition(option: String, ranking: Int) {
        optionsGroup.addOptionAtPosition(option: option, ranking: ranking)
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a person object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(name: name)
    }

}
