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
            //Update cell when changed
            self.updateUI()
        }
    }
    
    func updateUI() {
        //If chart data exists, create the appropiate graph
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
        
        //Display graph only if data exists
        if(chartDataEntries.count > 0) {
            
            //Set up pie chart visuals
            pieChartView.isHidden = false
            pieChartView.chartDescription?.enabled = false
            pieChartView.drawHoleEnabled = true
            pieChartView.rotationAngle = 0
            pieChartView.drawEntryLabelsEnabled = false
            pieChartView.isUserInteractionEnabled = false
            pieChartView.holeColor = UIColor(hex: "#00000000")
            
            //Fill the pie chart with data
            let dataSet = PieChartDataSet(entries: chartDataEntries, label: "")
            
            //Set colours for the data set
            let c1 = UIColor(hex: "#0091D5FF")
            let c2 = UIColor(hex: "#FFA500FF")
            let c3 = UIColor(hex: "#006803FF")
            let c4 = UIColor(hex: "#6B0065FF")
            let c5 = UIColor(hex: "#F1F1F1FF")
            let c6 = UIColor(hex: "#1F3F49FF")
            
            dataSet.colors = [c1, c2, c3, c4, c5, c6] as! [NSUIColor]
            dataSet.drawValuesEnabled = false
            
            //Assign the data with colours to the view
            pieChartView.data = PieChartData(dataSet: dataSet)
            
            //Load the custom font into the legend
            guard let customFont = UIFont(name: "Nexa Light", size: UIFont.labelFontSize) else
            {
                fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
                )
            }
            
            //Set legend position and visuals
            pieChartView.legend.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
            
            let legend = pieChartView.legend
            legend.orientation = .vertical
            legend.yEntrySpace = 5
            legend.horizontalAlignment = .left
            legend.verticalAlignment = .center
            legend.textColor = UIColor.white
            legend.form = .circle
            
            legendOffset = 0
            legend.yOffset = legendOffset
            
            legend.maxSizePercent = 0.5
            
            //Play animation on creation
            pieChartView.animate(xAxisDuration: 3, yAxisDuration: 3)
            
        } else {
            pieChartView.isHidden = true
        }

    }
    
    func setUpBarChart(chartDataSets: [BarChartDataSet]){
        
        //Display graph only if data exists
        if(chartDataSets.count > 0) {
            barChartView.isHidden = false
            
            let chartData = BarChartData()
            
            //Set colours for the data set
            let c1 = UIColor(hex: "#0091D5FF")
            let c2 = UIColor(hex: "#FFA500FF")
            let c3 = UIColor(hex: "#8C0085FF")
            let c4 = UIColor(hex: "#007A04FF")
            let c5 = UIColor(hex: "#F1F1F1FF")
            let c6 = UIColor(hex: "#A5D8DDFF")
            
            let colors = [c1, c2, c3, c4, c5, c6] as! [NSUIColor]
            
            //For each statistic, create a new bar on the bar chart
            for i in 0..<chartDataSets.count {
                let dataSet = chartDataSets[i]
                
                dataSet.colors = [colors[i]]
                dataSet.drawValuesEnabled = false
                chartData.addDataSet(dataSet)
            }
            
            //Assign the data with colours to the view
            barChartView.data = chartData
            
            //Load the custom font into the legend
            guard let customFont = UIFont(name: "Nexa Light", size: UIFont.labelFontSize) else
            {
                fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
                )
            }
            
            //Set up bar chart visuals
            barChartView.xAxis.drawAxisLineEnabled = false
            barChartView.xAxis.drawLabelsEnabled = false
            barChartView.xAxis.drawGridLinesEnabled = false
            barChartView.leftAxis.drawLabelsEnabled = false
            barChartView.rightAxis.labelTextColor = UIColor.white
            barChartView.legend.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
            
            //Set legend position and visuals
            let legend = barChartView.legend
            legend.orientation = .vertical
            legend.yEntrySpace = 5
            legend.horizontalAlignment = .left
            legend.verticalAlignment = .center
            legend.textColor = UIColor.white
            legend.form = .circle
            legend.maxSizePercent = 0.8
            
            //Play animation on creation
            barChartView.animate(xAxisDuration: 3, yAxisDuration: 3)
            
        } else {
            barChartView.isHidden = true
        }
        
    }
    
    func updateLegends(){
        //Update legend position to original offset
        pieChartView.legend.yOffset = legendOffset
        barChartView.legend.yOffset = legendOffset
    }
}
