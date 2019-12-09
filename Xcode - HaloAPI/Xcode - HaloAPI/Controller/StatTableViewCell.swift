//
//  StatTableViewCell.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 29/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import UIKit

class StatTableViewCell: UITableViewCell {

    @IBOutlet weak var leftStat: UILabel!
    @IBOutlet weak var leftValue: UILabel!
    @IBOutlet weak var rightStat: UILabel!
    @IBOutlet weak var rightValue: UILabel!
    
    static let identifier = "StatTableViewCell"
    
    var leftStatistic: Statistic! {
        didSet {
            //Update cell elements with statistic data
            if let leftStatistic = leftStatistic {
                leftStat.text = leftStatistic.name
                
                if(leftStatistic.value == nil) {
                    //Display stored string
                    leftValue.text = leftStatistic.valueString
                }
                else if (leftStatistic.isFloat!){
                    //Display float to 2 decimal places
                    leftValue.text = String(format: "%.2f", leftStatistic.value!)
                }
                else {
                    //Display value with no descimal places
                    leftValue.text = String(format: "%.0f", leftStatistic.value!)
                }
                
            } else {
                leftStat = nil
                leftValue = nil
            }
        }
    }
    
    var rightStatistic: Statistic! {
        didSet {
            //Update cell elements with statistic data
            if let rightStatistic = rightStatistic {
                rightStat.text = rightStatistic.name
                
                if(rightStatistic.value == nil) {
                    //Display stored string
                    rightValue.text = rightStatistic.valueString
                }
                else if (rightStatistic.isFloat!) {
                    //Display float to 2 decimal places
                    rightValue.text = String(format: "%.2f", rightStatistic.value!)
                }
                else {
                    //Display value with no descimal places
                    rightValue.text = String(format: "%.0f", rightStatistic.value!)
                }
            } else {
                rightStat = nil
                rightValue = nil
            }
        }
    }
}
