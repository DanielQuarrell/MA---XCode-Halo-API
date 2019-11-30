//
//  StatisticGraphData.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 24/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import Foundation
import Charts

class StatisticGraph {
    
    var title: String?
    var pieChartData: [PieChartDataEntry]?
    var barChartData: [BarChartDataSet]?
    
    init(title: String? = nil, pieChartData: [PieChartDataEntry]? = nil, barChartData: [BarChartDataSet]? = nil){
        self.title = title
        self.pieChartData = pieChartData
        self.barChartData = barChartData
    }
    
    func createPieChartData(chartData: [Statistic]) {
        var pieChartDataEntries: [PieChartDataEntry] = Array()
        
        for i in 0..<chartData.count {
            pieChartDataEntries.append(PieChartDataEntry(value: Double(chartData[i].value!), label: chartData[i].name))
        }
        
        self.pieChartData = pieChartDataEntries
    }
    
    func createBarChartData(chartData: [Statistic]) {
        
        var barChartDataSets: [BarChartDataSet] = Array()
        
        for i in 0..<chartData.count {
            var dataSet: [BarChartDataEntry] = Array()
            dataSet.append(BarChartDataEntry(x: Double(i), y: Double(chartData[i].value!)))
            
            barChartDataSets.append(BarChartDataSet(entries: dataSet, label: chartData[i].name))
        }
        
        self.barChartData = barChartDataSets
    }
}
