//
//  OptionsGroup.swift
//  OptionsRanker
//
//  Created by Griffin on 5/19/18.
//  Copyright © 2018 Revive Brand Management. All rights reserved.
//

import Foundation
import os.log

class OptionsGroup: NSObject, NSCoding {
    
    struct PropertyKey {
        static let name = "name"
        static let options = "options"
    }
    
    // MARK: Properties
    var name: String
    var options: [String]
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("optionsGroups")
    
    // MARK: Initialization
    init(name: String, options: [String]) {
        self.name = name
        self.options = options
    }
    
    func addOptionAtPosition(option: String, ranking: Int) {
        options.insert(option, at: ranking)
    }
    
    func addOption(option: String) {
        options.append(option)
    }
    
    func hasOption(option: String) -> Bool {
        for o in options {
            if (option == o) {
                return true
            }
        }
        return false
    }

    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(options, forKey: PropertyKey.options)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for an optionsGroup object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let options = aDecoder.decodeObject(forKey: PropertyKey.options) as? [String] else {
            os_log("Unable to decode the options for an optionsGroup object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(name: name, options: options)
    }
    
}


