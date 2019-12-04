//
//  GraphCollectionViewCell.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 24/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import UIKit
import Charts

class GraphCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!
    static let identifier = "GraphCollectionViewCell"
    
    var legendOffset: CGFloat = 0
    
    var graph: StatisticGraph! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let graph = graph {
            if graph.pieChartData != nil {
                setUpPieChart(chartDataEntries: graph.pieChartData!)
                barChartView.noDataText = ""
            }
            if graph.barChartData != nil {
                setUpBarChart(chartDataSets: graph.barChartData!)
                pieChartView.noDataText = ""
            }
            
        } else {
            pieChartView = nil
            barChartView = nil
        }
    }
    
    func setUpPieChart(chartDataEntries: [PieChartDataEntry]){
        
        if(chartDataEntries.count > 0) {
            
            pieChartView.isHidden = false
            pieChartView.chartDescription?.enabled = false
            pieChartView.drawHoleEnabled = true
            pieChartView.rotationAngle = 0
            pieChartView.drawEntryLabelsEnabled = false
            pieChartView.isUserInteractionEnabled = false
            
            let dataSet = PieChartDataSet(entries: chartDataEntries, label: "")
            
            let c1 = UIColor(hex: "#0091D5FF")
            let c2 = UIColor(hex: "#EA6A47FF")
            let c3 = UIColor(hex: "#7E909AFF")
            let c4 = UIColor(hex: "#A5D8DDFF")
            let c5 = UIColor(hex: "#F1F1F1FF")
            let c6 = UIColor(hex: "#1F3F49FF")
            
            dataSet.colors = [c1, c2, c3, c4, c5, c6] as! [NSUIColor]
            dataSet.drawValuesEnabled = false
            
            pieChartView.data = PieChartData(dataSet: dataSet)
            
            guard let customFont = UIFont(name: "Nexa Light", size: UIFont.labelFontSize) else
            {
                fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
                )
            }
            
            pieChartView.legend.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
            pieChartView.holeColor = UIColor(hex: "#00000000")
            
            let legend = pieChartView.legend
            legend.orientation = .vertical
            legend.yEntrySpace = 5
            legend.horizontalAlignment = .left
            legend.verticalAlignment = .center
            legend.textColor = UIColor.black
            legend.form = .circle
            
            let textSize = legend.getMaximumEntrySize(withFont: pieChartView.legend.font)
            
            legendOffset = 0
            //legendOffset = -((textSize.height * CGFloat(pieChartView.legend.entries.count)) / 2)
            legend.yOffset = legendOffset
            
            legend.maxSizePercent = 0.5
            
            pieChartView.animate(xAxisDuration: 3, yAxisDuration: 3)
            
        } else {
            pieChartView.isHidden = true
        }

    }
    
    func setUpBarChart(chartDataSets: [BarChartDataSet]){
        
        if(chartDataSets.count > 0) {
            barChartView.isHidden = false
            
            let chartData = BarChartData()
            
            let c1 = UIColor(hex: "#0091D5FF")
            let c2 = UIColor(hex: "#EA6A47FF")
            let c3 = UIColor(hex: "#7E909AFF")
            let c4 = UIColor(hex: "#A5D8DDFF")
            let c5 = UIColor(hex: "#F1F1F1FF")
            let c6 = UIColor(hex: "#1F3F49FF")
            
            let colors = [c1, c2, c3, c4, c5, c6] as! [NSUIColor]
            
            for i in 0..<chartDataSets.count {
                let dataSet = chartDataSets[i]
                
                dataSet.colors = [colors[i]] as! [NSUIColor]
                dataSet.drawValuesEnabled = false
                chartData.addDataSet(dataSet)
            }
            
            barChartView.data = chartData
            
            guard let customFont = UIFont(name: "Nexa Light", size: UIFont.labelFontSize) else
            {
                fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
                )
            }
            
            barChartView.xAxis.drawAxisLineEnabled = false
            barChartView.xAxis.drawLabelsEnabled = false
            barChartView.xAxis.drawGridLinesEnabled = false
            
            barChartView.legend.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
            
            let legend = barChartView.legend
            legend.orientation = .vertical
            legend.yEntrySpace = 5
            legend.horizontalAlignment = .left
            legend.verticalAlignment = .center
            legend.textColor = UIColor.black
            legend.form = .circle
            legend.maxSizePercent = 0.5
            
            barChartView.animate(xAxisDuration: 3, yAxisDuration: 3)
            
        } else {
            barChartView.isHidden = true
        }
        
    }
    
    func updateLegends(){
        pieChartView.legend.yOffset = legendOffset
        barChartView.legend.yOffset = legendOffset
    }
}
