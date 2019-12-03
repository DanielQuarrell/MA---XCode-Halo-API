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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var leftStatistic: Statistic! {
        didSet {
            if let leftStatistic = leftStatistic {
                leftStat.text = leftStatistic.name
                
                if(leftStatistic.value == nil) {
                    leftValue.text = leftStatistic.valueString
                } else {
                    leftValue.text = String(format: "%.2f", leftStatistic.value!)
                }
                
            } else {
                leftStat = nil
                leftValue = nil
            }
        }
    }
    
    var rightStatistic: Statistic! {
        didSet {
            if let rightStatistic = rightStatistic {
                rightStat.text = rightStatistic.name
                if(rightStatistic.value == nil) {
                    rightValue.text = rightStatistic.valueString
                } else {
                    rightValue.text = String(format: "%.2f", rightStatistic.value!)
                }
            } else {
                rightStat = nil
                rightValue = nil
            }
        }
    }
}
