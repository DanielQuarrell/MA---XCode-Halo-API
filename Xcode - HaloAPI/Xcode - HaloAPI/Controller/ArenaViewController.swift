//
//  ArenaViewController.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 22/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import UIKit
import Charts

class ArenaViewController: UIViewController {
    
    @IBOutlet weak var killTypePieChartView: PieChartView!
    
    var killTypeDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPieChart()
    }
    
    func setUpPieChart(){
        
        killTypePieChartView.chartDescription?.enabled = false
        killTypePieChartView.drawHoleEnabled = true
        killTypePieChartView.rotationAngle = 0
        killTypePieChartView.drawEntryLabelsEnabled = false
        killTypePieChartView.isUserInteractionEnabled = false
        
        var entries: [PieChartDataEntry] = Array()
        entries.append(PieChartDataEntry(value: 10.0, label: "Standard"))
        entries.append(PieChartDataEntry(value: 5.0, label: "Power"))
        entries.append(PieChartDataEntry(value: 3.0, label: "Grenade"))
        entries.append(PieChartDataEntry(value: 2.0, label: "Vehicle"))
        entries.append(PieChartDataEntry(value: 4.0, label: "Turret"))
        entries.append(PieChartDataEntry(value: 1.0, label: "Unknown"))
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        
        let c1 = UIColor(hex: "#0091D5FF")
        let c2 = UIColor(hex: "#EA6A47FF")
        let c3 = UIColor(hex: "#7E909AFF")
        let c4 = UIColor(hex: "#A5D8DDFF")
        let c5 = UIColor(hex: "#F1F1F1FF")
        let c6 = UIColor(hex: "#1F3F49FF")
        
        
        dataSet.colors = [c1, c2, c3, c4, c5, c6] as! [NSUIColor]
        dataSet.drawValuesEnabled = false
        
        killTypePieChartView.data = PieChartData(dataSet: dataSet)
        
        guard let customFont = UIFont(name: "Nexa Light", size: UIFont.labelFontSize) else
        {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        killTypePieChartView.legend.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        killTypePieChartView.holeColor = UIColor(hex: "#00000000")
        
        let legend = killTypePieChartView.legend
        legend.orientation = .vertical
        legend.yEntrySpace = 5
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .center
        legend.textColor = UIColor.black
        legend.form = .circle
        legend.yOffset = -(((legend.textHeightMax * CGFloat(legend.entries.count)) + (legend.yEntrySpace * CGFloat(legend.entries.count - 1))) / 2)
        
        killTypePieChartView.legend.maxSizePercent = 0.3
    }
}
