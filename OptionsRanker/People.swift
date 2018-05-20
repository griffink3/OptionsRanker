//
//  People.swift
//  OptionsRanker
//
//  Created by Griffin on 5/19/18.
//  Copyright © 2018 Revive Brand Management. All rights reserved.
//

import Foundation
import os.log

class People: NSObject, NSCoding {
    
    struct PropertyKey {
        static let people = "people"
    }
    
    // MARK: Properties
    var people: Dictionary<String, Person>
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("people")
    
    init(people: Dictionary<String, Person>) {
        self.people = people
    }
    
    func addPerson(name: String) {
        if (people[name] == nil) {
            people[name] = Person(name: name)
        }
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(people, forKey: PropertyKey.people)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let people = aDecoder.decodeObject(forKey: PropertyKey.people) as? Dictionary<String, Person> else {
            os_log("Unable to decode the people.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(people: people)
    }
    
}
