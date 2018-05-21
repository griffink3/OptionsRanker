//
//  calculatedRankingsVC.swift
//  OptionsRanker
//
//  Created by Griffin on 5/20/18.
//  Copyright © 2018 Revive Brand Management. All rights reserved.
//

import UIKit

class calculatedRankingsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var rankingsView: UIPickerView!
    @IBOutlet weak var utilityLabel: UILabel!
    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var optionToUtility: Dictionary<String, Int> = [String: Int]()
    var sortedOptions: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        rankingsView.delegate = self
        rankingsView.dataSource = self
        utilityLabel.adjustsFontSizeToFitWidth = true
        utilityLabel.textAlignment = .center
        utilityLabel.text = ""
        optionToUtility = appDelegate.optionToUtility
        calculateRankings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateRankings() {
        var dict: Dictionary<Int, [String]> = [Int: [String]]()
        var utilities: [Int] = [Int]()
        for (option, utility) in optionToUtility {
            if (dict[utility] == nil) {
                dict[utility] = [String]()
                dict[utility]?.append(option)
            } else {
                dict[utility]?.append(option)
            }
            utilities.append(utility)
        }
        utilities = utilities.sorted().reversed()
        for utility in utilities {
            for option in dict[utility]! {
                sortedOptions.append(option)
            }
        }
    }
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return optionToUtility.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortedOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        utilityLabel.text = String(optionToUtility[sortedOptions[row]]!)
    }

}
